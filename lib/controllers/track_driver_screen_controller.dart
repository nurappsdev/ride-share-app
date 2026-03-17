import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/utils/app_constant.dart';

import '../helpers/app_url.dart';
import '../services/network/network_caller.dart';

class TrackDriverScreenController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString rideId = ''.obs;

  // Ride Data
  final RxString rideType = ''.obs;
  final RxInt seats = 0.obs;
  final RxInt passengers = 0.obs;
  final RxList<String> luggages = <String>[].obs;
  final RxString luggageDetails = ''.obs;
  final RxString note = ''.obs;
  final Rx<DateTime> dateTime = DateTime.now().obs;
  final RxDouble distance = 0.0.obs;
  final RxDouble fare = 0.0.obs;
  final RxDouble charge = 0.0.obs;
  final RxDouble totalFare = 0.0.obs;
  final RxString status = ''.obs;

  // Location Data
  final RxDouble fromLat = 0.0.obs;
  final RxDouble fromLng = 0.0.obs;
  final RxDouble toLat = 0.0.obs;
  final RxDouble toLng = 0.0.obs;
  final RxString fromAddress = ''.obs;
  final RxString toAddress = ''.obs;

  // Other User Data
  final RxString otherUserId = ''.obs;
  final RxString otherUserName = ''.obs;
  final RxString otherUserEmail = ''.obs;
  final RxString otherUserPhone = ''.obs;
  final RxString otherUserProfileImage = ''.obs;

  // Car Model Data
  final RxString carModelId = ''.obs;
  final RxString carModelName = ''.obs;
  final RxDouble carBaseFare = 0.0.obs;
  final RxDouble carPerKM = 0.0.obs;
  final RxDouble carCharge = 0.0.obs;

  // Map
  late GoogleMapController mapController;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxBool isMapCreated = false.obs;

  // User Role
  final RxString userRole = 'provider'.obs;

  // Ride Status getter (alias for status)
  RxString get rideStatus => status;

  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
    if (Get.arguments != null && Get.arguments['rideId'] != null) {
      String jobId = Get.arguments['rideId'].toString();
      setRideId(jobId);
    } else {
      LoggerUtils.error("No rideId found in Get.arguments!");
    }
  }

  Future<void> _loadUserRole() async {
    // Load user role from prefs if needed
    userRole.value = 'provider'; // Default, can be updated from prefs
  }

  void setRideId(String id) {
    rideId.value = id;
    fetchRideDetails();
  }

  /// Fetch ride details from API
  Future<void> fetchRideDetails() async {
    if (rideId.value.isEmpty) {
      LoggerUtils.error('Ride ID is empty');
      return;
    }

    isLoading.value = true;

    try {
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final response = await NetworkCaller().getRequest(
        '${AppUrl.baseUrl}/job/${rideId.value}',
        headers: {'Authorization': 'Bearer $token'},
      );

      LoggerUtils.info('Ride Details Response: $response');

      if (response.isSuccess && response.jsonResponse != null) {
        final responseData = response.jsonResponse!;
        final data = responseData['data'];

        if (data != null) {
          _parseRideData(data);
          _updateMarkers();
        }
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to load ride details';
        LoggerUtils.error('Failed to load ride: $errorMessage');
      }
    } catch (e) {
      LoggerUtils.error('Error fetching ride details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse ride data from API response
  void _parseRideData(Map<String, dynamic> data) {
    // Basic ride info
    rideId.value = data['_id'] ?? '';
    rideType.value = data['type'] ?? '';
    seats.value = data['seat'] ?? 0;
    passengers.value = data['passengers'] ?? 0;
    luggages.value = data['luggages'] != null ? List<String>.from(data['luggages']) : [];
    luggageDetails.value = data['luggageDetails'] ?? '';
    note.value = data['note'] ?? '';

    // DateTime
    if (data['dateTime'] != null) {
      dateTime.value = DateTime.parse(data['dateTime']).toLocal();
    }

    // Fare and distance
    distance.value = (data['distance'] ?? 0.0).toDouble();
    fare.value = (data['fare'] ?? 0.0).toDouble();
    charge.value = (data['charge'] ?? 0.0).toDouble();
    totalFare.value = (data['totalFare'] ?? 0.0).toDouble();
    status.value = data['status'] ?? '';

    // Car model
    final carModel = data['carModel'];
    if (carModel != null) {
      carModelId.value = carModel['_id'] ?? '';
      carModelName.value = carModel['name'] ?? 'Unknown';
      carBaseFare.value = (carModel['baseFare'] ?? 0.0).toDouble();
      carPerKM.value = (carModel['perKM'] ?? 0.0).toDouble();
      carCharge.value = (carModel['charge'] ?? 0.0).toDouble();
    }

    // Locations
    final fromLocation = data['fromLocation'];
    if (fromLocation != null && fromLocation['coordinates'] != null) {
      final coords = fromLocation['coordinates'] as List;
      fromLng.value = coords[0].toDouble();
      fromLat.value = coords[1].toDouble();
    }

    final toLocation = data['toLocation'];
    if (toLocation != null && toLocation['coordinates'] != null) {
      final coords = toLocation['coordinates'] as List;
      toLng.value = coords[0].toDouble();
      toLat.value = coords[1].toDouble();
    }

    fromAddress.value = data['fromAddress'] ?? 'Pickup location';
    toAddress.value = data['toAddress'] ?? 'Dropoff location';

    // Other user
    final otherUser = data['otherUser'];
    if (otherUser != null) {
      otherUserId.value = otherUser['_id'] ?? '';
      otherUserName.value = otherUser['name'] ?? 'Unknown';
      otherUserEmail.value = otherUser['email'] ?? '';
      otherUserPhone.value = otherUser['phone'] ?? '';
      otherUserProfileImage.value = otherUser['profileImage'] ?? '';
    }
  }

  /// Update map markers with from/to locations
  void _updateMarkers() {
    markers.clear();
    polylines.clear();

    // Add pickup marker
    if (fromLat.value != 0.0 && fromLng.value != 0.0) {
      markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(fromLat.value, fromLng.value),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Pickup Location'),
      ));
    }

    // Add dropoff marker
    if (toLat.value != 0.0 && toLng.value != 0.0) {
      markers.add(Marker(
        markerId: const MarkerId('dropoff'),
        position: LatLng(toLat.value, toLng.value),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Dropoff Location'),
      ));
    }

    // Add polyline between pickup and dropoff
    if (fromLat.value != 0.0 && fromLng.value != 0.0 &&
        toLat.value != 0.0 && toLng.value != 0.0) {
      polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: [
          LatLng(fromLat.value, fromLng.value),
          LatLng(toLat.value, toLng.value),
        ],
        color: const Color(0xFF7C3AED),
        width: 5,
        patterns: [
          PatternItem.dash(20),
          PatternItem.gap(10),
        ],
      ));
    }

    // Animate camera to show both markers
    if (markers.isNotEmpty) {
      _animateCameraToFitMarkers();
    }
  }

  /// Animate camera to fit both markers
  void _animateCameraToFitMarkers() {
    if (!isMapCreated.value || markers.isEmpty) return;

    final latLngs = markers.map((m) => m.position).toList();
    if (latLngs.length < 2) {
      // Single marker, just move to it
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(latLngs.first, 14),
      );
    } else {
      // Two markers, fit bounds
      final bounds = LatLngBounds(
        southwest: LatLng(
          latLngs.map((l) => l.latitude).reduce((a, b) => a < b ? a : b),
          latLngs.map((l) => l.longitude).reduce((a, b) => a < b ? a : b),
        ),
        northeast: LatLng(
          latLngs.map((l) => l.latitude).reduce((a, b) => a > b ? a : b),
          latLngs.map((l) => l.longitude).reduce((a, b) => a > b ? a : b),
        ),
      );

      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    }
  }

  /// Get profile image URL
  String get profileImageUrl {
    if (otherUserProfileImage.value.isEmpty) {
      return 'https://i.pravatar.cc/150?img=12';
    }
    if (otherUserProfileImage.value.startsWith('http')) {
      return otherUserProfileImage.value;
    }
    final baseDomain = AppUrl.baseUrl.replaceAll('/api/v1', '');
    return '$baseDomain/uploads/${otherUserProfileImage.value}';
  }

  /// Get arrival time string
  String getArrivalTimeString() {
    final now = DateTime.now();
    final difference = dateTime.value.difference(now);

    if (difference.isNegative) {
      return 'Arrived';
    }

    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);
    final minutes = difference.inMinutes.remainder(60);

    if (days > 0) {
      return days == 1 ? '1 day' : '$days days';
    }

    if (hours > 0) {
      return '$hours hr $minutes mins';
    } else {
      return '$minutes mins';
    }
  }

  /// Format time for display
  String get formattedTime {
    final hour = dateTime.value.hour;
    final minute = dateTime.value.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}

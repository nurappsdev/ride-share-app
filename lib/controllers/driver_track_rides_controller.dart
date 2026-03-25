import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/utils/app_constant.dart';

import '../helpers/app_url.dart';
import '../services/network/network_caller.dart';

class DriverTrackRidesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString jobId = ''.obs;

  // Ride Data
  final RxString rideId = ''.obs;
  final RxString rideType = ''.obs;
  final RxInt passengers = 0.obs;
  final RxList<String> luggages = <String>[].obs;
  final RxString luggageDetails = ''.obs;
  final RxString note = ''.obs;
  final Rx<DateTime> dateTime = DateTime.now().obs;
  final RxDouble distance = 0.0.obs;
  final RxDouble fare = 0.0.obs;
  final RxDouble totalFare = 0.0.obs;
  final RxString status = ''.obs;

  // Location Data
  final RxDouble fromLat = 0.0.obs;
  final RxDouble fromLng = 0.0.obs;
  final RxDouble toLat = 0.0.obs;
  final RxDouble toLng = 0.0.obs;
  final RxString fromAddress = ''.obs;
  final RxString toAddress = ''.obs;

  // Other User (Passenger/Provider) Data
  final RxString otherUserId = ''.obs;
  final RxString otherUserName = ''.obs;
  final RxString otherUserEmail = ''.obs;
  final RxString otherUserPhone = ''.obs;
  final RxString otherUserProfileImage = ''.obs;

  // Car Model Data
  final RxString carModelName = ''.obs;
  final RxInt carSeats = 0.obs;
  final RxDouble carBaseFare = 0.0.obs;
  final RxDouble carPerKM = 0.0.obs;

  // Map
  late GoogleMapController mapController;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxBool isMapCreated = false.obs;

  // User Role
  final RxString userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
    // jobId will be set via setJobId method
  }

  /// Load user role from prefs
  Future<void> _loadUserRole() async {
    try {
      userRole.value = await PrefsHelper.getString(AppConstants.role) ?? '';
    } catch (e) {
      LoggerUtils.error('Error loading user role: $e');
      userRole.value = ''; // Default to empty if failed
    }
  }

  void setJobId(String id) {
    jobId.value = id;
    fetchJobDetails();
  }

  /// Fetch job details from API
  Future<void> fetchJobDetails() async {
    if (jobId.value.isEmpty) {
      LoggerUtils.error('Job ID is empty');
      return;
    }

    isLoading.value = true;

    try {
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final response = await NetworkCaller().getRequest(
        '${AppUrl.baseUrl}/job/${jobId.value}',
        headers: {'Authorization': 'Bearer $token'},
      );

      LoggerUtils.info('Job Details Response: $response');

      if (response.isSuccess && response.jsonResponse != null) {
        final responseData = response.jsonResponse!;
        // Handle both nested 'data' and flat response structures
        Map<String, dynamic>? data = responseData['data'];
        if (data == null && responseData['_id'] != null) {
          // Flat structure - use response directly
          data = responseData;
        }
        
        if (data != null) {
          LoggerUtils.info('Parsed data status: ${data['status']}');
          _parseJobData(data);
          _updateMarkers();
        } else {
          LoggerUtils.error('Data is null in response');
          Get.snackbar('Error', 'No job data found', snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to load job details';
        LoggerUtils.error('Failed to load job: $errorMessage');
        Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      LoggerUtils.error('Error fetching job details: $e');
      Get.snackbar('Error', 'Something went wrong', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse job data from API response
  void _parseJobData(Map<String, dynamic> data) {
    // Basic ride info
    rideId.value = data['_id'] ?? '';
    rideType.value = data['type'] ?? '';
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
    totalFare.value = (data['totalFare'] ?? 0.0).toDouble();
    status.value = data['status'] ?? '';

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

    // Other user (passenger for provider, or provider for passenger)
    final otherUser = data['otherUser'];
    if (otherUser != null) {
      otherUserId.value = otherUser['_id'] ?? '';
      otherUserName.value = otherUser['name'] ?? 'Unknown';
      otherUserEmail.value = otherUser['email'] ?? '';
      otherUserPhone.value = otherUser['phone'] ?? '';
      otherUserProfileImage.value = otherUser['profileImage'] ?? '';
    }

    // Car model
    final carModel = data['carModel'];
    if (carModel != null) {
      carModelName.value = carModel['name'] ?? 'Unknown';
      carSeats.value = carModel['seat'] ?? 0;
      carBaseFare.value = (carModel['baseFare'] ?? 0.0).toDouble();
      carPerKM.value = (carModel['perKM'] ?? 0.0).toDouble();
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

  /// Format time for display
  String get formattedTime {
    final hour = dateTime.value.hour;
    final minute = dateTime.value.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  /// Get arrival time (adding buffer time)
  String get arrivalTime {
    final arrival = dateTime.value.subtract(const Duration(minutes: 10));
    final hour = arrival.hour;
    final minute = arrival.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
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

  /// Calculate arrival time string
  String getArrivalTimeString() {
    final now = DateTime.now();
    final difference = dateTime.value.difference(now);

    if (difference.isNegative) {
      return 'Arrived';
    }

    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);
    final minutes = difference.inMinutes.remainder(60);

    // If more than 1 day, show days
    if (days > 0) {
      if (days == 1) {
        return '1 day';
      } else {
        return '$days days';
      }
    }

    // If less than 1 day, show hours and minutes
    if (hours > 0) {
      return '$hours hr $minutes mins';
    } else {
      return '$minutes mins';
    }
  }

  /// Get action state based on user role and ride status (matches backend logic)
  /// Returns: 'pickup', 'complete', 'review', or null
  String? get actionState {
    // Provider + accepted = Show "Picked Up"
    if (userRole.value == 'provider' && status.value == 'accepted') {
      return 'pickup';
    }

    // User + picked = Show "Complete"
    if (userRole.value == 'user' && status.value == 'picked') {
      return 'complete';
    }

    // Provider + completed = Show "Review"
    if (userRole.value == 'provider' && status.value == 'completed') {
      return 'review';
    }

    // Default: no action button
    return null;
  }

  /// Get button text based on action state
  String get actionButtonText {
    switch (actionState) {
      case 'pickup':
        return 'Picked Up';
      case 'complete':
        return 'Complete';
      case 'review':
        return 'Review';
      default:
        return '';
    }
  }

  /// Get button icon based on action state
  IconData get actionButtonIcon {
    switch (actionState) {
      case 'pickup':
        return Icons.check;
      case 'complete':
        return Icons.flag;
      case 'review':
        return Icons.rate_review;
      default:
        return Icons.check;
    }
  }
}

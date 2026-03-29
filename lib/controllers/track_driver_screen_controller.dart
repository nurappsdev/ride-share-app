import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:split_ride/helpers/helpers.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../helpers/app_url.dart';
import '../services/network/network_caller.dart';
import '../services/socket_services.dart';

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

  // Real-time tracking
  Timer? _pollingTimer;

  // Ride Status getter (alias for status)
  RxString get rideStatus => status;
  
  // User Role getter
  bool get isProvider => userRole.value == 'provider';

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

  @override
  void onReady() {
    super.onReady();
    // Start listening to socket events for real-time tracking
    _setupSocketListeners();
    
    // Start polling as fallback (for passengers only)
    if (!isProvider) {
      // Wait a bit for socket to connect, then start polling
      Future.delayed(const Duration(seconds: 2), () {
        startLocationPolling();
      });
    }
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadUserRole() async {
    try {
      final savedRole = await PrefsHelper.getString(AppConstants.role);
      if (savedRole.isNotEmpty) {
        userRole.value = savedRole;
      } else {
        userRole.value = 'provider'; // Fallback default
      }
    } catch (e) {
      LoggerUtils.error('Error loading user role: $e');
      userRole.value = 'provider'; // Fallback default
    }
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

      LoggerUtils.info('Ride Details Response: ${response.jsonResponse}');

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

    // Add driver marker (if passenger viewing)
    if (!isProvider && fromLat.value != 0.0 && fromLng.value != 0.0) {
      markers.add(Marker(
        markerId: const MarkerId('driver'),
        position: LatLng(fromLat.value, fromLng.value),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: otherUserName.value),
      ));
    }

    // Animate camera to show both markers
    if (markers.isNotEmpty) {
      _animateCameraToFitMarkers();
    }
    
    // Draw route polyline after markers are set
    if (fromLat.value != 0.0 && fromLng.value != 0.0 &&
        toLat.value != 0.0 && toLng.value != 0.0) {
      _drawRoutePolyline();
    }
  }

  /// Draw route polyline using Google Directions API
  Future<void> _drawRoutePolyline() async {
    try {
      if (fromLat.value == 0.0 || fromLng.value == 0.0 ||
          toLat.value == 0.0 || toLng.value == 0.0) {
        LoggerUtils.error('❌ Cannot draw route: Missing coordinates (From: ${fromLat.value},${fromLng.value} To: ${toLat.value},${toLng.value})');
        return;
      }

      // Google Directions API expects: origin=lat,lng
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${fromLat.value},${fromLng.value}'
        '&destination=${toLat.value},${toLng.value}'
        '&mode=driving'
        '&key=${AppConstants.googleMapKey}',
      );

      LoggerUtils.info('🗺️ Fetching road-wise route from: ${fromLat.value},${fromLng.value} to ${toLat.value},${toLng.value}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final decodedPoints = _decodePolyline(points);
          
          LoggerUtils.info('✅ Successfully decoded ${decodedPoints.length} road-wise points');

          final routePolyline = Polyline(
            polylineId: const PolylineId('route_polyline'),
            points: decodedPoints,
            color: const Color(0xFF7C3AED), // Using theme color
            width: 5,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          );
          
          polylines.assign(routePolyline);
          polylines.refresh();
          
          // Update distance from API
          if (data['routes'][0]['legs'] != null && data['routes'][0]['legs'].isNotEmpty) {
            final leg = data['routes'][0]['legs'][0];
            final distanceInMeters = leg['distance']['value'];
            distance.value = (distanceInMeters / 1000).toDouble();
            LoggerUtils.info('📏 Updated road distance: ${distance.value} km');
          }
        } else {
          LoggerUtils.error('❌ Google Directions API Error: ${data['status']} - ${data['error_message'] ?? 'No message'}');
          _addStraightLinePolyline();
        }
      } else {
        LoggerUtils.error('❌ Directions API Request Failed with status: ${response.statusCode}');
        _addStraightLinePolyline();
      }
    } catch (e) {
      LoggerUtils.error('❌ Exception in _drawRoutePolyline: $e');
      _addStraightLinePolyline();
    }
  }

  /// Fallback: Add straight line polyline if Directions API fails
  void _addStraightLinePolyline() {
    LoggerUtils.warning('⚠️ Falling back to straight-line polyline');
    final directPolyline = Polyline(
      polylineId: const PolylineId('direct_polyline'),
      points: [
        LatLng(fromLat.value, fromLng.value),
        LatLng(toLat.value, toLng.value),
      ],
      color: const Color(0xFF7C3AED).withOpacity(0.5),
      width: 4,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)], // Dash to indicate it's not the real route
    );
    polylines.assign(directPolyline);
    polylines.refresh();
  }

  /// Decode encoded polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      final latLng = LatLng(lat / 1E5, lng / 1E5);
      points.add(latLng);
      
      // Log first few points for debugging
      if (points.length <= 3) {
        LoggerUtils.info('Point ${points.length}: $latLng');
      }
    }

    LoggerUtils.info('Total decoded points: ${points.length}');
    return points;
  }

  /// Setup socket listeners for real-time tracking
  void _setupSocketListeners() {
    // Only passengers need to track driver
    if (isProvider) return;

    try {
      // Listen for driver location updates
      SocketClient.to.on('driver-location-update', (data) {
        LoggerUtils.info('Driver location update: $data');
        _updateDriverLocation(data);
      });
    } catch (e) {
      LoggerUtils.error('Error setting up socket listeners: $e');
    }
  }

  /// Update driver location from socket data
  void _updateDriverLocation(Map<String, dynamic> data) {
    try {
      final rideIdFromData = data['rideId'] ?? '';
      if (rideIdFromData != rideId.value) return;

      final location = data['location'];
      if (location == null) return;

      final lat = location['lat'] ?? location['latitude'];
      final lng = location['lng'] ?? location['longitude'];

      if (lat != null && lng != null) {
        final newLatLng = LatLng(lat.toDouble(), lng.toDouble());

        // Update driver marker position
        _updateDriverMarker(newLatLng);

        // Update route polyline with new driver position
        _updateRoutePolyline(newLatLng);
      }
    } catch (e) {
      LoggerUtils.error('Error updating driver location: $e');
    }
  }

  /// Update driver marker position
  void _updateDriverMarker(LatLng newPosition) {
    // Remove old driver marker
    markers.removeWhere((marker) => marker.markerId.value == 'driver');

    // Add new driver marker
    markers.add(Marker(
      markerId: const MarkerId('driver'),
      position: newPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: otherUserName.value),
    ));

    // Animate camera to driver
    mapController.animateCamera(
      CameraUpdate.newLatLng(newPosition),
    );
  }

  /// Update route polyline with new driver position
  Future<void> _updateRoutePolyline(LatLng driverPosition) async {
    try {
      // NOTE: User requested polyline from fromLocation to toLocation.
      // If we want to show driver's progress, we can use driverPosition.
      // But for now, ensuring the base route is visible.
      if (fromLat.value == 0.0 || fromLng.value == 0.0 ||
          toLat.value == 0.0 || toLng.value == 0.0) return;

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${fromLat.value},${fromLng.value}'
        '&destination=${toLat.value},${toLng.value}'
        '&mode=driving'
        '&key=${AppConstants.googleMapKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final decodedPoints = _decodePolyline(points);

          final newPolyline = Polyline(
            polylineId: const PolylineId('route'),
            points: decodedPoints,
            color: const Color(0xFF4285F4),
            width: 6,
          );
          
          polylines.assign(newPolyline);

          // Update distance (optional, might want to keep original ride distance)
          // final distanceInMeters = data['routes'][0]['legs'][0]['distance']['value'];
          // distance.value = (distanceInMeters / 1000).toDouble();
        }
      }
    } catch (e) {
      LoggerUtils.error('Error updating route polyline: $e');
    }
  }

  /// Poll driver location (fallback if socket not working)
  Future<void> _pollDriverLocation() async {
    if (rideId.value.isEmpty || isProvider) return;

    try {
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final response = await NetworkCaller().getRequest(
        '${AppUrl.baseUrl}/job/${rideId.value}/driver-location',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess && response.jsonResponse != null) {
        final data = response.jsonResponse!['data'];
        if (data != null) {
          _updateDriverLocation(data);
        }
      }
    } catch (e) {
      LoggerUtils.error('Error polling driver location: $e');
    }
  }

  /// Start polling for driver location
  void startLocationPolling() {
    if (isProvider) return;
    
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _pollDriverLocation();
    });
  }

  /// Stop polling for driver location
  void stopLocationPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Center map on user's current location
  Future<void> centerOnCurrentUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final userLatLng = LatLng(position.latitude, position.longitude);
      
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(userLatLng, 15),
      );
    } catch (e) {
      LoggerUtils.error('Error getting current location: $e');
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

  /// Mark ride as picked up
  Future<void> markAsPickedUp() async {
    if (rideId.value.isEmpty) {
      LoggerUtils.error('Ride ID is empty');
      return;
    }

    isLoading.value = true;

    try {
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final response = await NetworkCaller().postRequest(
        '${AppUrl.baseUrl}/job/${rideId.value}/pickup',
        body: {},
        headers: {'Authorization': 'Bearer $token'},
      );

      LoggerUtils.info('Pickup Response: ${response.jsonResponse}');

      if (response.isSuccess && response.jsonResponse != null) {
        // Update status to 'picked'
        status.value = 'picked';
        Get.snackbar(
          'Success',
          'Passenger picked up successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to mark as picked up';
        LoggerUtils.error('Failed to mark pickup: $errorMessage');
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      LoggerUtils.error('Error marking pickup: $e');
      Get.snackbar(
        'Error',
        'Failed to mark as picked up',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Mark ride as completed
  /// Returns true if successful, false otherwise
  Future<bool> markAsCompleted() async {
    if (rideId.value.isEmpty) {
      LoggerUtils.error('Ride ID is empty');
      return false;
    }

    isLoading.value = true;

    try {
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final response = await NetworkCaller().postRequest(
        '${AppUrl.baseUrl}/job/${rideId.value}/complete',
        body: {},
        headers: {'Authorization': 'Bearer $token'},
      );

      LoggerUtils.info('Complete Response: ${response.jsonResponse}');

      if (response.isSuccess && response.jsonResponse != null) {
        // Update status to 'completed'
        status.value = 'completed';
        Get.snackbar(
          'Success',
          'Ride completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to complete ride';
        LoggerUtils.error('Failed to complete ride: $errorMessage');
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      LoggerUtils.error('Error marking completed: $e');
      Get.snackbar(
        'Error',
        'Failed to complete ride',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Submit review for a ride
  /// Returns true if successful, false otherwise
  Future<bool> submitReview({
    required String userId,
    required int rating,
    required String comment,
  }) async {
    if (rideId.value.isEmpty) {
      LoggerUtils.error('Ride ID is empty');
      Get.snackbar(
        'Error',
        'Ride ID is missing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    isLoading.value = true;

    try {
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final response = await NetworkCaller().postRequest(
        '${AppUrl.baseUrl}/review',
        body: {
          'rideId': rideId.value,
          'userId': userId,
          'rating': rating,
          'comment': comment,
        },
        headers: {'Authorization': 'Bearer $token'},
      );

      LoggerUtils.info('Review Response: ${response.jsonResponse}');

      if (response.isSuccess && response.jsonResponse != null) {
        Get.snackbar(
          'Success',
          'Review submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to submit review';
        LoggerUtils.error('Failed to submit review: $errorMessage');
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      LoggerUtils.error('Error submitting review: $e');
      Get.snackbar(
        'Error',
        'Failed to submit review',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

}

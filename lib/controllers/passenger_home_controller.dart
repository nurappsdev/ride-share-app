import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:split_ride/model/driver_registration/car_type_model.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';
import '../../helpers/app_url.dart';
import '../../helpers/logger_util.dart';

class PassengerHomeController extends GetxController {
  final RxBool loader = false.obs;

  // Ride details
  final RxInt passengers = 1.obs;
  final RxString selectedRideType = 'Split Your Ride'.obs;
  final Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);

  // Car and seats
  final Rx<CarTypeModel?> selectedCarType = Rx<CarTypeModel?>(null);
  final Rx<int?>? selectedSeats = Rx<int?>(null);
  final RxList<CarTypeModel> carTypes = <CarTypeModel>[].obs;

  // Luggage
  final RxString selectedLuggageType = 'Suitcase'.obs;
  final RxList<String> selectedLuggageItems = <String>[].obs;
  final RxBool showLuggageDropdown = false.obs;

  // Location
  final RxString fromLocation = ''.obs;
  final RxString toLocation = ''.obs;
  final RxDouble fromLatitude = 0.0.obs;
  final RxDouble fromLongitude = 0.0.obs;
  final RxDouble toLatitude = 0.0.obs;
  final RxDouble toLongitude = 0.0.obs;

  // Current location bias for autocomplete
  final Rx<Position?> currentLocationBias = Rx<Position?>(null);
  final RxBool isLoadingCurrentLocation = false.obs;

  // Text controllers for location fields
  final TextEditingController fromLocationController = TextEditingController();
  final TextEditingController toLocationController = TextEditingController();

  // Note for driver
  final TextEditingController noteController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCarTypes();
    _initializeCurrentLocation();
  }

  /// Initialize current location for bias and set as default "From" location
  Future<void> _initializeCurrentLocation() async {
    try {
      isLoadingCurrentLocation.value = true;

      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        _setFallbackLocation();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLocationBias.value = position;

      // Set as default "From" location
      await _setFromCurrentLocation(position);

      LoggerUtils.debug(
        'Current location initialized: ${position.latitude}, ${position.longitude}',
      );
    } catch (e) {
      LoggerUtils.debug('Failed to get current location: $e');
      _setFallbackLocation();
    } finally {
      isLoadingCurrentLocation.value = false;
    }
  }

  /// Set from location using current position
  Future<void> _setFromCurrentLocation(Position position) async {
    try {
      // Get address from coordinates using reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = _formatAddress(place);

        fromLocationController.text = address;
        fromLocation.value = address;
        fromLatitude.value = position.latitude;
        fromLongitude.value = position.longitude;

        LoggerUtils.debug('From location set: $address');
      }
    } catch (e) {
      LoggerUtils.debug('Failed to get address from coordinates: $e');
      // Set coordinates without address
      fromLatitude.value = position.latitude;
      fromLongitude.value = position.longitude;
      fromLocationController.text = 'Current Location';
      fromLocation.value = 'Current Location';
    }
  }

  /// Format address from placemark
  String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }

    return addressParts.join(', ');
  }

  /// Set fallback location (Dhaka, Bangladesh)
  void _setFallbackLocation() {
    currentLocationBias.value = Position(
      latitude: 23.8103,
      longitude: 90.4125,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    LoggerUtils.debug('Using fallback location: Dhaka, BD');
  }

  /// Handle location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false; // Silent fail for bias - not critical
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Fetch car types from backend
  Future<void> fetchCarTypes() async {
    try {
      loader.value = true;
      final NetworkResponse getResponse = await NetworkCaller().getRequest(
        AppUrl.getCarType,
      );

      if (getResponse.isSuccess) {
        List<dynamic> resultsList = getResponse.jsonResponse?['data'];

        final List<dynamic> carTypeGetList = resultsList
            .map((dynamic carType) => CarTypeModel.fromJson(carType))
            .toList();

        carTypes.clear();
        for (final CarTypeModel carType in carTypeGetList) {
          carTypes.add(carType);
        }
      } else {
        Toast.show(
          message:
          getResponse.jsonResponse?['message'] ??
              'Failed to fetch car types',
          type: ToastType.error,
        );
      }
    } catch (e) {
      LoggerUtils.debug("Exception fetching car types: ${e.toString()}");
      Toast.showError('Failed to load car types');
    } finally {
      loader.value = false;
    }
  }

  /// Select ride type
  void selectRideType(String rideType) {
    selectedRideType.value = rideType;
  }

  /// Increment passengers
  void incrementPassengers() {
    if (selectedSeats?.value != null &&
        selectedSeats!.value! == passengers.value) {
      Toast.showError('Maximum allowed passenger ${selectedSeats!.value!}');
      return;
    }
    passengers.value++;
  }

  /// Decrement passengers
  void decrementPassengers() {
    if (passengers.value > 1) {
      passengers.value--;
    }
  }

  /// Select car type
  void selectCarType(CarTypeModel? carType) {
    selectedCarType.value = carType;
    // Reset seats when car type changes
    selectedSeats?.value = null;
  }

  /// Select seats
  void selectSeats(int? seats) {
    selectedSeats?.value = seats;

    if (selectedSeats?.value != null &&
        selectedSeats!.value! < passengers.value) {
      Toast.showError("Maximum ${selectedSeats!.value} passengers allowed");
      passengers.value = selectedSeats!.value!;
      return;
    }
  }

  /// Get available seats for selected car type
  List<int> getAvailableSeats() {
    return selectedCarType.value?.seats ?? [];
  }

  /// Check if seats dropdown should be disabled
  bool isSeatsDropdownDisabled() {
    return selectedCarType.value == null;
  }

  /// Add luggage item
  void addLuggageItem(String item) {
    if (!selectedLuggageItems.contains(item)) {
      selectedLuggageItems.add(item);
      showLuggageDropdown.value = false; // Hide dropdown after adding
    }
  }

  /// Remove luggage item
  void removeLuggageItem(String item) {
    selectedLuggageItems.remove(item);
  }

  /// Toggle luggage dropdown visibility
  void toggleLuggageDropdown() {
    showLuggageDropdown.value = !showLuggageDropdown.value;
  }

  /// Show luggage dropdown
  void showLuggageDropdownField() {
    showLuggageDropdown.value = true;
  }

  /// Set from location
  void setFromLocation({
    required String location,
    required double latitude,
    required double longitude,
  }) {
    fromLocation.value = location;
    fromLatitude.value = latitude;
    fromLongitude.value = longitude;
    fromLocationController.text = location;
    LoggerUtils.debug('From Location: $location ($latitude, $longitude)');
  }

  /// Set to location
  void setToLocation({
    required String location,
    required double latitude,
    required double longitude,
  }) {
    toLocation.value = location;
    toLatitude.value = latitude;
    toLongitude.value = longitude;
    toLocationController.text = location;
    LoggerUtils.debug('To Location: $location ($latitude, $longitude)');
  }

  /// Set selected date time
  void setSelectedDateTime(DateTime dateTime) {
    selectedDateTime.value = dateTime;
  }

  /// Validate ride booking
  bool validateRideBooking() {
    if (fromLocation.value.isEmpty) {
      Toast.showError('Please select pickup location');
      return false;
    }

    if (toLocation.value.isEmpty) {
      Toast.showError('Please select destination');
      return false;
    }

    if (selectedCarType.value == null) {
      Toast.showError('Please select car type');
      return false;
    }

    if (selectedSeats?.value == null || selectedSeats?.value == 0) {
      Toast.showError('Please select number of seats');
      return false;
    }

    if (selectedDateTime.value == null) {
      Toast.showError('Please select date and time');
      return false;
    }

    return true;
  }

  /// Prepare booking data
  Map<String, dynamic> prepareBookingData() {
    return {
      'rideType': selectedRideType.value,
      'passengers': passengers.value,
      'carTypeId': selectedCarType.value?.id,
      'carTypeName': selectedCarType.value?.name,
      'seats': selectedSeats?.value,
      'fromLocation': fromLocation.value,
      'fromLatitude': fromLatitude.value,
      'fromLongitude': fromLongitude.value,
      'toLocation': toLocation.value,
      'toLatitude': toLatitude.value,
      'toLongitude': toLongitude.value,
      'dateTime': selectedDateTime.value?.toIso8601String(),
      'luggage': selectedLuggageItems.toList(),
      'noteForDriver': noteController.text,
    };
  }

  /// Book ride
  Future<bool> bookRide() async {
    if (!validateRideBooking()) {
      return false;
    }

    try {
      loader.value = true;

      final bookingData = prepareBookingData();
      LoggerUtils.debug('Booking Data: $bookingData');

      // TODO: Replace with actual booking API endpoint
      // final NetworkResponse response = await NetworkCaller().postRequest(
      //   AppUrl.bookRide,
      //   body: bookingData,
      // );
      //
      // if (response.isSuccess) {
      //   Toast.showSuccess('Ride booked successfully');
      //   return true;
      // } else {
      //   Toast.showError(response.jsonResponse?['message'] ?? 'Booking failed');
      //   return false;
      // }

      // For now, just show success
      await Future.delayed(const Duration(seconds: 1));
      Toast.showSuccess('Ride booking prepared successfully');
      return true;
    } catch (e) {
      LoggerUtils.debug('Booking error: $e');
      Toast.showError('Failed to book ride');
      return false;
    } finally {
      loader.value = false;
    }
  }

  /// Clear all data
  void clearAllData() {
    passengers.value = 2;
    selectedRideType.value = 'Split Your Ride';
    selectedDateTime.value = null;
    selectedCarType.value = null;
    selectedSeats?.value = null;
    selectedLuggageItems.clear();
    showLuggageDropdown.value = false;
    fromLocation.value = '';
    toLocation.value = '';
    fromLatitude.value = 0.0;
    fromLongitude.value = 0.0;
    toLatitude.value = 0.0;
    toLongitude.value = 0.0;
    fromLocationController.clear();
    toLocationController.clear();
    noteController.clear();
  }

  @override
  void onClose() {
    fromLocationController.dispose();
    toLocationController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
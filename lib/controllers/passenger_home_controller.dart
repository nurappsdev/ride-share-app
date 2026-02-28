import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:split_ride/model/driver_registration/car_type_model.dart';
import 'package:split_ride/model/driver_registration/saved_place_model.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';
import '../../helpers/app_url.dart';
import '../../helpers/logger_util.dart';
import '../helpers/secured_storage.dart';
import '../utils/app_constant.dart';
import '../view/widgets/webview_modal.dart';

class PassengerHomeController extends GetxController {
  final RxBool loader = false.obs;
  final RxBool agreeCheckValue = false.obs;

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
  final TextEditingController luggageNoteController = TextEditingController();

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

  // Saved places
  final RxList<SavedPlaceModel> savedPlaces = <SavedPlaceModel>[].obs;
  final RxBool isLoadingSavedPlaces = false.obs;

  // Text controllers for location fields
  final TextEditingController fromLocationController = TextEditingController();
  final TextEditingController toLocationController = TextEditingController();

  // Note for driver
  final TextEditingController noteController = TextEditingController();

  // Booking response data
  final RxDouble calculatedFare = 0.0.obs;
  final RxDouble calculatedCharge = 0.0.obs;
  final RxDouble calculatedTotalFare = 0.0.obs;
  final RxDouble calculatedDistance = 0.0.obs;
  final RxString calculatedFromAddress = ''.obs;
  final RxString calculatedToAddress = ''.obs;
  final RxString bookingId = ''.obs;
  final RxString rideType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCarTypes();
    _initializeCurrentLocation();
    fetchSavedPlaces();
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
      String address = await _getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      fromLocationController.text = address;
      fromLocation.value = address;
      fromLatitude.value = position.latitude;
      fromLongitude.value = position.longitude;

      LoggerUtils.debug('From location set: $address');
    } catch (e) {
      LoggerUtils.debug('Failed to get address from coordinates: $e');
      // Set coordinates without address
      fromLatitude.value = position.latitude;
      fromLongitude.value = position.longitude;
      fromLocationController.text = 'Current Location';
      fromLocation.value = 'Current Location';
    }
  }

  /// Get address from coordinates using reverse geocoding
  Future<String> _getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return _formatAddress(place);
      }

      return 'Unknown Location';
    } catch (e) {
      LoggerUtils.debug('Failed to get address: $e');
      return 'Lat: ${latitude.toStringAsFixed(4)}, Lng: ${longitude.toStringAsFixed(4)}';
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

    return addressParts.isNotEmpty
        ? addressParts.join(', ')
        : 'Unknown Location';
  }

  /// Calculate distance between two coordinates in kilometers
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    try {
      // Using Geolocator's distanceBetween method
      // Returns distance in meters, convert to kilometers
      final distanceInMeters = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      final distanceInKm = distanceInMeters / 1000;

      LoggerUtils.debug(
        'Calculated distance: ${distanceInKm.toStringAsFixed(2)} km',
      );

      return distanceInKm;
    } catch (e) {
      LoggerUtils.error('Error calculating distance: $e');
      return 0.0;
    }
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
      return false;
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

  /// Fetch saved places from backend
  Future<void> fetchSavedPlaces() async {
    try {
      isLoadingSavedPlaces.value = true;
      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';
      final NetworkResponse response = await NetworkCaller().getRequest(
        AppUrl.passengerSavedPlaces,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess) {
        final List<dynamic> data =
            response.jsonResponse?['data']?['value'] ?? [];

        savedPlaces.clear();

        for (var placeData in data) {
          if (placeData is List && placeData.length >= 2) {
            final double longitude = placeData[0].toDouble();
            final double latitude = placeData[1].toDouble();

            String address = await _getAddressFromCoordinates(
              latitude,
              longitude,
            );

            savedPlaces.add(
              SavedPlaceModel(
                latitude: latitude,
                longitude: longitude,
                address: address,
              ),
            );
          }
        }

        LoggerUtils.debug('Saved places loaded: ${savedPlaces.length}');
      } else {
        LoggerUtils.debug(
          'Failed to fetch saved places: ${response.jsonResponse?['message']}',
        );
      }
    } catch (e) {
      LoggerUtils.debug('Error fetching saved places: $e');
    } finally {
      isLoadingSavedPlaces.value = false;
    }
  }

  /// Check if current from location is saved
  bool get isFromLocationSaved {
    if (fromLocation.value.isEmpty || fromLatitude.value == 0.0) {
      return false;
    }

    return savedPlaces.any(
      (place) =>
          place.latitude == fromLatitude.value &&
          place.longitude == fromLongitude.value,
    );
  }

  /// Check if current to location is saved
  bool get isToLocationSaved {
    if (toLocation.value.isEmpty || toLatitude.value == 0.0) {
      return false;
    }

    return savedPlaces.any(
      (place) =>
          place.latitude == toLatitude.value &&
          place.longitude == toLongitude.value,
    );
  }

  /// Add a safe place to backend
  Future<bool> savePlace({
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoadingSavedPlaces.value = true;

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final payload = {
        "coordinates": [longitude, latitude],
      };

      final NetworkResponse response = await NetworkCaller().putRequest(
        AppUrl.addPassengerSavedPlaces,
        headers: {'Authorization': 'Bearer $token'},
        body: payload,
      );

      if (response.isSuccess) {
        await fetchSavedPlaces();

        Toast.showSuccess('Place saved successfully');
        LoggerUtils.debug('Place saved: $latitude, $longitude');
        return true;
      } else {
        Toast.showError(
          response.jsonResponse?['message'] ?? 'Failed to save place',
        );
        LoggerUtils.error('Failed to save place: ${response.jsonResponse}');
        return false;
      }
    } catch (e) {
      LoggerUtils.debug('Error saving place: $e');
      Toast.showError('Failed to save place');
      return false;
    } finally {
      isLoadingSavedPlaces.value = false;
    }
  }

  /// Remove a place from saved places
  Future<bool> unsavePlace({
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoadingSavedPlaces.value = true;

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final payload = {
        "coordinates": [longitude, latitude],
      };

      final NetworkResponse response = await NetworkCaller().deleteRequest(
        AppUrl.passengerRemoveSavedPlace,
        headers: {'Authorization': 'Bearer $token'},
        body: payload,
      );

      if (response.isSuccess) {
        savedPlaces.removeWhere(
          (place) => place.latitude == latitude && place.longitude == longitude,
        );

        Toast.showSuccess('Place removed from saved places');
        LoggerUtils.debug('Place unsaved: $latitude, $longitude');
        return true;
      } else {
        Toast.showError(
          response.jsonResponse?['message'] ?? 'Failed to remove place',
        );
        return false;
      }
    } catch (e) {
      LoggerUtils.debug('Error unsaving place: $e');
      Toast.showError('Failed to remove place');
      return false;
    } finally {
      isLoadingSavedPlaces.value = false;
    }
  }

  /// Toggle save/unsave for from location
  Future<void> toggleSaveFromLocation() async {
    if (fromLocation.value.isEmpty ||
        fromLatitude.value == 0.0 ||
        fromLongitude.value == 0.0) {
      Toast.showError('Please select a location first');
      return;
    }

    final isSaved = savedPlaces.any(
      (place) =>
          place.latitude == fromLatitude.value &&
          place.longitude == fromLongitude.value,
    );

    if (isSaved) {
      await unsavePlace(
        latitude: fromLatitude.value,
        longitude: fromLongitude.value,
      );
    } else {
      await savePlace(
        latitude: fromLatitude.value,
        longitude: fromLongitude.value,
      );
    }
  }

  /// Toggle save/unsave for to location
  Future<void> toggleSaveToLocation() async {
    if (toLocation.value.isEmpty ||
        toLatitude.value == 0.0 ||
        toLongitude.value == 0.0) {
      Toast.showError('Please select a location first');
      return;
    }

    final isSaved = savedPlaces.any(
      (place) =>
          place.latitude == toLatitude.value &&
          place.longitude == toLongitude.value,
    );

    if (isSaved) {
      await unsavePlace(
        latitude: toLatitude.value,
        longitude: toLongitude.value,
      );
    } else {
      await savePlace(latitude: toLatitude.value, longitude: toLongitude.value);
    }
  }

  /// Use saved place as From location
  void useSavedPlaceAsFrom(SavedPlaceModel place) {
    setFromLocation(
      location: place.address,
      latitude: place.latitude,
      longitude: place.longitude,
    );
  }

  /// Use saved place as To location
  void useSavedPlaceAsTo(SavedPlaceModel place) {
    setToLocation(
      location: place.address,
      latitude: place.latitude,
      longitude: place.longitude,
    );
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

  void selectRideType(String rideType) {
    selectedRideType.value = rideType;
  }

  void incrementPassengers() {
    if (selectedSeats?.value != null &&
        selectedSeats!.value! == passengers.value) {
      Toast.showError('Maximum allowed passenger ${selectedSeats!.value!}');
      return;
    }
    passengers.value++;
  }

  void decrementPassengers() {
    if (passengers.value > 1) {
      passengers.value--;
    }
  }

  void selectCarType(CarTypeModel? carType) {
    selectedCarType.value = carType;
    selectedSeats?.value = null;
  }

  void selectSeats(int? seats) {
    selectedSeats?.value = seats;

    if (selectedSeats?.value != null &&
        selectedSeats!.value! < passengers.value) {
      Toast.showError("Maximum ${selectedSeats!.value} passengers allowed");
      passengers.value = selectedSeats!.value!;
      return;
    }
  }

  List<int> getAvailableSeats() {
    return selectedCarType.value?.seats ?? [];
  }

  bool isSeatsDropdownDisabled() {
    return selectedCarType.value == null;
  }

  void addLuggageItem(String item) {
    if (!selectedLuggageItems.contains(item)) {
      selectedLuggageItems.add(item);
      showLuggageDropdown.value = false;
    }
  }

  void removeLuggageItem(String item) {
    selectedLuggageItems.remove(item);
  }

  void toggleLuggageDropdown() {
    showLuggageDropdown.value = !showLuggageDropdown.value;
  }

  void showLuggageDropdownField() {
    showLuggageDropdown.value = true;
  }

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

  void setSelectedDateTime(DateTime dateTime) {
    selectedDateTime.value = dateTime;
  }

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

  Map<String, dynamic> prepareBookingData() {
    // Format datetime to ISO string
    final dateTimeString =
        selectedDateTime.value?.toUtc().toIso8601String() ?? '';

    // Convert luggage items to lowercase for API
    final luggageList = selectedLuggageItems
        .map((item) => item.toLowerCase())
        .toList();

    // Calculate distance between from and to locations
    final distance = calculateDistance(
      startLatitude: fromLatitude.value,
      startLongitude: fromLongitude.value,
      endLatitude: toLatitude.value,
      endLongitude: toLongitude.value,
    );

    // Store calculated distance
    calculatedDistance.value = distance;

    return {
      'carModelId': selectedCarType.value?.id ?? '',
      'seat': selectedSeats?.value ?? 0,
      'type': selectedRideType.value == 'Split Your Ride' ? 'split' : 'private',
      'passengers': passengers.value,
      'dateTime': dateTimeString,
      'luggages': luggageList,
      'luggageDetails': luggageNoteController.text.trim().isNotEmpty
          ? luggageNoteController.text.trim()
          : '', // Optional
      'note': noteController.text.trim() ?? '', // Optional
      'coordinates': [fromLongitude.value, fromLatitude.value], // [lng, lat]
      'destCoordinates': [toLongitude.value, toLatitude.value], // [lng, lat]
      'distance': distance, // Calculated distance in km
    };
  }

  Future<bool> bookRide() async {
    if (!validateRideBooking()) {
      return false;
    }

    try {
      loader.value = true;

      final bookingData = prepareBookingData();
      LoggerUtils.debug('Booking Data: $bookingData');

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final NetworkResponse response = await NetworkCaller().postRequest(
        AppUrl.createRide, // Make sure this endpoint is defined in AppUrl
        headers: {'Authorization': 'Bearer $token'},
        body: bookingData,
      );

      if (response.isSuccess && response.jsonResponse?['code'] == 201) {
        final data = response.jsonResponse?['data'];
        final extra = response.jsonResponse?['extra'];

        // Store booking response data
        bookingId.value = data?['_id'] ?? '';
        calculatedFare.value = (data?['fare'] ?? 0.0).toDouble();
        calculatedCharge.value = (data?['charge'] ?? 0.0).toDouble();
        rideType.value = data?['type'] ?? '';
        calculatedTotalFare.value = (data?['totalFare'] ?? 0.0).toDouble();
        calculatedDistance.value = (data?['distance'] ?? 0.0).toDouble();
        calculatedFromAddress.value =
            extra?['fromAddress'] ?? fromLocation.value;
        calculatedToAddress.value = extra?['toAddress'] ?? toLocation.value;

        LoggerUtils.debug('Booking created successfully: ${bookingId.value}');
        LoggerUtils.debug('Total Fare: ${calculatedTotalFare.value}');
        LoggerUtils.debug('Distance: ${calculatedDistance.value} km');

        Toast.showSuccess('Ride booking created successfully');
        return true;
      } else {
        final errorMessage =
            response.jsonResponse?['message'] ?? 'Booking failed';
        Toast.showError(errorMessage);
        LoggerUtils.error('Booking failed: ${response.jsonResponse}');
        return false;
      }
    } catch (e) {
      LoggerUtils.debug('Booking error: $e');
      Toast.showError('Failed to book ride');
      return false;
    } finally {
      loader.value = false;
    }
  }

  /// ===============>
  // Make a payment through the method ===============>
  makePayment({required String payId}) async {
    try {
      loader.value = true;

      final bookingData = prepareBookingData();
      LoggerUtils.debug('Booking Data: $bookingData');

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final NetworkResponse response = await NetworkCaller().postRequest(
        AppUrl.makePayment(id: payId),

        headers: {'Authorization': 'Bearer $token'},
        body: bookingData,
      );
      LoggerUtils.error(response.jsonResponse);
      // showModalBottomSheet(
      //   context: context,
      //   isScrollControlled: true,
      //   isDismissible: false,
      //   enableDrag: false,
      //   backgroundColor: Colors.transparent,
      //   builder: (BuildContext context) => CommonWebViewModal(url: "https://www.google.com/"),
      // );
      if (response.isSuccess) {
        final String paymentUrl = response.jsonResponse?['data']['url'];
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) =>
              CommonWebViewModal(url: paymentUrl),
        );

        return true;
      } else {
        final errorMessage =
            response.jsonResponse?['message'] ?? 'Booking failed';
        Toast.showError(errorMessage);
        LoggerUtils.error('Booking failed: ${response.jsonResponse}');
        return false;
      }
    } catch (e) {
      LoggerUtils.debug('Booking error: $e');
      Toast.showError('Failed to book ride');
      return false;
    } finally {
      loader.value = false;
    }
  }

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
    luggageNoteController.clear();

    // Clear booking response data
    calculatedFare.value = 0.0;
    calculatedCharge.value = 0.0;
    calculatedTotalFare.value = 0.0;
    calculatedDistance.value = 0.0;
    calculatedFromAddress.value = '';
    calculatedToAddress.value = '';
    bookingId.value = '';
  }

  @override
  void onClose() {
    fromLocationController.dispose();
    toLocationController.dispose();
    noteController.dispose();
    luggageNoteController.dispose();
    super.onClose();
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:split_ride/model/driver_registration/car_type_model.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

import '../../helpers/app_url.dart';
import '../../helpers/logger_util.dart';
import '../../helpers/secured_storage.dart';
import '../../services/network/network_caller.dart';
import '../../services/network/network_response.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../view/widgets/location_picker_map_screen.dart';

class DriverProfileRegistrationController extends GetxController {
  final RxBool loader = false.obs;
  final TextEditingController dateTEController = TextEditingController();
  final TextEditingController addressTEController = TextEditingController();

  // Location variables
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxDouble selectedLatitude = 0.0.obs;
  final RxDouble selectedLongitude = 0.0.obs;
  final RxString selectedAddress = ''.obs;

/*  /// Open Location Picker Map ==================( OLD WAY ) ====================>
  Future<void> openLocationPicker() async {
    // Check and request location permission
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      Toast.show(
        message: "Location permission is required to pick your address",
        type: ToastType.error,
      );

      return;
    }

    // Get current location first
    await _getCurrentLocation();

    // Open map picker screen
    final Map<String, dynamic>? result = await Get.to<Map<String, dynamic>>(
      () => LocationPickerMapScreen(
        initialLatitude: currentPosition.value?.latitude ?? 23.8103,
        initialLongitude: currentPosition.value?.longitude ?? 90.4125,
      ),
    );

    // Handle result from map picker
    if (result != null) {
      selectedLatitude.value = result['latitude'];
      selectedLongitude.value = result['longitude'];
      selectedAddress.value = result['address'];

      // Update text field
      addressTEController.text = result['address'];

      // print('Selected Location:');
      // print('Latitude: ${selectedLatitude.value}');
      // print('Longitude: ${selectedLongitude.value}');
      // print('Address: ${selectedAddress.value}');
    }
  }*/
  void setSelectedLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) {
    selectedLatitude.value = latitude;
    selectedLongitude.value = longitude;
    selectedAddress.value = address;
    addressTEController.text = address;

    LoggerUtils.debug('Selected Location:');
    LoggerUtils.debug('Latitude: $latitude');
    LoggerUtils.debug('Longitude: $longitude');
    LoggerUtils.debug('Address: $address');
  }
  /// Get current location
  Future<void> _getCurrentLocation() async {
    try {
      loader.value = true;
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = position;
    } catch (e) {
      // Use default location (Dhaka, Bangladesh)
      currentPosition.value = Position(
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
    } finally {
      loader.value = false;
    }
  }

  /// Handle location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Toast.show(
        message: 'Please enable location services',
        type: ToastType.error,
      );

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
      // Open app settings
      await openAppSettings();
      return false;
    }

    return true;
  }

  /// =========> Check first Screen =======>
   bool checkFirstScreenValidation() {
    if ((profileImageUrl != null && profileImageUrl!.isEmpty) ||
        dateTEController.text.isEmpty ||
        addressTEController.text.isEmpty) {
      Toast.showError('Please fill in the information!');
      return false ;
    }
    return true ;
  }

  /// ===============> Get the Car models =====================>
  final RxList<CarTypeModel> carTypes = <CarTypeModel>[].obs;

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
          message: getResponse.jsonResponse?['message'],
          type: ToastType.error,
        );
      }
    } catch (e) {
      LoggerUtils.debug("Exception : ${e.toString()}");
    } finally {
      loader.value = false;
    }
  }

  /// =======================> Driver Profile Image part ======================>
  final Rx<File?> profileImage = Rx<File?>(null);
  String? profileImageUrl;
  final RxBool isUploadingProfileImage = false.obs;
  final ImagePicker _picker = ImagePicker();

  /// Show bottom sheet to pick profile image source
  Future<void> showProfileImagePicker() async {
    await Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary3rdColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.primary3rdColor,
                    ),
                  ),
                  title: Text('Camera', style: TextStyle(fontFamily: 'Outfit')),
                  onTap: () {
                    Get.back();
                    pickProfileImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary3rdColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.photo_library,
                      color: AppColors.primary3rdColor,
                    ),
                  ),
                  title: Text(
                    'Gallery',
                    style: TextStyle(fontFamily: 'Outfit'),
                  ),
                  onTap: () {
                    Get.back();
                    pickProfileImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
    );
  }

  /// Pick profile image from camera or gallery
  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        final File file = File(image.path);
        profileImage.value = file;

        // Auto-upload after picking
        await _uploadProfileImage(file);
      }
    } catch (e) {
      LoggerUtils.debug('Error picking profile image: $e');
      Toast.showError('Failed to pick image');
    }
  }

  /// Upload profile image to server
  Future<void> _uploadProfileImage(File file) async {
    try {
      isUploadingProfileImage.value = true;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.imageBaseUrl),
      );
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      LoggerUtils.debug('Uploading profile image to ${AppUrl.imageBaseUrl}');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      LoggerUtils.debug('Profile image upload status: ${response.statusCode}');
      LoggerUtils.debug('Profile image upload response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        // Try different possible response formats
        final String imageUrl =
            data['filename'] ??
            data['url'] ??
            data['data']?['filename'] ??
            data['data']?['url'] ??
            '';

        if (imageUrl.isNotEmpty) {
          profileImageUrl = imageUrl;
          // Toast.showSuccess('Profile image uploaded successfully');
          LoggerUtils.debug('Profile image URL: $imageUrl');
        } else {
          Toast.showError('Failed to upload the image !');
          LoggerUtils.debug('No URL in response: ${response.body}');
          // Clear the image if upload failed
          profileImage.value = null;
        }
      } else {
        Toast.showError('Upload failed: ${response.statusCode}');
        LoggerUtils.debug(
          'Upload failed: ${response.statusCode} - ${response.body}',
        );
        // Clear the image if upload failed
        profileImage.value = null;
      }
    } catch (e) {
      LoggerUtils.debug('Error uploading profile image: $e');
      // Toast.showError('Upload failed: $e');
      // Clear the image if upload failed
      profileImage.value = null;
    } finally {
      isUploadingProfileImage.value = false;
    }
  }

  /// Validate profile data before moving to next screen
  bool validateProfileData() {
    if (profileImageUrl == null || profileImageUrl!.isEmpty) {
      Toast.showError('Please upload a profile image');
      return false;
    }

    if (dateTEController.text.isEmpty) {
      Toast.showError('Please select your date of birth');
      return false;
    }

    if (addressTEController.text.isEmpty) {
      Toast.showError('Please select your address');
      return false;
    }

    return true;
  }

  /// =======================> Driver Document Registration part ======================>

  String? gender;
  List<Map<String, dynamic>> vehiclesData = [];
  final RxBool isSubmitting = false.obs;

  /// Store vehicles data from vehicle screen
  void setVehiclesData(List<Map<String, dynamic>> vehicles) {
    vehiclesData = vehicles;
    LoggerUtils.debug('Vehicles data stored: $vehicles');
  }

  /// Submit complete driver registration
  Future<bool> submitDriverRegistration(
    Map<String, dynamic> documentData,
  ) async {
    try {
      isSubmitting.value = true;

      // Prepare final payload
      final payload = {
        'profileImage': profileImageUrl ?? '',
        'dateOfBirth': _formatDateForApi(dateTEController.text),
        'phone': await SecureStorageService().read('phone') ?? '',
        'address': selectedAddress.value,
        'gender': gender ?? 'male',
         'vehicles': vehiclesData,
        ...documentData,
        // cnicFront, cnicBack, licenseFront, licenseBack, carPapers
      };

      LoggerUtils.debug('Final Registration Payload: ${json.encode(payload)}');
      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';
      final NetworkResponse response = await NetworkCaller().postRequest(
        AppUrl.driverProfileRegistration,
        headers: {'Authorization': 'Bearer $token'},
        // AppUrl.getCarType, /// ===================>  fix
        body: payload,
      );

      if (response.isSuccess) {
        Toast.showSuccess( response.jsonResponse?['message'] ?? 'Registration submitted successfully');
        // Clear all data after successful submission
        _clearRegistrationData();
        return true ;
      } else {
        Toast.showError(
          response.jsonResponse?['message'] ?? 'Registration failed',
        );
        LoggerUtils.error( response.jsonResponse);
        return false ;
      }
    } catch (e) {
      LoggerUtils.debug('Registration error: $e');
      Toast.showError('Failed to submit registration');
      return false ;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Format date from DD-MM-YYYY to YYYY-MM-DD for API
  String _formatDateForApi(String date) {
    if (date.isEmpty) return '';
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}'; // YYYY-MM-DD
      }
    } catch (e) {
      LoggerUtils.debug('Date format error: $e');
    }
    return date;
  }

  /// Clear all registration data
  void _clearRegistrationData() {
    dateTEController.clear();
    addressTEController.clear();
    selectedAddress.value = '';
    selectedLatitude.value = 0.0;
    selectedLongitude.value = 0.0;
    vehiclesData.clear();
    profileImageUrl = null;
  }

  @override
  void onClose() {
    dateTEController.dispose();
    addressTEController.dispose();
    super.onClose();
  }
}

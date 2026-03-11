import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

class PersonalInfoController extends GetxController {
  final RxBool loader = false.obs;
  final RxBool isLoadingProfile = false.obs;

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Image
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString profileImageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // User data
  final RxString userId = ''.obs;
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// Fetch user profile from backend
  Future<void> fetchUserProfile() async {
    try {
      isLoadingProfile.value = true;

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final NetworkResponse response = await NetworkCaller().getRequest(
        AppUrl.userProfile, // Add this endpoint to AppUrl
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess) {
        final data = response.jsonResponse?['data'];

        if (data != null) {
          // Store user data
          userId.value = data['_id'] ?? '';
          userName.value = data['name'] ?? '';
          userEmail.value = data['email'] ?? '';
          userPhone.value = data['phone'] ?? '';
          profileImageUrl.value = data['profileImage'] ?? '';

          // Populate text controllers
          nameController.text = userName.value;
          emailController.text = userEmail.value;
          phoneController.text = userPhone.value;

          LoggerUtils.debug('User profile loaded successfully');
        }
      } else {
        LoggerUtils.error(
          'Failed to fetch profile: ${response.jsonResponse?['message']}',
        );
      }
    } catch (e) {
      LoggerUtils.error('Error fetching user profile: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Pick image from camera or gallery
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        LoggerUtils.debug('Image selected: ${image.path}');

        // Automatically upload after selection
        await uploadProfileImage();
      }
    } catch (e) {
      LoggerUtils.error('Error picking image: $e');
      Toast.showError('Failed to pick image');
    }
  }

  /// Upload profile image to server
  Future<void> uploadProfileImage() async {
    if (selectedImage.value == null) {
      Toast.showError('Please select an image first');
      return;
    }

    try {
      loader.value = true;

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // Create multipart request
      final NetworkResponse response = await NetworkCaller().multipartRequest(
        AppUrl.imageUploadUrl, // Add this endpoint to AppUrl
        headers: {'Authorization': 'Bearer $token'},
        files: {'file': selectedImage.value!},
      );

      if (response.isSuccess) {
        final imageUrl = response.jsonResponse?['data']?['url'];
        if (imageUrl != null) {
          profileImageUrl.value = imageUrl;
          Toast.showSuccess('Profile image updated successfully');
          LoggerUtils.debug('Image uploaded: $imageUrl');
        }
      } else {
        Toast.showError(
          response.jsonResponse?['message'] ?? 'Failed to upload image',
        );
        LoggerUtils.error('Upload failed: ${response.jsonResponse}');
      }
    } catch (e) {
      LoggerUtils.error('Error uploading image: $e');
      Toast.showError('Failed to upload image');
    } finally {
      loader.value = false;
    }
  }

  /// Update user profile
  Future<void> updateProfile() async {
    // Validation
    if (nameController.text.trim().isEmpty) {
      Toast.showError('Please enter your name');
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Toast.showError('Please enter your phone number');
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Toast.showError('Please enter your email');
      return;
    }

    // Email validation
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Toast.showError('Please enter a valid email');
      return;
    }

    try {
      loader.value = true;

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final payload = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'profileImage': profileImageUrl.value.trim(),
        // 'email': emailController.text.trim(),
      };

      final NetworkResponse response = await NetworkCaller().putRequest(
        AppUrl.userProfile,
        headers: {'Authorization': 'Bearer $token'},
        body: payload,
      );

      if (response.isSuccess) {
        // Update local data
        userName.value = nameController.text.trim();
        userEmail.value = emailController.text.trim();
        userPhone.value = phoneController.text.trim();

        Toast.showSuccess('Profile updated successfully');
        LoggerUtils.debug('Profile updated: $payload');
        await fetchUserProfile();
        // Optionally navigate back
        // Get.back();
      } else {
        Toast.showError(
          response.jsonResponse?['message'] ?? 'Failed to update profile',
        );
        LoggerUtils.error('Update failed: ${response.jsonResponse}');
      }
    } catch (e) {
      LoggerUtils.error('Error updating profile: $e');
      Toast.showError('Failed to update profile');
    } finally {
      loader.value = false;
    }
  }

  /// Clear selected image
  void clearImage() {
    selectedImage.value = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}

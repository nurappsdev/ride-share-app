import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/model/driver_registration/login_both/login_model.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

class HelpSupportController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  
  /// User profile data (non-editable)
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;
  
  /// Editable fields
  final TextEditingController bookingIdController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// Fetch user profile from backend
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      
      final String token = await SecureStorageService().read(
        AppConstants.accessToken,
      ) ?? '';
      
      final NetworkResponse response = await NetworkCaller().getRequest(
        AppUrl.userProfile,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.isSuccess) {
        final data = response.jsonResponse?['data'] ?? {};
        
        userName.value = data['name'] ?? '';
        userEmail.value = data['email'] ?? '';
        userPhone.value = data['phone'] ?? '';
        
        LoggerUtils.debug('User profile loaded: ${userName.value}');
      } else {
        LoggerUtils.error('Failed to fetch user profile');
      }
    } catch (e) {
      LoggerUtils.debug('Error fetching user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Validate form before submission
  bool validateForm() {
    if (bookingIdController.text.trim().isEmpty) {
      Toast.showError('Please enter Booking ID');
      return false;
    }
    
    if (messageController.text.trim().isEmpty) {
      Toast.showError('Please enter your message');
      return false;
    }
    
    if (messageController.text.trim().length < 10) {
      Toast.showError('Message must be at least 10 characters');
      return false;
    }
    
    return true;
  }

  /// Submit support report
  Future<bool> submitReport() async {
    if (!validateForm()) {
      return false;
    }

    try {
      isSubmitting.value = true;
      
      final String token = await SecureStorageService().read(
        AppConstants.accessToken,
      ) ?? '';
      
      final payload = {
        'jobId': bookingIdController.text.trim(),
        'reason': messageController.text.trim(),
      };
      
      LoggerUtils.debug('Submitting report: $payload');
      
      final NetworkResponse response = await NetworkCaller().postRequest(
        AppUrl.report,
        headers: {'Authorization': 'Bearer $token'},
        body: payload,
      );
      
      if (response.isSuccess) {
        LoggerUtils.debug('Report submitted successfully');
        Toast.showSuccess('Report submitted successfully');
        
        // Clear form after successful submission
        bookingIdController.clear();
        messageController.clear();
        
        return true;
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to submit report';
        LoggerUtils.error('Report submission failed: $errorMessage');
        Toast.showError(errorMessage);
        return false;
      }
    } catch (e) {
      LoggerUtils.debug('Error submitting report: $e');
      Toast.showError('Failed to submit report');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    bookingIdController.dispose();
    messageController.dispose();
    super.onClose();
  }
}

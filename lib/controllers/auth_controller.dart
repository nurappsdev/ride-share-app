import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool changePasswordLoading = false.obs;
  final RxBool resetPasswordLoading = false.obs;

  /// Reset password (for forgot password flow)
  /// Endpoint: POST /auth/reset-password
  Future<bool> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    try {
      resetPasswordLoading.value = true;

      // Validate passwords match
      if (password != confirmPassword) {
        Toast.showError('Passwords do not match');
        return false;
      }

      // Validate password strength
      if (!AppConstants.validatePassword(password)) {
        Toast.showError('Password must be at least 8 characters with letters and numbers');
        return false;
      }

      final payload = {
        'password': password.trim(),
        'confirmPassword': confirmPassword.trim(),
      };

      LoggerUtils.debug('Reset password payload: $payload');

      final NetworkResponse response = await NetworkCaller().postRequest(
        AppUrl.resetPassword,
        body: payload,
      );

      if (response.isSuccess) {
        LoggerUtils.debug('Password reset successful');
        Toast.showSuccess('Password reset successfully');
        return true;
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to reset password';
        LoggerUtils.error('Password reset failed: $errorMessage');
        Toast.showError(errorMessage);
        return false;
      }
    } catch (e) {
      LoggerUtils.debug('Error resetting password: $e');
      Toast.showError('Failed to reset password');
      return false;
    } finally {
      resetPasswordLoading.value = false;
    }
  }

  /// Change password (for logged-in users)
  /// Endpoint: POST /auth/change-password
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      changePasswordLoading.value = true;

      // Validate password strength (minimum 8 characters)
      if (newPassword.trim().length < 8) {
        Toast.showError('New password must be at least 8 characters');
        return false;
      }

      final String token = await SecureStorageService().read(
        AppConstants.accessToken,
      ) ?? '';

      final payload = {
        'currentPassword': oldPassword.trim(),
        'password': newPassword.trim(),
        'confirmPassword': newPassword.trim(),
      };

      LoggerUtils.debug('Change password URL: ${AppUrl.changePassword}');
      LoggerUtils.debug('Change password payload: $payload');
      LoggerUtils.debug('Token: ${token.substring(0, 20)}...');

      final NetworkResponse response = await NetworkCaller().postRequest(
        AppUrl.changePassword,
        headers: {'Authorization': 'Bearer $token'},
        body: payload,
      );

      LoggerUtils.debug('Response status: ${response.isSuccess}');
      LoggerUtils.debug('Response code: ${response.statusCode}');
      LoggerUtils.debug('Response body: ${response.jsonResponse}');
      LoggerUtils.debug('Response error: ${response.errorMessage}');

      if (response.isSuccess) {
        LoggerUtils.debug('Password changed successfully');
        Toast.showSuccess('Password changed successfully');
        return true;
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? response.errorMessage ?? 'Failed to change password';
        LoggerUtils.error('Password change failed: $errorMessage');
        Toast.showError(errorMessage);
        return false;
      }
    } catch (e) {
      LoggerUtils.debug('Error changing password: $e');
      Toast.showError('Failed to change password: ${e.toString()}');
      return false;
    } finally {
      changePasswordLoading.value = false;
    }
  }

  /// Update password with confirmation (alternative method)
  Future<bool> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validate passwords match
    if (newPassword != confirmPassword) {
      Toast.showError('New passwords do not match');
      return false;
    }

    return await changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}

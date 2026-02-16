import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/user_enum.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

import '../../helpers/app_url.dart';
import '../../helpers/get_storage.dart';
import '../../helpers/secured_storage.dart';
import '../../services/network/network_caller.dart';
import '../../services/network/network_response.dart';
import '../../utils/app_constant.dart';
import '../../view/widgets/verify_mail_show_verification_dialog.dart';

class EmailVerifyController extends GetxController {
  final RxBool loader = false.obs;
  final RxBool resendOtpLoader = false.obs;

  handleOTPVerifyForSignUp({required String otp}) async {
    try {
      loader.value = true;

      final String currentRole = await GetStorageModel().read(
        AppConstants.currentRole,
      );
      final Map<String, dynamic> otpForSignUpForm = <String, dynamic>{
        "otp": otp,
      };
      LoggerUtils.debug(otpForSignUpForm);
      final String? verificationToken = await SecureStorageService().read(
        AppConstants.verificationToken,
      );
      final NetworkResponse postResponse = await NetworkCaller().postRequest(
        AppUrl.verifyMail,
        body: otpForSignUpForm,
        headers: <String, String>{'Authorization': 'Bearer $verificationToken'},
      );
      LoggerUtils.debug(postResponse.jsonResponse);
      if (postResponse.isSuccess) {
        LoggerUtils.debug(postResponse.jsonResponse);

        currentRole == UserRole.user.name
            ? VerificationDialog.show(Get.context!)
            : Get.offAllNamed(
                AppRoutes.completeProfileScreen,
                // preventDuplicates: false,
              );
        await SecureStorageService().write(
          AppConstants.accessToken,
          postResponse.jsonResponse?['data']['accessToken'] ?? '',
        );
        Toast.show(message: postResponse.jsonResponse?['message']);
      } else {
        LoggerUtils.debug(postResponse.jsonResponse?['message']);

        Toast.show(
          type: ToastType.error,
          position: ToastPosition.top,
          message: postResponse.jsonResponse?['message'],
        );
      }
    } catch (e) {
      LoggerUtils.debug("Exception : ${e.toString()}");
    } finally {
      loader.value = false;
    }
  }

  handleResendOTPForSignUp({
    required Map<String, dynamic> registrationForm,
  }) async {
    try {
      resendOtpLoader.value = true;

      final String? currentRole = await GetStorageModel().read(
        AppConstants.currentRole,
      );

      LoggerUtils.debug(registrationForm);

      final NetworkResponse postResponse = await NetworkCaller().postRequest(
        AppUrl.registerUser,
        body: registrationForm,
      );
      LoggerUtils.debug(postResponse.jsonResponse);
      if (postResponse.isSuccess) {
        LoggerUtils.debug(postResponse.jsonResponse);

        await SecureStorageService().write(
          AppConstants.verificationToken,
          postResponse.jsonResponse?['data']['verificationToken'] ?? '',
        );

        Toast.show(
          position: ToastPosition.bottom,
          message: postResponse.jsonResponse?['message'],
        );
      } else {
        LoggerUtils.debug(postResponse.jsonResponse?['message']);
        Toast.show(
          message: postResponse.jsonResponse?['message'],
          type: ToastType.error,
        );
      }
    } catch (e) {
      LoggerUtils.debug("Exception : ${e.toString()}");
    } finally {
      resendOtpLoader.value = false;
    }
  }
}

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

class PassengerDrawerController extends GetxController {
  final RxBool loader = false.obs;
  final RxBool resendOtpLoader = false.obs;

  handlePassengerLogout( ) async {
    try {
      loader.value = true;

      await SecureStorageService().clear();
      Get.offAllNamed(AppRoutes.roleScreen);
      Toast.showInfo('Successfully Logged out');
    } catch (e) {
      LoggerUtils.debug("Exception : ${e.toString()}");
    } finally {
      loader.value = false;
    }
  }
}

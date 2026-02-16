import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';
import '../../helpers/app_url.dart';
import '../../helpers/get_storage.dart';
import '../../helpers/secured_storage.dart';
import '../../services/network/network_caller.dart';
import '../../services/network/network_response.dart';
import '../../utils/app_constant.dart';

class SignUpController extends GetxController {
  final RxBool loader = false.obs;
  final TextEditingController fullNameTEController = TextEditingController();
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController phoneNumberTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  handleSignUp() async {
    try {
      loader.value = true;
      if (!formKey.currentState!.validate()) {
        return;
      }
      final String? currentRole = await GetStorageModel().read(
        AppConstants.currentRole,
      );
      LoggerUtils.warning(currentRole);
      final Map<String, dynamic> registrationForm = <String, dynamic>{
        "name": fullNameTEController.text.trim(),
        "email": emailTEController.text.trim(),
        "password": passwordTEController.text.trim(),
        "confirmPassword": confirmPasswordTEController.text.trim(),
        "role": currentRole,
      };
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

        Get.toNamed(
          AppRoutes.OTPVerifyScreen,
          arguments: {"registration_form": registrationForm},
          preventDuplicates: false,
        );
        Toast.show(
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
      loader.value = false;
    }
  }

  cleartextFields() {
    fullNameTEController.clear();
    phoneNumberTEController.clear();
    emailTEController.clear();
    passwordTEController.clear();
    confirmPasswordTEController.clear();
  }

  disposeControllers() {
    fullNameTEController.dispose();
    emailTEController.dispose();
    passwordTEController.dispose();
    confirmPasswordTEController.dispose();
    phoneNumberTEController.dispose();
  }

  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }
}

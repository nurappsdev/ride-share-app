import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/helpers.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/model/driver_registration/login_both/login_model.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';
import '../../helpers/app_url.dart';
import '../../helpers/get_storage.dart';
import '../../helpers/secured_storage.dart';
import '../../helpers/user_enum.dart';
import '../../services/network/network_caller.dart';
import '../../services/network/network_response.dart';
import '../../utils/app_constant.dart';

class SignInController extends GetxController {
  final RxBool loader = false.obs;
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final RxString selectedRole = 'passenger'.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// =======> LOGGED in user model ======> (common model)
  final Rxn<LoginUserModel> loginUserModel = Rxn<LoginUserModel>();

  handleSignIn() async {
    try {
      loader.value = true;
      if (!formKey.currentState!.validate()) {
        return;
      }
      final String currentRole =
          await GetStorageModel().read(AppConstants.currentRole) ?? '';
      final Map<String, dynamic> registrationForm = <String, dynamic>{
        "role": currentRole,
        "email": emailTEController.text.trim(),
        "password": passwordTEController.text,
      };
      LoggerUtils.debug(registrationForm);

      final NetworkResponse postResponse = await NetworkCaller().postRequest(
        AppUrl.login,
        body: registrationForm,
      );
      // LoggerUtils.debug(postResponse.jsonResponse);
      if (postResponse.isSuccess) {
        /// ===============> SAVE the response in a model =================>
        loginUserModel.value = LoginUserModel.fromJson(
          postResponse.jsonResponse?['data']['user'],
        );
        await PrefsHelper.setString(
          AppConstants.bearerToken,
          postResponse.jsonResponse?['data']?['tokens']?['accessToken'] ?? '',
        );
        LoggerUtils.info(loginUserModel.value.toString());
        await SecureStorageService().write(
          AppConstants.accessToken,
          postResponse.jsonResponse?['data']['tokens']['accessToken'] ?? '',
        );

        /// =================> Login According the specified role from the backend ============= >
        if (loginUserModel.value == null) {
          LoggerUtils.error('User Model Parsing error !!!');
          return;
        }
        if (loginUserModel.value!.role == UserRole.user.name) {
          Get.offAllNamed(AppRoutes.allBottomBar);
        } else if (loginUserModel.value!.role == UserRole.provider.name) {
          // Driver's Homepage ==============--->
          // Get.offAllNamed(AppRoutes.allBottomBar);
          Get.offAllNamed(AppRoutes.driverAvailableScreen);
        }
        Toast.show(
          message: postResponse.jsonResponse?['message'],
          type: ToastType.success,
        );
      }
      // ERROR RESPONSE ------------->
      else {
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
      passwordTEController.clear();
    }
  }

  cleartextFields() {
    emailTEController.clear();
    passwordTEController.clear();
  }

  disposeControllers() {
    emailTEController.dispose();
    passwordTEController.dispose();
  }

  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }
}

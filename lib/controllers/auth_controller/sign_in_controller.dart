import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/helpers.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/model/driver_registration/login_both/login_model.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';
import '../../datasource/chat_socket_datasource.dart';
import '../../helpers/app_url.dart';
import '../../helpers/get_storage.dart';
import '../../helpers/secured_storage.dart';
import '../../helpers/user_enum.dart';
import '../../services/network/network_caller.dart';
import '../../services/network/network_response.dart';
import '../../services/socket_services.dart';
import '../../utils/app_constant.dart';

class SignInController extends GetxController {
  final RxBool loader = false.obs;
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final RxString selectedRole = 'passenger'.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Rxn<LoginUserModel> loginUserModel = Rxn<LoginUserModel>();

  @override
  void onInit() {
    super.onInit();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    String? token = await PrefsHelper.getString(AppConstants.bearerToken);
    String? userId = await PrefsHelper.getString(AppConstants.userId);

    if (userId.isNotEmpty) {
      // Don't await this so it doesn't block UI rendering
      _connectSocket(userId);
    }
  }

  handleSignIn() async {
    try {
      loader.value = true;
      if (!formKey.currentState!.validate()) {
        return;
      }
      final String currentRole = await GetStorageModel().read(AppConstants.currentRole) ?? '';
      final Map<String, dynamic> registrationForm = <String, dynamic>{
        "role": currentRole,
        "email": emailTEController.text.trim(),
        "password": passwordTEController.text,
      };

      final NetworkResponse postResponse = await NetworkCaller().postRequest(
        AppUrl.login,
        body: registrationForm,
      );

      if (postResponse.isSuccess) {
        loginUserModel.value = LoginUserModel.fromJson(
          postResponse.jsonResponse?['data']['user'],
        );

        // SAVE THE USER ID
        final userId = postResponse.jsonResponse?['data']?['user']?['_id'] ?? '';
        await PrefsHelper.setString(AppConstants.userId, userId);

        // Save the Tokens
        await PrefsHelper.setString(AppConstants.bearerToken, postResponse.jsonResponse?['data']?['tokens']?['accessToken'] ?? '');
        await SecureStorageService().write(AppConstants.accessToken, postResponse.jsonResponse?['data']?['tokens']?['accessToken'] ?? '');

        // ===> FIX: Await socket initialization FIRST, then connect user
        await _connectSocket(userId);

        if (loginUserModel.value == null) {
          LoggerUtils.error('User Model Parsing error !!!');
          return;
        }

        if (loginUserModel.value!.role == UserRole.user.name) {
          Get.offAllNamed(AppRoutes.allBottomBar);
        } else if (loginUserModel.value!.role == UserRole.provider.name) {
          Get.offAllNamed(AppRoutes.driverAvailableScreen);
        }

        Toast.show(
          message: postResponse.jsonResponse?['message'],
          type: ToastType.success,
        );
      } else {
        Toast.show(
          message: postResponse.jsonResponse?['message'],
          type: ToastType.error,
        );
      }
    } catch (e) {
      LoggerUtils.error("Exception in handleSignIn: $e");
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

  /// connect socket
  Future<void> _connectSocket(String userId) async {
    try {
      final socketClient = Get.find<SocketClient>();

      // 1. Ensure the socket connection is established
      await socketClient.init();

      // 2. Add a tiny delay to ensure the server is ready to receive the emit
      // (Some Socket.IO setups drop immediate emits right after connection)
      await Future.delayed(const Duration(milliseconds: 200));

      // 3. Emit the user connection event
      final chatDataSource = ChatSocketDataSource(socketClient);
      chatDataSource.connectUser(userId);

      LoggerUtils.info("✅ AuthController: Socket Connected and User emitted for $userId");
    } catch (e) {
      LoggerUtils.error("❌ AuthController: Socket Connection Failed - $e");
    }
  }

  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }
}
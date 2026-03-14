import 'package:get/get.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

import '../../helpers/secured_storage.dart';
import '../../utils/app_constant.dart';

class DriverDrawerController extends GetxController {
  final RxBool loader = false.obs;
  final RxBool resendOtpLoader = false.obs;

  handlePassengerLogout() async {
    try {
      loader.value = true;

      // Clear secure storage (tokens)
      await SecureStorageService().clear();
      
      // Clear shared preferences (user data)
      await PrefsHelper.remove(AppConstants.bearerToken);
      await PrefsHelper.remove(AppConstants.resetPasswordToken);
      await PrefsHelper.remove(AppConstants.email);
      await PrefsHelper.remove(AppConstants.userId);
      await PrefsHelper.remove(AppConstants.name);
      await PrefsHelper.remove(AppConstants.role);
      await PrefsHelper.remove(AppConstants.step);
      await PrefsHelper.remove(AppConstants.status);
      await PrefsHelper.remove(AppConstants.isLogged);
      
      // Navigate to role screen
      Get.offAllNamed(AppRoutes.roleScreen);
      Toast.showInfo('Successfully Logged out');
    } catch (e) {
      LoggerUtils.debug("Exception : ${e.toString()}");
    } finally {
      loader.value = false;
    }
  }
}

import 'package:get/get.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/model/driver_registration/login_both/login_model.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

import '../../helpers/app_url.dart';
import '../../helpers/secured_storage.dart';
import '../../services/network/network_caller.dart';
import '../../services/network/network_response.dart';
import '../../utils/app_constant.dart';

class PassengerDrawerController extends GetxController {
  final RxBool loader = false.obs;
  final RxBool resendOtpLoader = false.obs;
  final RxBool isLoadingUser = false.obs;
  
  /// User data from backend
  final Rxn<LoginUserModel> userModel = Rxn<LoginUserModel>();
  
  /// Get user name (with fallback)
  String get userName => userModel.value?.name ?? 'Guest User';
  
  /// Get user email (with fallback)
  String get userEmail => userModel.value?.email ?? '';
  
  /// Get user profile image (with fallback)
  String? get userProfileImage => userModel.value?.profileImage;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// Refresh user profile (called when drawer opens)
  Future<void> refreshUserProfile() async {
    // Don't fetch if already loading
    if (isLoadingUser.value) return;
    
    await fetchUserProfile();
  }

  /// Fetch user profile from backend
  Future<void> fetchUserProfile() async {
    try {
      isLoadingUser.value = true;
      
      final String token = await SecureStorageService().read(
        AppConstants.accessToken,
      ) ?? '';
      
      final NetworkResponse response = await NetworkCaller().getRequest(
        AppUrl.userProfile,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.isSuccess) {
        final userData = response.jsonResponse?['data'] ?? {};
        userModel.value = LoginUserModel.fromJson(userData);
        LoggerUtils.debug('User profile fetched: ${userModel.value?.name}');
      } else {
        LoggerUtils.error(
          'Failed to fetch user profile: ${response.jsonResponse?['message']}',
        );
      }
    } catch (e) {
      LoggerUtils.debug('Error fetching user profile: $e');
    } finally {
      isLoadingUser.value = false;
    }
  }

  handlePassengerLogout( ) async {
    try {
      loader.value = true;

      await SecureStorageService().clear();
      userModel.value = null;
      Get.offAllNamed(AppRoutes.roleScreen);
      Toast.showInfo('Successfully Logged out');
    } catch (e) {
      LoggerUtils.debug("Exception : ${e.toString()}");
    } finally {
      loader.value = false;
    }
  }
  
  @override
  void onClose() {
    userModel.value = null;
    super.onClose();
  }
}

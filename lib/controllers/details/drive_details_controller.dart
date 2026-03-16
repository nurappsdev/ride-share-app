import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/helpers/logger_util.dart';

// 🚨 NEW: Import NetworkCaller
import 'package:split_ride/services/network/network_caller.dart';

import '../../model/driver/driver_model.dart';
import '../../utils/app_constant.dart';

class DriverDetailsController extends GetxController {
  bool isLoading = false;
  DriverModel? driverDetails;
  String userRole = 'user';

  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
    if (Get.arguments != null && Get.arguments['driverId'] != null) {
      String driverId = Get.arguments['driverId'].toString();
      getDriverDetails(driverId);
    } else {
      LoggerUtils.error("No driverId found in Get.arguments!");
    }
  }

  Future<void> _loadUserRole() async {
    userRole = await PrefsHelper.getString(AppConstants.role);
    update(); // Update the UI once the role is loaded
  }

  Future<void> getDriverDetails(String driverId) async {
    isLoading = true;
    update();

    try {
      // 1. Get the token manually
      final String token = await PrefsHelper.getString(AppConstants.bearerToken) ?? '';

      // 2. 🚨 THE FIX: Use NetworkCaller and prepend AppUrl.baseUrl to the path
      String url = "${AppUrl.baseUrl}${AppUrl.driveDetailsUrl(driverId)}";

      final response = await NetworkCaller().getRequest(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      // 3. Safely check for success using NetworkCaller syntax
      if (response.isSuccess && response.jsonResponse != null) {
        final responseData = response.jsonResponse!['data'];

        if (responseData != null) {
          driverDetails = DriverModel.fromJson(responseData);
          LoggerUtils.info(
            "Driver details fetched successfully: ${driverDetails?.name}",
          );
        }
      } else {
        LoggerUtils.error(
          "Failed to fetch driver details. Status: ${response.statusCode}, Message: ${response.jsonResponse?['message']}",
        );
      }
    } catch (e, stackTrace) {
      LoggerUtils.error("Error fetching driver details: $e", e, stackTrace);
    } finally {
      isLoading = false;
      update();
    }
  }
}
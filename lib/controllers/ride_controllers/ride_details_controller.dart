import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/model/ride/ride_details_model.dart';
import 'package:split_ride/services/api_client.dart';
import 'package:split_ride/helpers/logger_util.dart';

import '../../helpers/prefs_helper.dart';
import '../../helpers/secured_storage.dart';
import '../../services/network/network_caller.dart';
import '../../utils/app_constant.dart';

class RideDetailsController extends GetxController {
  bool isLoadingRideDetails = false;

  RideData? rideDetails;
  String userRole = 'provider';

  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
    if (Get.arguments != null && Get.arguments['rideId'] != null) {
      String jobId = Get.arguments['rideId'].toString();

      getRideDetails(jobId);
    } else {
      LoggerUtils.error("No rideId found in Get.arguments!");
    }
  }

  Future<void> _loadUserRole() async {
    userRole = await PrefsHelper.getString(AppConstants.role);
    update();
  }


  Future<void> getRideDetails(String jobId) async {
    try {
      isLoadingRideDetails = true;

      // 1. Get the token manually
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // 2. 🚨 THE FIX: Use NetworkCaller and AppUrl.baseUrl
      final response = await NetworkCaller().getRequest(
        '${AppUrl.baseUrl}/job/$jobId',
        headers: {'Authorization': 'Bearer $token'},
      );

      // 3. Safely check for success
      if (response.isSuccess && response.jsonResponse != null) {
        // ... parse your ride details here!
        // final data = response.jsonResponse!['data'];

      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Not Found';
        LoggerUtils.error('Failed to fetch ride details. Status: ${response.statusCode}, Message: $errorMessage');
      }
    } catch (e) {
      LoggerUtils.error('Error fetching ride details: $e');
    } finally {
      isLoadingRideDetails = false;
    }
  }
}
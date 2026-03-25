import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/model/ride/ride_details_model.dart'; // Make sure this path is correct
import 'package:split_ride/services/api_client.dart';
import 'package:split_ride/helpers/logger_util.dart';

import '../../helpers/prefs_helper.dart';
import '../../helpers/secured_storage.dart';
import '../../services/network/network_caller.dart';
import '../../utils/app_constant.dart';

class RideDetailsController extends GetxController {
  bool isLoadingRideDetails = false;

  // This will hold the fetched data
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
    update(); // Refresh UI
  }

  Future<void> getRideDetails(String jobId) async {
    try {
      isLoadingRideDetails = true;
      update(); // 🚨 Tell UI to show the loading spinner

      // 1. Get the token manually
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // 2. Use NetworkCaller and AppUrl.baseUrl
      final response = await NetworkCaller().getRequest(
        '${AppUrl.baseUrl}/job/$jobId',
        headers: {'Authorization': 'Bearer $token'},
      );

      // 3. Safely check for success
      if (response.isSuccess && response.jsonResponse != null) {

        final dynamic data = response.jsonResponse!['data'];
        LoggerUtils.info("Ride details fetched successfully! ${data}");
        // Parse the JSON into your RideData model
        if (data != null) {
          rideDetails = RideData.fromJson(data);
          LoggerUtils.info("Ride details fetched successfully!");

        }

      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Not Found';
        LoggerUtils.error('Failed to fetch ride details. Status: ${response.statusCode}, Message: $errorMessage');
      }
    } catch (e) {
      LoggerUtils.error('Error fetching ride details: $e');
    } finally {
      isLoadingRideDetails = false;
      update(); // 🚨 Tell UI to hide loading spinner and show data
    }
  }
}
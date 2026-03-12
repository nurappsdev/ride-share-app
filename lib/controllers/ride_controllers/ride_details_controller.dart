import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/model/ride/ride_details_model.dart';
import 'package:split_ride/services/api_client.dart';
import 'package:split_ride/helpers/logger_util.dart';

class RideDetailsController extends GetxController {
  bool isLoadingRideDetails = false;

  RideData? rideDetails;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments['rideId'] != null) {
      String jobId = Get.arguments['rideId'].toString();

      getRideDetails(jobId);
    } else {
      LoggerUtils.error("No rideId found in Get.arguments!");
    }
  }

  Future<void> getRideDetails(String jobId) async {
    isLoadingRideDetails = true;
    update();

    try {
      final response = await ApiClient.getData(AppUrl.rideUrl(jobId));

      if (response.statusCode == 200) {
        final responseData = response.body['data'];

        if (responseData != null) {
          rideDetails = RideData.fromJson(responseData);
          LoggerUtils.info("Ride details fetched successfully for ID: ${rideDetails?.id}");
        }
      } else {
        LoggerUtils.error("Failed to fetch ride details. Status: ${response.statusCode}, Message: ${response.statusText}");
      }
    } catch (e, stackTrace) {
      LoggerUtils.error("Error fetching ride details: $e", e, stackTrace);
    } finally {
      isLoadingRideDetails = false;
      update();
    }
  }
}
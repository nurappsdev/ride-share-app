import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/services/api_client.dart';
import 'package:split_ride/helpers/logger_util.dart';

import '../../model/driver/driver_model.dart';

class DriverDetailsController extends GetxController {
  bool isLoading = false;
  DriverModel? driverDetails;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['driverId'] != null) {
      String driverId = Get.arguments['driverId'].toString();
      getDriverDetails(driverId);
    } else {
      LoggerUtils.error("No driverId found in Get.arguments!");
    }
  }

  Future<void> getDriverDetails(String driverId) async {
    isLoading = true;
    update();

    try {
      final response = await ApiClient.getData(
        AppUrl.driveDetailsUrl(driverId),
      );

      if (response.statusCode == 200) {
        final responseData = response.body['data'];

        if (responseData != null) {
          driverDetails = DriverModel.fromJson(responseData);
          LoggerUtils.info(
            "Driver details fetched successfully: ${driverDetails?.name}",
          );
        }
      } else {
        LoggerUtils.error(
          "Failed to fetch driver details. Status: ${response.statusCode}",
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

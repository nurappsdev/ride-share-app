import 'package:get/get.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/model/provider_requested_ride_model.dart';
import 'package:split_ride/services/api_client.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/utils/app_constant.dart';

class DriverAvailableRidesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<ProviderRequestedRideModel> requestedRides = <ProviderRequestedRideModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequestedRides();
  }

  Future<void> fetchRequestedRides() async {
    try {
      isLoading.value = true;

      String url = "/job/provider/requested";

      // 1. Just call ApiClient. It handles the token and headers automatically!
      final response = await ApiClient.getData(url);

      // 2. Use statusCode == 200 instead of isSuccess
      if (response.statusCode == 200) {

        // 3. ApiClient already decodes the JSON into response.body
        final List<dynamic> data = response.body['data'] ?? [];

        requestedRides.clear();
        for (var item in data) {
          requestedRides.add(ProviderRequestedRideModel.fromJson(item));
        }

        LoggerUtils.info('Loaded ${requestedRides.length} requested rides');
      } else {
        // 4. Access the error message from response.body
        final errorMessage = response.body['message'] ?? response.statusText;
        LoggerUtils.error('Failed to load rides: $errorMessage');
      }
    } catch (e) {
      LoggerUtils.error('Error fetching requested rides: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
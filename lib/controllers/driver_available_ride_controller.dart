import 'package:get/get.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/model/provider_requested_ride_model.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/utils/app_constant.dart';

class DriverAvailableRidesController extends GetxController {
  // Observables for UI state
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxList<ProviderRequestedRideModel> requestedRides = <ProviderRequestedRideModel>[].obs;

  // Pagination Trackers
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void onInit() {
    super.onInit();
    fetchRequestedRides(isRefresh: true);
  }

  /// Fetches rides from the API.
  Future<void> fetchRequestedRides({bool isRefresh = false}) async {
    // 1. Handle Pagination State
    if (isRefresh) {
      _currentPage = 1;
      isLoading.value = true;
    } else {
      // Stop if we are already loading or have reached the last page
      if (isMoreLoading.value || _currentPage >= _totalPages) return;

      _currentPage++;
      isMoreLoading.value = true;
    }

    try {
      // 2. Get the token manually for NetworkCaller
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // 3. 🚨 THE FIX: Use AppUrl.baseUrl + NetworkCaller
      String url = "${AppUrl.baseUrl}/job/provider/requested?page=$_currentPage&limit=10";

      final response = await NetworkCaller().getRequest(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      // 4. Safely check for success using NetworkCaller syntax
      if (response.isSuccess && response.jsonResponse != null) {
        final responseData = response.jsonResponse!;

        // Extract Data
        final List<dynamic> data = responseData['data'] ?? [];

        // Extract Pagination Info
        if (responseData['pagination'] != null) {
          _totalPages = responseData['pagination']['totalPages'] ?? 1;
        }

        // Clear list if it's a fresh pull
        if (isRefresh) {
          requestedRides.clear();
        }

        // Parse and add items safely
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            requestedRides.add(ProviderRequestedRideModel.fromJson(item));
          }
        }

        LoggerUtils.info('Loaded ${requestedRides.length} requested rides (Page $_currentPage/$_totalPages)');
      } else {
        // Handle server errors cleanly
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to load rides. Server returned ${response.statusCode}';
        LoggerUtils.error('Failed to load rides: $errorMessage');
      }
    } catch (e) {
      LoggerUtils.error('Error fetching requested rides: $e');

      // If pagination fails, revert the page count so the user can try again
      if (!isRefresh && _currentPage > 1) {
        _currentPage--;
      }
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// Easy helper method to trigger loading the next page from the UI
  void loadMore() {
    fetchRequestedRides(isRefresh: false);
  }


// ===========================================================================
  // ACCEPT & DECLINE RIDE FUNCTIONS
  // ===========================================================================

  final RxString acceptingTrId = ''.obs;
  final RxString decliningTrId = ''.obs;

// --- ACCEPT RIDE ---
  Future<bool> acceptRide(String jobId, String trId) async {
    try {
      // Use trId to track the loading state for this specific card
      acceptingTrId.value = trId;

      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // 🚨 THE FIX: Passing both jobId and trId in the URL
      final response = await NetworkCaller().postRequest(
        '${AppUrl.baseUrl}/job/provider/accept/$jobId/$trId',
        headers: {'Authorization': 'Bearer $token'},
        body: {},
      );

      if (response.isSuccess) {
        // SUCCESS! Remove from list
        requestedRides.removeWhere((ride) => ride.trId == trId);
        return true;
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to accept ride.';
        Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      LoggerUtils.error('Error accepting ride: $e');
      Get.snackbar('Error', 'Something went wrong', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      acceptingTrId.value = ''; // Stop loading spinner
    }
  }

  // --- DECLINE RIDE ---
  Future<bool> declineRide(String trId) async {
    try {
      decliningTrId.value = trId; // Start loading spinner on the Decline button

      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // Assuming PUT or POST based on your backend setup (using POST as default safe approach)
      final response = await NetworkCaller().postRequest(
        '${AppUrl.baseUrl}/job/provider/decline/tr/$trId',
        headers: {'Authorization': 'Bearer $token'},
        body: {},
      );

      if (response.isSuccess) {
        // SUCCESS! Remove from list
        requestedRides.removeWhere((ride) => ride.trId == trId);
        return true;
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to decline ride.';
        Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      LoggerUtils.error('Error declining ride: $e');
      Get.snackbar('Error', 'Something went wrong', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      decliningTrId.value = ''; // Stop loading spinner
    }
  }
}
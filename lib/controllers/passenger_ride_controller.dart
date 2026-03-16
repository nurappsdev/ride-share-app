import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

import '../model/driver_registration/passenger_models/passenger_ongoing_rides.dart';

class PassengerMyRidesController extends GetxController {
  final RxBool isLoadingOngoing = false.obs;
  final RxBool isMoreLoadingOngoing = false.obs;

  final RxBool isLoadingCompleted = false.obs;
  final RxBool isMoreLoadingCompleted = false.obs; // Added for Past Rides pagination

  final RxBool isCancelling = false.obs;

  // Pagination Trackers
  int _currentOngoingPage = 1;
  int _totalOngoingPages = 1;

  int _currentCompletedPage = 1;
  int _totalCompletedPages = 1;

  // Tab selection
  final RxBool isUpcoming = true.obs;

  // Ride lists
  final RxList<PassengerOngoingRidesModel> ongoingRides = <PassengerOngoingRidesModel>[].obs;
  final RxList<PassengerOngoingRidesModel> completedRides = <PassengerOngoingRidesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOngoingRides(isRefresh: true);
    fetchCompletedRides(isRefresh: true);
  }

  // ===========================================================================
  // ONGOING RIDES
  // ===========================================================================
  Future<void> fetchOngoingRides({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentOngoingPage = 1;
      isLoadingOngoing.value = true;
    } else {
      if (isMoreLoadingOngoing.value || _currentOngoingPage >= _totalOngoingPages) return;
      _currentOngoingPage++;
      isMoreLoadingOngoing.value = true;
    }

    try {
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';
      String url = "${AppUrl.passengerOngoingRide}?page=$_currentOngoingPage&limit=10";

      final NetworkResponse response = await NetworkCaller().getRequest(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess && response.jsonResponse != null) {
        final responseData = response.jsonResponse!;
        final List<dynamic> data = responseData['data'] ?? [];

        debugPrint("=== RAW ONGOING RIDES JSON (Page $_currentOngoingPage) ===");
        debugPrint(const JsonEncoder.withIndent('  ').convert(data));
        debugPrint("==========================================================");

        if (responseData['pagination'] != null) {
          _totalOngoingPages = responseData['pagination']['totalPages'] ?? 1;
        }

        if (isRefresh) {
          ongoingRides.clear();
        }

        for (var rideJson in data) {
          try {
            final ride = PassengerOngoingRidesModel.fromJson(rideJson);
            if (ride.status != null &&
                (ride.status == 'created' ||
                    ride.status == 'requested' ||
                    ride.status == 'paid' ||
                    ride.status == 'accepted' ||
                    ride.status == 'picked')) {
              ongoingRides.add(ride);
            }
          } catch (e) {
            LoggerUtils.error('Error parsing ride: $e');
          }
        }
      } else {
        LoggerUtils.error('Failed to fetch ongoing rides: ${response.jsonResponse?['message']}');
      }
    } catch (e) {
      LoggerUtils.error('Error fetching ongoing rides: $e');
      if (!isRefresh && _currentOngoingPage > 1) _currentOngoingPage--;
    } finally {
      isLoadingOngoing.value = false;
      isMoreLoadingOngoing.value = false;
    }
  }

  void loadMoreOngoingRides() => fetchOngoingRides(isRefresh: false);

  // ===========================================================================
  // COMPLETED / PAST RIDES (Now hitting /job/history)
  // ===========================================================================
  Future<void> fetchCompletedRides({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentCompletedPage = 1;
      isLoadingCompleted.value = true;
    } else {
      if (isMoreLoadingCompleted.value || _currentCompletedPage >= _totalCompletedPages) return;
      _currentCompletedPage++;
      isMoreLoadingCompleted.value = true;
    }

    try {
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // 🚨 THE FIX: Hits /job/history with pagination
      String url = "${AppUrl.baseUrl}/job/history?page=$_currentCompletedPage&limit=10";

      final NetworkResponse response = await NetworkCaller().getRequest(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess && response.jsonResponse != null) {
        final responseData = response.jsonResponse!;
        final List<dynamic> data = responseData['data'] ?? [];

        if (responseData['pagination'] != null) {
          _totalCompletedPages = responseData['pagination']['totalPages'] ?? 1;
        }

        if (isRefresh) {
          completedRides.clear();
        }

        for (var rideJson in data) {
          try {
            final ride = PassengerOngoingRidesModel.fromJson(rideJson);
            // Assuming history API only returns completed/cancelled anyway
            completedRides.add(ride);
          } catch (e) {
            LoggerUtils.error('Error parsing completed ride: $e');
          }
        }
      } else {
        LoggerUtils.error('Failed to fetch completed rides: ${response.jsonResponse?['message']}');
      }
    } catch (e) {
      LoggerUtils.error('Error fetching completed rides: $e');
      if (!isRefresh && _currentCompletedPage > 1) _currentCompletedPage--;
    } finally {
      isLoadingCompleted.value = false;
      isMoreLoadingCompleted.value = false;
    }
  }

  void loadMoreCompletedRides() => fetchCompletedRides(isRefresh: false);

  // ===========================================================================
  // OTHER METHODS
  // ===========================================================================
  Future<bool> cancelRide(String jobId) async {
    try {
      isCancelling.value = true;
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final response = await NetworkCaller().postRequest(
        '${AppUrl.cancelRide}/$jobId',
        headers: {'Authorization': 'Bearer $token'},
        body: {},
      );

      if (response.isSuccess) {
        Toast.showSuccess('Ride cancelled successfully');
        ongoingRides.removeWhere((ride) => ride.jobId == jobId);
        return true;
      } else {
        Toast.showError(response.jsonResponse?['message'] ?? 'Failed to cancel ride');
        return false;
      }
    } catch (e) {
      Toast.showError('Failed to cancel ride');
      return false;
    } finally {
      isCancelling.value = false;
    }
  }

  Future<void> refreshCurrentTab() async {
    if (isUpcoming.value) {
      await fetchOngoingRides(isRefresh: true);
    } else {
      await fetchCompletedRides(isRefresh: true);
    }
  }

  void switchToUpcoming() => isUpcoming.value = true;
  void switchToPast() => isUpcoming.value = false;

  List<PassengerOngoingRidesModel> get currentRides => isUpcoming.value ? ongoingRides : completedRides;
  bool get isCurrentTabLoading => isUpcoming.value ? isLoadingOngoing.value : isLoadingCompleted.value;

  bool canCancelRide(PassengerOngoingRidesModel ride) {
    if (ride.dateTime == null) return false;
    return ride.dateTime!.difference(DateTime.now()).inHours >= 24;
  }

  double getCancellationFee(PassengerOngoingRidesModel ride) {
    if (ride.dateTime == null) return 0.0;
    final difference = ride.dateTime!.difference(DateTime.now());
    if (difference.inHours >= 24) return 0.0;
    else if (difference.inHours >= 2) return 50.0;
    else return 100.0;
  }
}
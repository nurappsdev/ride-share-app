import 'dart:convert'; // Added for pretty printing JSON
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/services/api_client.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

import '../model/driver_registration/passenger_models/passenger_ongoing_rides.dart';

class PassengerMyRidesController extends GetxController {
  final RxBool isLoadingOngoing = false.obs;
  final RxBool isMoreLoadingOngoing = false.obs; // Pagination loading state
  final RxBool isLoadingCompleted = false.obs;
  final RxBool isCancelling = false.obs;

  // Pagination Trackers for Ongoing Rides
  int _currentOngoingPage = 1;
  int _totalOngoingPages = 1;

  // Tab selection
  final RxBool isUpcoming = true.obs;

  // Ride lists
  final RxList<PassengerOngoingRidesModel> ongoingRides = <PassengerOngoingRidesModel>[].obs;
  final RxList<PassengerOngoingRidesModel> completedRides = <PassengerOngoingRidesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOngoingRides(isRefresh: true);
    fetchCompletedRides();
  }

  /// Fetch ongoing/upcoming rides with Pagination
  Future<void> fetchOngoingRides({bool isRefresh = false}) async {
    // 1. Handle Pagination State
    if (isRefresh) {
      _currentOngoingPage = 1;
      isLoadingOngoing.value = true;
    } else {
      // Stop if already loading or reached the end
      if (isMoreLoadingOngoing.value || _currentOngoingPage >= _totalOngoingPages) return;

      _currentOngoingPage++;
      isMoreLoadingOngoing.value = true;
    }

    try {
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // 2. Append Pagination Query Parameters
      // Assuming AppUrl.passengerOngoingRide does not already have query params
      String url = "${AppUrl.passengerOngoingRide}?page=$_currentOngoingPage&limit=10";

      final NetworkResponse response = await NetworkCaller().getRequest(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess && response.jsonResponse != null) {
        final responseData = response.jsonResponse!;
        final List<dynamic> data = responseData['data'] ?? [];

        // =========================================================
        // PRINT ALL RIDE JSON TO TERMINAL (Nicely formatted)
        // =========================================================
        debugPrint("=== RAW ONGOING RIDES JSON (Page $_currentOngoingPage) ===");
        debugPrint(const JsonEncoder.withIndent('  ').convert(data));
        debugPrint("==========================================================");

        // Extract Pagination Info
        if (responseData['pagination'] != null) {
          _totalOngoingPages = responseData['pagination']['totalPages'] ?? 1;
        }

        // Clear list if it's a fresh pull
        if (isRefresh) {
          ongoingRides.clear();
        }

        for (var rideJson in data) {
          try {
            final ride = PassengerOngoingRidesModel.fromJson(rideJson);

            // Only add rides with relevant statuses
            if (ride.status != null &&
                (ride.status == 'created' ||
                    ride.status == 'requested' ||
                    ride.status == 'paid' ||     // Added 'paid' so they show up waiting for driver!
                    ride.status == 'accepted' ||
                    ride.status == 'picked')) {
              ongoingRides.add(ride);
            }
          } catch (e) {
            LoggerUtils.error('Error parsing ride: $e');
          }
        }

        LoggerUtils.debug('Ongoing rides loaded: ${ongoingRides.length} (Page $_currentOngoingPage/$_totalOngoingPages)');
      } else {
        LoggerUtils.error('Failed to fetch ongoing rides: ${response.jsonResponse?['message']}');
      }
    } catch (e) {
      LoggerUtils.error('Error fetching ongoing rides: $e');
      Toast.showError('Failed to load ongoing rides');

      // Revert page count if pagination fails
      if (!isRefresh && _currentOngoingPage > 1) {
        _currentOngoingPage--;
      }
    } finally {
      isLoadingOngoing.value = false;
      isMoreLoadingOngoing.value = false;
    }
  }

  /// Helper to trigger pagination from UI
  void loadMoreOngoingRides() {
    fetchOngoingRides(isRefresh: false);
  }

  /// Fetch completed/past rides
  Future<void> fetchCompletedRides() async {
    try {
      isLoadingCompleted.value = true;

      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final NetworkResponse response = await NetworkCaller().getRequest(
        '${AppUrl.imageUploadUrl}/', // Adjust this URL as needed
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess) {
        final List<dynamic> data = response.jsonResponse?['data'] ?? [];

        completedRides.clear();

        for (var rideJson in data) {
          try {
            final ride = PassengerOngoingRidesModel.fromJson(rideJson);

            // Only add completed rides
            if (ride.status != null && (ride.status == 'completed')) {
              completedRides.add(ride);
            }
          } catch (e) {
            LoggerUtils.error('Error parsing completed ride: $e');
          }
        }

        LoggerUtils.debug('Completed rides loaded: ${completedRides.length}');
      } else {
        LoggerUtils.error('Failed to fetch completed rides: ${response.jsonResponse?['message']}');
      }
    } catch (e) {
      LoggerUtils.error('Error fetching completed rides: $e');
      Toast.showError('Failed to load past rides');
    } finally {
      isLoadingCompleted.value = false;
    }
  }

  /// Cancel a ride
  Future<bool> cancelRide(String jobId) async {
    try {
      isCancelling.value = true;

      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // Use NetworkCaller instead of ApiClient to ensure consistent formatting
      final response = await NetworkCaller().postRequest(
        '${AppUrl.cancelRide}/$jobId',
        headers: {'Authorization': 'Bearer $token'},
        body: {},
      );

      if (response.isSuccess) {
        Toast.showSuccess('Ride cancelled successfully');

        // Remove from ongoing rides list locally
        ongoingRides.removeWhere((ride) => ride.jobId == jobId);

        LoggerUtils.debug('Ride cancelled: $jobId');
        return true;
      } else {
        final errorMessage = response.jsonResponse?['message'] ?? 'Failed to cancel ride';
        Toast.showError(errorMessage);
        LoggerUtils.error('Cancel failed: ${response.jsonResponse}');
        return false;
      }
    } catch (e) {
      LoggerUtils.error('Error cancelling ride: $e');
      Toast.showError('Failed to cancel ride');
      return false;
    } finally {
      isCancelling.value = false;
    }
  }

  /// Refresh current tab
  Future<void> refreshCurrentTab() async {
    if (isUpcoming.value) {
      await fetchOngoingRides(isRefresh: true);
    } else {
      await fetchCompletedRides();
    }
  }

  /// Switch to upcoming tab
  void switchToUpcoming() {
    isUpcoming.value = true;
  }

  /// Switch to past tab
  void switchToPast() {
    isUpcoming.value = false;
  }

  /// Get current rides list based on selected tab
  List<PassengerOngoingRidesModel> get currentRides {
    return isUpcoming.value ? ongoingRides : completedRides;
  }

  /// Get loading state for current tab
  bool get isCurrentTabLoading {
    return isUpcoming.value ? isLoadingOngoing.value : isLoadingCompleted.value;
  }

  /// Check if ride can be cancelled (within 24 hours)
  bool canCancelRide(PassengerOngoingRidesModel ride) {
    if (ride.dateTime == null) return false;

    final now = DateTime.now();
    final rideTime = ride.dateTime!;
    final difference = rideTime.difference(now);

    return difference.inHours >= 24;
  }

  /// Get cancellation fee percentage
  double getCancellationFee(PassengerOngoingRidesModel ride) {
    if (ride.dateTime == null) return 0.0;

    final now = DateTime.now();
    final rideTime = ride.dateTime!;
    final difference = rideTime.difference(now);

    if (difference.inHours >= 24) {
      return 0.0;
    } else if (difference.inHours >= 2) {
      return 50.0;
    } else {
      return 100.0;
    }
  }

  /// Calculate refund amount
  double getRefundAmount(PassengerOngoingRidesModel ride) {
    if (ride.totalFare == null) return 0.0;

    final fee = getCancellationFee(ride);
    final refundPercentage = 100 - fee;

    return (ride.totalFare! * refundPercentage) / 100;
  }
}
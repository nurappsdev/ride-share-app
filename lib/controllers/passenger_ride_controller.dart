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
  final RxBool isLoadingCompleted = false.obs;
  final RxBool isCancelling = false.obs;

  // Tab selection
  final RxBool isUpcoming = true.obs;

  // Ride lists
  final RxList<PassengerOngoingRidesModel> ongoingRides = <PassengerOngoingRidesModel>[].obs;
  final RxList<PassengerOngoingRidesModel> completedRides = <PassengerOngoingRidesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOngoingRides();
    fetchCompletedRides();
  }

  /// Fetch ongoing/upcoming rides
  Future<void> fetchOngoingRides() async {
    try {
      isLoadingOngoing.value = true;

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final NetworkResponse response = await NetworkCaller().getRequest(
        AppUrl.passengerOngoingRide,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess) {
        final List<dynamic> data = response.jsonResponse?['data'] ?? [];

        ongoingRides.clear();

        for (var rideJson in data) {
          try {
            final ride = PassengerOngoingRidesModel.fromJson(rideJson);

            // Only add rides with relevant statuses
            if (ride.status != null &&
                (ride.status == 'created' ||
                    ride.status == 'requested' ||
                    ride.status == 'accepted' ||
                    ride.status == 'picked')) {
              ongoingRides.add(ride);
            }
          } catch (e) {
            LoggerUtils.error('Error parsing ride: $e');
          }
        }

        LoggerUtils.debug('Ongoing rides loaded: ${ongoingRides.length}');
      } else {
        LoggerUtils.error(
          'Failed to fetch ongoing rides: ${response.jsonResponse?['message']}',
        );
      }
    } catch (e) {
      LoggerUtils.error('Error fetching ongoing rides: $e');
      Toast.showError('Failed to load ongoing rides');
    } finally {
      isLoadingOngoing.value = false;
    }
  }

  /// Fetch completed/past rides
  Future<void> fetchCompletedRides() async {
    try {
      isLoadingCompleted.value = true;

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // Assuming there's a separate endpoint for completed rides
      // If not, we can filter from the same endpoint
      final NetworkResponse response = await NetworkCaller().getRequest(
        // AppUrl.passengerCompletedRides, // Add this to AppUrl
        '${AppUrl.imageUploadUrl}/', // Add this to AppUrl: /job/{id}/cancel
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess) {
        final List<dynamic> data = response.jsonResponse?['data'] ?? [];

        completedRides.clear();

        for (var rideJson in data) {
          try {
            final ride = PassengerOngoingRidesModel.fromJson(rideJson);

            // Only add completed rides
            if (ride.status != null &&
                (ride.status == 'completed' ||
                    ride.status == 'paid')) {
              completedRides.add(ride);
            }
          } catch (e) {
            LoggerUtils.error('Error parsing completed ride: $e');
          }
        }

        LoggerUtils.debug('Completed rides loaded: ${completedRides.length}');
      } else {
        LoggerUtils.error(
          'Failed to fetch completed rides: ${response.jsonResponse?['message']}',
        );
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

      final String token =
          await SecureStorageService().read(AppConstants.accessToken) ?? '';

      final  response = await ApiClient.postData(
        '${AppUrl.cancelRide}/$jobId', // Add this to AppUrl: /job/{id}/cancel
        // '/job/cancel/$jobId',
       {},
        headers: {'Authorization': 'Bearer $token'},

      );

      if (response.isSuccess) {
        Toast.showSuccess('Ride cancelled successfully');

        // Remove from ongoing rides list
        ongoingRides.removeWhere((ride) => ride.jobId == jobId);

        // Refresh rides
        await fetchOngoingRides();

        LoggerUtils.debug('Ride cancelled: $jobId');
        return true;
      } else {
        final errorMessage = response.jsonResponse?['message'] ??
            'Failed to cancel ride';
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
      await fetchOngoingRides();
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

    // Can cancel if ride is more than 24 hours away
    return difference.inHours >= 24;
  }

  /// Get cancellation fee percentage
  double getCancellationFee(PassengerOngoingRidesModel ride) {
    if (ride.dateTime == null) return 0.0;

    final now = DateTime.now();
    final rideTime = ride.dateTime!;
    final difference = rideTime.difference(now);

    // More than 24 hours: 0% fee (full refund)
    if (difference.inHours >= 24) {
      return 0.0;
    }
    // Between 2-24 hours: 50% fee
    else if (difference.inHours >= 2) {
      return 50.0;
    }
    // Less than 2 hours: 100% fee (no refund)
    else {
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
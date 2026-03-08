import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
  import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_icons.dart';
import 'package:split_ride/view/widgets/custom_loading.dart';
import '../../../../controllers/passenger_ride_controller.dart';
import '../../../../model/driver_registration/passenger_models/passenger_ongoing_rides.dart';
import '../../../widgets/widgets.dart';

class PassengerMyRidesScreen extends StatelessWidget {
  const PassengerMyRidesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PassengerMyRidesController controller = Get.put(PassengerMyRidesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: CustomText(
          text: 'My Rides',
          color: Colors.black,
          fontsize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 24.w,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Selector
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34.r),
                color: Colors.grey[200],
              ),
              child: Obx(() => Row(
                children: [
                  // Upcoming Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.switchToUpcoming(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          gradient: controller.isUpcoming.value
                              ? const LinearGradient(
                            colors: [
                              Color(0xFF45C4D9),
                              Color(0xFF6B7FEC),
                              Color(0xFFB565D8),
                            ],
                          )
                              : null,
                          color: controller.isUpcoming.value
                              ? null
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(34.r),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Upcoming Rides',
                            color: controller.isUpcoming.value
                                ? Colors.white
                                : AppColors.primary3rdColor,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Past Rides Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.switchToPast(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          gradient: !controller.isUpcoming.value
                              ? const LinearGradient(
                            colors: [
                              Color(0xFF45C4D9),
                              Color(0xFF6B7FEC),
                              Color(0xFFB565D8),
                            ],
                          )
                              : null,
                          color: !controller.isUpcoming.value
                              ? null
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25.w),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Past Rides',
                            color: !controller.isUpcoming.value
                                ? Colors.white
                                : AppColors.primary3rdColor,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),

          // Rides List
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isCurrentTabLoading) {
                return Center(
                  child: CustomLoading(),
                );
              }

              // Empty state
              final rides = controller.currentRides;
              if (rides.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        size: 80.sp,
                        color: AppColors.primary3rdColor,
                      ),
                      SizedBox(height: 16.h),
                      CustomText(
                        text: controller.isUpcoming.value
                            ? 'No Upcoming Rides'
                            : 'No Past Rides',
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: controller.isUpcoming.value
                            ? 'Book your first ride now!'
                            : 'Your completed rides will appear here',
                        fontsize: 14.sp,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              }

              // Rides list
              return RefreshIndicator(
                onRefresh: () => controller.refreshCurrentTab(),
                color: AppColors.primary3rdColor,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    final ride = rides[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < rides.length - 1 ? 16.h : 0,
                      ),
                      child: RideCard(
                        ride: ride,
                        isPastRide: !controller.isUpcoming.value,
                        onCancel: () => controller.cancelRide(ride.jobId ?? ''),
                        canCancel: controller.canCancelRide(ride),
                        cancellationFee: controller.getCancellationFee(ride),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class RideCard extends StatelessWidget {
  final PassengerOngoingRidesModel ride;
  final bool isPastRide;
  final VoidCallback onCancel;
  final bool canCancel;
  final double cancellationFee;

  const RideCard({
    Key? key,
    required this.ride,
    required this.isPastRide,
    required this.onCancel,
    required this.canCancel,
    required this.cancellationFee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to track driver screen with ride details
        Get.toNamed(
          AppRoutes.trackDriversScreen,
          preventDuplicates: false,
          arguments: {'rideId': ride.jobId},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Section - Locations
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppIcons.mapIcon,
                    width: 70.w,
                    height: 70.w,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pickup Location
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: const Color(0xFF5ED5F3),
                              size: 20.w,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: CustomText(
                                text: ride.fromAddress ?? 'Unknown Location',
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w500,
                                maxline: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Drop Location
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: const Color(0xFF9C8FFF),
                              size: 20.w,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: CustomText(
                                text: ride.toAddress ?? 'Unknown Destination',
                                fontsize: 13.sp,
                                fontWeight: FontWeight.w500,
                                maxline: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Download Invoice (Past rides only)
                        if (isPastRide)
                          InkWell(
                            onTap: () {
                              // TODO: Download invoice
                              Get.snackbar(
                                'Invoice',
                                'Downloading invoice for ${ride.jobId}',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.primary3rdColor,
                                colorText: Colors.white,
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.receipt,
                                  color: AppColors.primary3rdColor,
                                  size: 18.w,
                                ),
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: 'Download invoice',
                                  fontsize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary3rdColor,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Section - Details
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildInfoRow('Booking ID', ride.jobId ?? 'N/A'),
                  _buildDivider(),
                  _buildInfoRow(
                    'Date & Time',
                    _formatDateTime(ride.dateTime),
                  ),
                  _buildDivider(),
                  _buildInfoRow('Driver', ride.userName ?? 'Not Assigned'),
                  _buildDivider(),
                  _buildInfoRow('Car seats', '${ride.seat ?? 0}'),
                  _buildDivider(),
                  _buildInfoRow(
                    'Total Fare',
                    '€${ride.totalFare?.toStringAsFixed(2) ?? '0.00'}',
                  ),
                  _buildDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Status',
                        color: Colors.grey,
                        fontsize: 14.sp,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(ride.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: CustomText(
                          text: _formatStatus(ride.status),
                          color: _getStatusColor(ride.status),
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // Cancel Option (Upcoming rides only)
                  if (!isPastRide && ride.status != 'completed') ...[
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: Colors.grey,
                          size: 20.w,
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: 'Cancel your ride?',
                          color: Colors.grey,
                          fontsize: 14.sp,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            _showCancelRideDialog(
                              context,
                              ride.jobId ?? '',
                              cancellationFee,
                              ride.totalFare ?? 0.0,
                              onCancel,
                            );
                          },
                          child: CustomText(
                            text: 'Cancel',
                            color: Colors.red,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            color: Colors.grey,
            fontsize: 14.sp,
          ),
          Flexible(
            child: CustomText(
              text: value,
              color: Colors.black,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.right,
              maxline: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Divider(color: Colors.grey[200]),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  String _formatStatus(String? status) {
    if (status == null) return 'Unknown';
    return status.substring(0, 1).toUpperCase() + status.substring(1);
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'created':
      case 'requested':
        return const Color(0xFFFFA500); // Orange
      case 'accepted':
        return const Color(0xFF5ED5F3); // Cyan
      case 'picked':
        return const Color(0xFF6B7FEC); // Blue
      case 'completed':
      case 'paid':
        return const Color(0xFF4CAF50); // Green
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCancelRideDialog(
      BuildContext context,
      String bookingId,
      double cancellationFee,
      double totalFare,
      VoidCallback onConfirm,
      ) {
    final refundAmount = totalFare * (100 - cancellationFee) / 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.w),
                    ),
                    child: Center(
                      child: CustomText(
                        text: '?',
                        fontsize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Title
                CustomText(
                  text: 'Cancel Ride?',
                  fontsize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                SizedBox(height: 12.h),

                // Booking ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Booking ID: ',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                    CustomText(
                      text: bookingId,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary3rdColor,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Cancellation Fee Info
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Cancellation Fee:',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          CustomText(
                            text: '${cancellationFee.toStringAsFixed(0)}%',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Refund Amount:',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          CustomText(
                            text: '€${refundAmount.toStringAsFixed(2)}',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Description
                CustomText(
                  text:
                  'Cancellation charges: >24hrs: 0%, 2-24hrs: 50%, <2hrs: 100% of ride amount.',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  textAlign: TextAlign.center,
                  maxline: 3,
                ),
                SizedBox(height: 24.h),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: CustomText(
                      text: 'Confirm Cancellation',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Keep Ride Button
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 56.h),
                    side: BorderSide(color: AppColors.primary3rdColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  child: CustomText(
                    text: 'Keep My Ride',
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary3rdColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Used for formatting the dateTime
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_icons.dart';

import '../../../controllers/passenger_ride_controller.dart';
import '../../widgets/widgets.dart';
// Import your controller and model
// import 'package:split_ride/controllers/passenger_my_rides_controller.dart'; 
// import 'package:split_ride/models/passenger_ongoing_rides.dart';

class MyRiedsDriverScreen extends StatelessWidget {
  const MyRiedsDriverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(PassengerMyRidesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          // ================= TAB BUTTONS =================
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34.r),
                color: Colors.grey[200],
              ),
              child: Obx(() => Row(
                children: [
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
                          color: controller.isUpcoming.value ? null : Colors.transparent,
                          borderRadius: BorderRadius.circular(34.r),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Scheduled Rides',
                            color: controller.isUpcoming.value ? Colors.white : AppColors.primary3rdColor,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
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
                          color: !controller.isUpcoming.value ? null : Colors.transparent,
                          borderRadius: BorderRadius.circular(25.w),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Completed',
                            color: !controller.isUpcoming.value ? Colors.white : AppColors.primary3rdColor,
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

          // ================= RIDES LIST =================
          Expanded(
            child: Obx(() {
              // 1. Loading State
              if (controller.isCurrentTabLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2. Empty State
              if (controller.currentRides.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No rides found.',
                    color: Colors.grey,
                    fontsize: 16.sp,
                  ),
                );
              }

              // 3. Data State
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.currentRides.length,
                itemBuilder: (context, index) {
                  final ride = controller.currentRides[index];

                  // Format the DateTime for the UI
                  String formattedDate = 'TBD';
                  if (ride.dateTime != null) {
                    formattedDate = DateFormat('dd MMMM yyyy, hh:mm a').format(ride.dateTime!.toLocal());
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < controller.currentRides.length - 1 ? 16.h : 0,
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.trackDriversScreen, arguments: {'rideId': ride.jobId}, preventDuplicates: false);
                      },
                      child: RideCards(
                        pickupLocation: ride.fromAddress ?? 'Unknown Location',
                        dropLocation: ride.toAddress ?? 'Unknown Location',
                        bookingId: ride.jobId ?? 'N/A',
                        dateTime: formattedDate,
                        driver: ride.userName ?? 'Unknown',
                        carSeats: ride.seat?.toString() ?? 'N/A',
                        paymentStatus: ride.status?.capitalizeFirst ?? 'Pending',
                        showCancel: controller.isUpcoming.value,
                        isPastRide: !controller.isUpcoming.value,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// RIDE CARDS WIDGET
// =============================================================================
class RideCards extends StatelessWidget {
  final String pickupLocation;
  final String dropLocation;
  final String bookingId;
  final String dateTime;
  final String driver;
  final String carSeats;
  final String paymentStatus;
  final bool showCancel;
  final bool isPastRide;

  const RideCards({
    Key? key,
    required this.pickupLocation,
    required this.dropLocation,
    required this.bookingId,
    required this.dateTime,
    required this.driver,
    required this.carSeats,
    required this.paymentStatus,
    required this.showCancel,
    this.isPastRide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      Row(
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: const Color(0xFF5ED5F3),
                            size: 20.w,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CustomText(
                              text: pickupLocation,
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w500,
                              maxline: 2,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: const Color(0xFF9C8FFF),
                            size: 20.w,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CustomText(
                              text: dropLocation,
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w500,
                              maxline: 2,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildInfoRow('Booking ID', bookingId),
                SizedBox(height: 4.h),
                Divider(color: Colors.grey[200]),
                SizedBox(height: 8.h),
                _buildInfoRow('Date & Time', dateTime),
                SizedBox(height: 4.h),
                Divider(color: Colors.grey[200]),
                SizedBox(height: 8.h),
                _buildInfoRow('Driver', driver),
                SizedBox(height: 4.h),
                Divider(color: Colors.grey[200]),
                SizedBox(height: 8.h),
                _buildInfoRow('Car seats', carSeats),
                SizedBox(height: 4.h),
                Divider(color: Colors.grey[200]),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Status',
                      color: Colors.grey,
                      fontsize: 14.sp,
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF45C4D9),
                          Color(0xFF6B7FEC),
                          Color(0xFFB565D8),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: CustomText(
                        text: paymentStatus,
                        color: const Color(0xFF5ED5F3),
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (showCancel) ...[
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
                          showCancelRideDialog(context, bookingId);
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          color: Colors.grey,
          fontsize: 14.sp,
        ),
        CustomText(
          text: value,
          color: Colors.black,
          fontsize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  // ===========================================================================
  // CANCEL RIDE DIALOG
  // ===========================================================================
  void showCancelRideDialog(BuildContext context, String bookingId) {
    showDialog<bool>(
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
                        fontsize: 32,
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
                  fontsize: 24,
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
                      fontsize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                    CustomText(
                      text: bookingId,
                      fontsize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary3rdColor,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Description
                CustomText(
                  text: 'If you cancel this ride, the booking within 24 hours before you start your ride will cost you 20% of the ride amount. The cancellation charges may vary for different ride.',
                  fontsize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  textAlign: TextAlign.center,
                  maxline: 5,
                ),
                SizedBox(height: 24.h),

                // Actions
                Obx(() {
                  final controller = Get.find<PassengerMyRidesController>();
                  return SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: controller.isCancelling.value
                          ? null
                          : () async {
                        bool success = await controller.cancelRide(bookingId);
                        if (success && context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                      child: controller.isCancelling.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : CustomText(
                        text: 'Cancel Ride',
                        fontsize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
                SizedBox(height: 12.h),

                // Keep Ride Button (Close dialog)
                TextButton(
                  onPressed: () {
                    if (!Get.find<PassengerMyRidesController>().isCancelling.value) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: CustomText(
                    text: 'Keep Ride',
                    fontsize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
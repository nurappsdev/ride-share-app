import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_icons.dart';
import 'package:split_ride/view/widgets/custom_loading.dart';
import '../../../../controllers/passenger_home_controller.dart';
import '../../../../controllers/passenger_ride_controller.dart';
import '../../../../model/driver_registration/passenger_models/passenger_ongoing_rides.dart';
import '../../../widgets/widgets.dart';

class PassengerMyRidesScreen extends StatelessWidget {
  const PassengerMyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PassengerMyRidesController controller = Get.put(
      PassengerMyRidesController(),
    );

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
            onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
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
              child: Obx(
                () => Row(
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
                ),
              ),
            ),
          ),

          // Rides List
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isCurrentTabLoading) {
                return Center(child: CustomLoading());
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

                    // Trigger Pagination dynamically
                    if (index == rides.length - 1) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (controller.isUpcoming.value) {
                          controller.loadMoreOngoingRides();
                        } else {
                          controller.loadMoreCompletedRides();
                        }
                      });
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < rides.length - 1 ? 16.h : 0,
                      ),
                      child: RideCard(
                        ride: ride,
                        isPastRide: !controller.isUpcoming.value,
                        // This passes the flag to disable clicks
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
    super.key,
    required this.ride,
    required this.isPastRide,
    required this.onCancel,
    required this.canCancel,
    required this.cancellationFee,
  });

  // Shorten the MongoDB ID to look like the design (e.g., SR1284E6)
  String _shortenId(String? id) {
    if (id == null || id.length < 8) return 'N/A';
    return id.substring(id.length - 8).toUpperCase();
  }

  String _getFormattedDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _getFormattedTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('h:mm a').format(date);
  }

  // Adjusted to match the design's "16 July 2023, 10:30 PM" format
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd MMM yyyy, h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isPastRide
          ? null
          : () {
              final currentStatus = ride.status?.toLowerCase() ?? '';

              if (currentStatus == 'paid') {
                _showWaitingForDriverPopup(context);
              } else if (currentStatus == 'accepted' ||
                  currentStatus == 'picked' ||
                  currentStatus == 'completed') {
                Get.toNamed(
                  AppRoutes.trackDriversScreen,
                  preventDuplicates: false,
                  arguments: {'rideId': ride.jobId},
                );
              } else {
                _showPaymentPopup(context, ride);
              }
            },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            // ==========================================
            // TOP SECTION - Map and Locations
            // ==========================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Map Image Placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SvgPicture.asset(
                    AppIcons.mapIcon,
                    width: 76.w,
                    height: 76.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.w),

                // Locations Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.play_arrow_outlined, color: const Color(0xFF5C58EB), size: 22.w),
                          SvgPicture.asset('assets/icons/startLocation.svg'),

                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              ride.fromAddress ?? 'Unknown Location',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // Connecting dotted/solid line
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.w,
                          top: 4.h,
                          bottom: 4.h,
                        ),
                        child: DashedLineVertical(
                          height: 24.h,
                          color: Colors.grey[400] ?? Colors.grey,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.location_on_outlined, color: const Color(0xFF5C58EB), size: 22.w),
                          SvgPicture.asset('assets/icons/stopLocation.svg'),

                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              ride.toAddress ?? 'Unknown Destination',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // ==========================================
            // MIDDLE SECTION - White Details Card
            // ==========================================
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Booking ID', _shortenId(ride.jobId)),
                  _buildDivider(),
                  _buildInfoRow('Date & Time', _formatDateTime(ride.dateTime)),
                  _buildDivider(),
                  _buildInfoRow(
                    'Driver',
                    (ride.status == 'created' || ride.status == 'paid')
                        ? 'Not Assigned'
                        : (ride.userName ?? 'Unknown'),
                  ),
                  _buildDivider(),
                  _buildInfoRow('Car seats', '${ride.seat ?? 0}'),
                  _buildDivider(),

                  // Payment Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Status',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatStatus(ride.status),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(ride.status),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==========================================
            // BOTTOM SECTION - Cancel Option
            // ==========================================
            if (!isPastRide &&
                ride.status != 'completed' &&
                ride.status != 'cancelled') ...[
              SizedBox(height: 16.h),
              Row(
                children: [
                  // Icon(Icons.directions_car, color: Colors.grey[700], size: 24.w), // Alternatively use a car png asset here if you have one
                  SvgPicture.asset('assets/icons/Car.svg'),
                  SizedBox(width: 12.w),
                  Text(
                    'Cancel your ride?',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
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
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HELPER WIDGETS
  // ===========================================================================

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(color: Colors.grey[200], height: 1, thickness: 1),
    );
  }

  // ===========================================================================
  // STATUS MAPPING HELPERS
  // ===========================================================================
  String _formatStatus(String? status) {
    if (status == null) return 'Unknown';
    switch (status.toLowerCase()) {
      case 'created':
        return 'Pending';
      case 'paid':
        return 'Paid';
      case 'accepted':
        return 'Accepted';
      case 'picked':
        return 'Picked Up';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.substring(0, 1).toUpperCase() + status.substring(1);
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'created':
        return const Color(0xFFFFA500);
      case 'paid':
        return const Color(0xFFB565D8);
      case 'accepted':
      case 'picked':
        return const Color(0xFF5ED5F3);
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ===========================================================================
  // 1. PAYMENT POPUP DIALOG
  // ===========================================================================
  void _showPaymentPopup(
    BuildContext context,
    PassengerOngoingRidesModel ride,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close, color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8FB),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            // Icon(Icons.play_arrow_outlined, size: 20.sp, color: Colors.grey[700]),
                            // Container(width: 1.w, height: 24.h, color: Colors.grey[400]),
                            // Icon(Icons.location_on_outlined, size: 20.sp, color: Colors.grey[700]),
                            SvgPicture.asset('assets/icons/startLocation.svg'),
                            // Container(width: 1.w, height: 24.h, color: Colors.grey[400]),
                            DashedLineVertical(
                              height: 24.h,
                              color: Colors.grey[400] ?? Colors.grey,
                            ),
                            SvgPicture.asset('assets/icons/stopLocation.svg'),
                          ],
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ride.fromAddress ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                ride.toAddress ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildPaymentRow(
                    'Ride Price',
                    '€${ride.fare?.toStringAsFixed(2) ?? '0.00'}',
                    true,
                  ),
                  SizedBox(height: 12.h),
                  _buildPaymentRow(
                    'Charge',
                    '€${ride.charge?.toStringAsFixed(2) ?? '0.00'}',
                    true,
                  ),
                  SizedBox(height: 12.h),
                  _buildPaymentRow(
                    'Pickup time',
                    _getFormattedTime(ride.dateTime),
                    false,
                  ),
                  SizedBox(height: 12.h),
                  _buildPaymentRow(
                    'Pickup Date',
                    _getFormattedDate(ride.dateTime),
                    false,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '€${ride.totalFare?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8FB),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Disclaimer:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Payment must be made at least 2 hours in advance. Cancellation is allowed up to 1 hour before the scheduled pickup. Within 5-24 hours get 50% and you will Get driver is on the way or not message.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.find<PassengerHomeController>().makePayment(
                          payId: ride.jobId!,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF45C4D9), Color(0xFFB565D8)],
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Center(
                          child: Text(
                            'Pay Now',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentRow(String label, String value, bool isValueBlue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isValueBlue ? const Color(0xFF3B82F6) : Colors.black87,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 2. WAITING FOR DRIVER POPUP DIALOG
  // ===========================================================================
  void _showWaitingForDriverPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
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
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3E8FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.hourglass_empty_rounded,
                    size: 40.sp,
                    color: const Color(0xFFB565D8),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Waiting for Driver',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Your payment was successful! Please wait while a driver accepts your ride request.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFB565D8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      'Okay',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB565D8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // 3. CANCEL RIDE POPUP DIALOG
  // ===========================================================================
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
                      child: Text(
                        '?',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Cancel Ride?',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Booking ID: ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      bookingId,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary3rdColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
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
                          Text(
                            'Cancellation Fee:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${cancellationFee.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Refund Amount:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '€${refundAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Cancellation charges: >24hrs: 0%, 2-24hrs: 50%, <2hrs: 100% of ride amount.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                SizedBox(height: 24.h),
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
                    child: Text(
                      'Confirm Cancellation',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 56.h),
                    side: BorderSide(
                      color: AppColors.primary3rdColor,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  child: Text(
                    'Keep My Ride',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary3rdColor,
                    ),
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

class DashedLineVertical extends StatelessWidget {
  final double height;
  final Color color;
  final double dashHeight;
  final double dashWidth;

  const DashedLineVertical({
    super.key,
    this.height = 24,
    this.color = Colors.grey,
    this.dashHeight = 3.0,
    this.dashWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxHeight = constraints.constrainHeight();
          final dashCount = (boxHeight / (2 * dashHeight)).floor();

          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.vertical,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(decoration: BoxDecoration(color: color)),
              );
            }),
          );
        },
      ),
    );
  }
}

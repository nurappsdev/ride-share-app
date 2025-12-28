import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_icons.dart';

import '../../../widgets/widgets.dart';


class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({Key? key}) : super(key: key);

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  bool isUpcoming = true;

  List<Map<String, dynamic>> upcomingRides = [
    {
      'pickupLocation': '1901 Thornridge Cir. Shiloh',
      'dropLocation': '4140 Parker Rd. Allentown',
      'bookingId': 'SR12B4E6',
      'dateTime': '16 July 2023, 10:30 PM',
      'driver': 'Jane Cooper',
      'carSeats': '4',
      'paymentStatus': 'Advance Paid',
      'showCancel': true,
    },
    {
      'pickupLocation': '1901 Thornridge Cir. Shiloh',
      'dropLocation': '4140 Parker Rd. Allentown',
      'bookingId': 'SR12B4E7',
      'dateTime': '18 July 2023, 2:00 PM',
      'driver': 'John Doe',
      'carSeats': '3',
      'paymentStatus': 'Pending',
      'showCancel': false,
    },
    {
      'pickupLocation': '1901 Thornridge Cir. Shiloh',
      'dropLocation': '4140 Parker Rd. Allentown',
      'bookingId': 'SR12B4E7',
      'dateTime': '18 July 2023, 2:00 PM',
      'driver': 'John Doe',
      'carSeats': '3',
      'paymentStatus': 'Pending',
      'showCancel': false,
    },
  ];

  List<Map<String, dynamic>> pastRides = [
    {
      'pickupLocation': '123 Main St, New York',
      'dropLocation': '456 Park Ave, New York',
      'bookingId': 'SR12B4E8',
      'dateTime': '10 June 2023, 9:15 AM',
      'driver': 'Robert Smith',
      'carSeats': '4',
      'paymentStatus': 'Completed',
      'showCancel': false,
    },
    {
      'pickupLocation': '789 Broadway, San Francisco',
      'dropLocation': '321 Market St, San Francisco',
      'bookingId': 'SR12B4E9',
      'dateTime': '5 May 2023, 3:45 PM',
      'driver': 'Emily Johnson',
      'carSeats': '2',
      'paymentStatus': 'Completed',
      'showCancel': false,
    },
  ];

  @override
  Widget build(BuildContext context) {


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
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(34.r),color: Colors.grey[200]),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isUpcoming = true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          gradient: isUpcoming
                              ? const LinearGradient(
                            colors: [ Color(0xFF45C4D9),
                              Color(0xFF6B7FEC),
                              Color(0xFFB565D8),],
                          )
                              : null,
                          color: isUpcoming ? null : Colors.transparent,
                          borderRadius: BorderRadius.circular(34.r),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Upcoming Rides',
                            color: isUpcoming ? Colors.white : AppColors.primary3rdColor,
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
                      onTap: () => setState(() => isUpcoming = false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          gradient: !isUpcoming
                              ? const LinearGradient(
                            colors: [ Color(0xFF45C4D9),
                              Color(0xFF6B7FEC),
                              Color(0xFFB565D8),],
                          )
                              : null,
                          color: !isUpcoming ? null : Colors.transparent,
                          borderRadius: BorderRadius.circular(25.w),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Past Rides',
                            color: !isUpcoming ? Colors.white : AppColors.primary3rdColor,
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: isUpcoming ? upcomingRides.length : pastRides.length,
              itemBuilder: (context, index) {
                final ride = isUpcoming ? upcomingRides[index] : pastRides[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < (isUpcoming ? upcomingRides.length : pastRides.length) - 1 ? 16.h : 0,
                  ),
                  child: InkWell(
                    onTap: (){
                      Get.toNamed(AppRoutes.trackDriversScreen,preventDuplicates: false);
                    },
                    child: RideCard(
                      pickupLocation: ride['pickupLocation'],
                      dropLocation: ride['dropLocation'],
                      bookingId: ride['bookingId'],
                      dateTime: ride['dateTime'],
                      driver: ride['driver'],
                      carSeats: ride['carSeats'],
                      paymentStatus: ride['paymentStatus'],
                      showCancel: ride['showCancel'],
                      isPastRide: !isUpcoming, // Show "Download invoice" only for past rides
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}

class RideCard extends StatelessWidget {
  final String pickupLocation;
  final String dropLocation;
  final String bookingId;
  final String dateTime;
  final String driver;
  final String carSeats;
  final String paymentStatus;
  final bool showCancel;
  final bool isPastRide;

  const RideCard({
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
                          CustomText(
                            text: pickupLocation,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
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
                          CustomText(
                            text: dropLocation,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      if (isPastRide)
                        Row(
                          children: [
                            Icon(
                              Icons.receipt,
                              color: AppColors.whiteColor,
                              size: 20.w,
                            ),
                            SizedBox(width: 2.w),
                            CustomText(
                              text: 'Download invoice',
                              fontsize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary3rdColor,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
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
                Divider(color: Colors.grey[200],),
                SizedBox(height: 8.h),
                _buildInfoRow('Date & Time', dateTime),
                SizedBox(height: 4.h),
                Divider(color: Colors.grey[200],),
                SizedBox(height: 8.h),
                _buildInfoRow('Driver', driver),
                SizedBox(height: 4.h),
                Divider(color: Colors.grey[200],),
                SizedBox(height: 8.h),
                _buildInfoRow('Car seats', carSeats),
                SizedBox(height: 4.h),
                Divider(color: Colors.grey[200],),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Payment Status',
                      color: Colors.grey,
                      fontsize: 14.sp,
                    ),
                    CustomText(
                      text: paymentStatus,
                      color: const Color(0xFF5ED5F3),
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
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
                          showCancelRideDialog(context,bookingId);

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
  // Function to show the cancel ride dialog with ScreenUtil
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

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      // Handle cancel ride logic here
                      print('Ride cancelled');
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
                      text: 'Cancel',
                      fontsize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

              ],
            ),
          ),
        );
      },
    );
  }
  
}

class DottedLinePainters extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashHeight = 3.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
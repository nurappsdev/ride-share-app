




import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_image.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';
import '../screens.dart';
import 'passenger_details_screen.dart';

class DriverAvailableRideScreen extends StatefulWidget {
  const DriverAvailableRideScreen({Key? key}) : super(key: key);

  @override
  State<DriverAvailableRideScreen> createState() => _DriverAvailableRideScreenState();
}

class _DriverAvailableRideScreenState extends State<DriverAvailableRideScreen> {
  final List<RideBooking> bookings = [
    RideBooking(
      driverName: 'Bernard Alvarado',
      driverImage: 'https://i.pravatar.cc/150?img=12',
      rating: 4.8,
      reviewCount: 293,
      bookingId: 'SR1284E6',
      pickupLocation: 'Parateek Wisteria Sector 77, Noid...',
      dropLocation: 'HCL Technologies Sector 126, Rai...',
      distance: 8.7,
      pickupTime: '16:28',
      fare: 15.00,
    ),
    RideBooking(
      driverName: 'Bernard Alvarado',
      driverImage: 'https://i.pravatar.cc/150?img=12',
      rating: 4.8,
      reviewCount: 293,
      bookingId: 'SR1284E7',
      pickupLocation: 'Parateek Wisteria Sector 77, Noid...',
      dropLocation: 'HCL Technologies Sector 126, Rai...',
      distance: 8.7,
      pickupTime: '17:30',
      fare: 18.00,
    ),
    RideBooking(
      driverName: 'Bernard Alvarado',
      driverImage: 'https://i.pravatar.cc/150?img=12',
      rating: 4.8,
      reviewCount: 293,
      bookingId: 'SR1284E8',
      pickupLocation: 'Parateek Wisteria Sector 77, Noid...',
      dropLocation: 'HCL Technologies Sector 126, Rai...',
      distance: 8.7,
      pickupTime: '18:45',
      fare: 20.00,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background (Placeholder)
          Container(
            height: 400.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              image: DecorationImage(
                image: AssetImage(
                    "${AppImages.mapDriverImg}"
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu Button
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.drawerScreen);
                      },
                      child: Container(
                        width: 44.w,
                        height: 44.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF45C4D9),
                              Color(0xFF6B7FEC),
                              Color(0xFFB565D8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6B7FEC).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.menu_sharp,
                          color: Colors.white,
                          size: 24.r,
                        ),
                      ),
                    ),

                    // Title
                    Text(
                      'Available Rides',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Outfit",
                        color: Color(0xFF2D3748),
                      ),
                    ),

                    // Notification Button
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(34.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Color(0xFF2D3748),
                        size: 24.r,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            right: 20.w,
            top: MediaQuery.of(context).size.height * 0.28,
            child: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF45C4D9),
                    Color(0xFF6B7FEC),
                    Color(0xFF725bf0),
                    Color(0xFFB565D8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B7FEC).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.my_location,
                color: Colors.white,
                size: 24.r,
              ),
            ),
          ),

          // Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                       onTap: (){
                         showPassengerDetails(context);
                       },
                        child: RideBookingCard(booking: bookings[index]));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


class RideBooking {
  final String driverName;
  final String driverImage;
  final double rating;
  final int reviewCount;
  final String bookingId;
  final String pickupLocation;
  final String dropLocation;
  final double distance;
  final String pickupTime;
  final double fare;

  RideBooking({
    required this.driverName,
    required this.driverImage,
    required this.rating,
    required this.reviewCount,
    required this.bookingId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.distance,
    required this.pickupTime,
    required this.fare,
  });
}

class RideBookingCard extends StatelessWidget {
  final RideBooking booking;

  const RideBookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          // Driver Info Section
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Driver Avatar
                CircleAvatar(
                  radius: 24.r,
                  backgroundImage: NetworkImage(booking.driverImage),
                ),
                SizedBox(width: 12.w),
                // Driver Name and Rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.driverName,
                        style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                           Icon(
                            Icons.star,
                            color: Color(0xFFFFA726),
                            size: 16.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${booking.rating}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            ' (${booking.reviewCount})',
                            style: TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 14.sp,
                              color: Colors.grey,
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

          // Booking ID Section
          Padding(
            padding:  EdgeInsets.all(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration:  BoxDecoration(
                color: Color(0xFFF3E8FF),
                borderRadius: BorderRadius.all(Radius.circular(12.r))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking ID:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    booking.bookingId,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Location Section
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Distance
                Column(
                  children: [
                    Text(
                      '${booking.distance}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Km',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: "Outfit",
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Location dots and lines



                Column(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00BCD4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    DashedLine(
                      height: 28.h,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 4.h),
                    Icon(
                      Icons.location_on,
                      size: 12.sp,
                      color: Color(0xFFe85f4c),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Locations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.pickupLocation,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          fontFamily: "Outfit",
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        booking.dropLocation,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          fontFamily: "Outfit",
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

          // Time and Price Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pick up time
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: Color(0xFF7C3AED),
                        size: 18.r,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Pick up @ ${booking.pickupTime}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: "Outfit",
                        ),
                      ),
                    ],
                  ),
                ),
                // Price
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4FF),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.currency_exchange_rounded,
                        color: Color(0xFF2196F3),
                        size: 18.r,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '€ ${booking.fare.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Decline Button
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8D5F5),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child:  Text(
                        'Decline',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Outfit",
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Accept Button
                Expanded(
                  child:CustomButtonCommon(title: 'Accept', onpress: (){
                    _showVerificationDialog(context);
                  },useGradient: true,)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showVerificationDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Verification",
    barrierColor: Colors.black.withOpacity(0.25), // soft dim
    transitionDuration: const Duration(milliseconds: 10),
    pageBuilder: (_, __, ___) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
        ),
        child: Center(
          child: _verificationCard(context),
        ),
      );
    },
  );
}

Widget _verificationCard(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 24.w),
    padding: EdgeInsets.all(32.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(32.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 30,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Gradient Success Icon
        Container(
          width: 100.w,
          height: 100.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xFF45C4D9),
                Color(0xFF6B7FEC),
                Color(0xFF5c58eb),
                Color(0xFFB565D8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            Icons.check,
            size: 60.sp,
            color: Colors.white,
          ),
        ),

        SizedBox(height: 24.h),

        Text(
          "Ride Accepted",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.sp,
            fontFamily: "Outfit",
            fontWeight: FontWeight.w700,

            decoration: TextDecoration.none,
            color: const Color(0xFF2D3748),
          ),
        ),

        SizedBox(height: 12.h),

        Text(
          "Reach the location by 10:25 PM to pick up the passenger",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: "Outfit",
            color: Colors.grey[600],
            height: 1.5,

            decoration: TextDecoration.none,
          ),
        ),

        SizedBox(height: 28.h),

        /// Button
        CustomButtonCommon(title:  "View The Map", onpress: (){Get.back();},useGradient: true,),
      ],
    ),
  );
}

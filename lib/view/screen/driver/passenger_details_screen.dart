

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';

import '../../../controllers/payment_controller.dart';
import '../screens.dart';

void showPassengerDetails(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Passenger Information',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D2D2D),
                      fontFamily: 'Outfit',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFF1F1F1)),
              // Driver Profile Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Column(
                  children: [
                    // Driver Avatar
                    CircleAvatar(
                      radius: 40.r,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=12',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Driver Name and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Bernard Alvarado',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Outfit',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.star,
                          color: const Color(0xFFFFA726),
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '4.9',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Outfit',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Details Section
              Column(
                children: [
                  // Ride Price


                  Container(
                    padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.r)),  color: Color(0xffe6f3ff), ),

                    child: Column(
                      children: [
                        _buildDetailRow(
                          'Ride Price',
                          '€60',
                          valueColor: const Color(0xFF7C3AED),
                        ),
                        SizedBox(height: 4.h),
                        Divider(color: Colors.white,),
                        SizedBox(height: 4.h),

                        // Booking ID
                        _buildDetailRow(
                          'Booking ID',
                          'SR1284E6',
                        ),
                        SizedBox(height: 4.h),
                        Divider(color: Colors.white,),
                        SizedBox(height: 4.h),

                        // Passenger
                        _buildPassengerRow(
                          'Passenger',
                          'Devon Lane',
                          '+1 234 567 8901',
                          'https://i.pravatar.cc/150?img=33',
                        ),
                        SizedBox(height: 4.h),
                        Divider(color: Colors.white,),
                        SizedBox(height: 4.h),

                        // Pickup
                        _buildDetailRow(
                          'Pickup',
                          'Parateek Wisteria\nSector 77, Niod...',
                        ),
                        SizedBox(height: 4.h),
                        Divider(color: Colors.white,),
                        SizedBox(height: 4.h),

                        // Drop Off
                        _buildDetailRow(
                          'Drop Off',
                          'HCL Technologies\nSector 126, Rai...',
                        ),
                        SizedBox(height: 4.h),
                        Divider(color: Colors.white,),
                        SizedBox(height: 4.h),

                        // Luggage
                        _buildDetailRow(
                          'Luggage',
                          'Suitcase',
                          subtitle: 'Luggage Description by user',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Passenger Note Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Passenger Note:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Outfit',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Please enter with your change or transfer to the account on the headrest.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Outfit',
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Accept Ride Button
                  CustomButtonCommon(title:   'Accept Ride', onpress: (){
                    _showVerificationDialog(context);
                  }, useGradient: true,),
                  SizedBox(height: 24.h),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );


}
Widget _buildDetailRow(
    String label,
    String value, {
      String? subtitle,
      Color? valueColor,
    }) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 2,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Outfit',
            color: Colors.black87,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Outfit',
                color: valueColor ?? Colors.black,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Outfit',
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

Widget _buildPassengerRow(
    String label,
    String name,
    String phone,
    String avatarUrl,
    ) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        flex: 2,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Outfit',
            color: Colors.black87,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Outfit',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Outfit',
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            CircleAvatar(
              radius: 20.r,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ],
        ),
      ),
    ],
  );
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


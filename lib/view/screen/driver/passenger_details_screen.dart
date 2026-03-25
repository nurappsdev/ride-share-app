

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';

import '../../../model/provider_requested_ride_model.dart';

String _formatTime(String dateTimeString) {
  try {
    DateTime dt = DateTime.parse(dateTimeString).toLocal();
    return DateFormat('hh:mm a').format(dt);
  } catch (e) {
    return '--:--';
  }
}

// Format Image properly
String _getImageUrl(String? path) {
  if (path == null || path.isEmpty) return 'https://i.pravatar.cc/150?img=12';
  if (path.startsWith('http')) return path;

  // Build the media URL from the Base URL
  String baseDomain = AppUrl.baseUrl.replaceAll('/api/v1', '');
  return "$baseDomain/uploads/$path"; // Adjust '/uploads/' if your server uses a different media path
}

void showPassengerDetails(BuildContext context, ProviderRequestedRideModel ride) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SafeArea(
        child: Container(
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
                          (_getImageUrl(ride.userProfile)),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Driver Name and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ride.userName ?? 'Unknown Passenger',
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
                            ride.avgRating?.toStringAsFixed(1) ?? '0.0',
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
                            '€ ${ride.fare?.toStringAsFixed(2) ?? '0.00'}',
                            valueColor: const Color(0xFF7C3AED),
                          ),
                          SizedBox(height: 4.h),
                          Divider(color: Colors.white,),
                          SizedBox(height: 4.h),

                          // Booking ID
                          _buildDetailRow(
                            'Booking ID',
                            ride.jobId != null && ride.jobId!.length > 8
                                ? ride.jobId!.substring(ride.jobId!.length - 8).toUpperCase()
                                : ride.jobId ?? 'N/A',
                          ),
                          SizedBox(height: 4.h),
                          Divider(color: Colors.white,),
                          SizedBox(height: 4.h),

                          // Passenger
                          _buildPassengerRow(
                            'Passenger',
                            ride.userName ?? 'Unknown Passenger',
                            ride.userPhone ?? 'N/A',
                            _getImageUrl(ride.userProfile),
                          ),
                          SizedBox(height: 4.h),
                          Divider(color: Colors.white,),
                          SizedBox(height: 4.h),
        
                          // Pickup
                          _buildDetailRow(
                            'Pickup',
                            ride.fromAddress ?? 'Unknown Location',
                          ),
                          SizedBox(height: 4.h),
                          Divider(color: Colors.white,),
                          SizedBox(height: 4.h),

                          // Drop Off
                          _buildDetailRow(
                            'Drop Off',
                            ride.toAddress ?? 'Unknown Location',
                          ),
                          SizedBox(height: 4.h),
                          Divider(color: Colors.white,),
                          SizedBox(height: 4.h),
        
                          // Luggage
                          _buildDetailRow(
                            'Luggage',
                            ride.luggages != null && ride.luggages!.isNotEmpty
                                ? ride.luggages!.join(', ')
                                : 'N/A',
                            subtitle: ride.luggages != null && ride.luggages!.isNotEmpty
                                ? '${ride.luggages!.length} item(s)'
                                : 'No luggage information',
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
                            'No passenger note available.',
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
                      Navigator.pop(context);
                      _showVerificationDialog(context, ride);
                    }, useGradient: true,),
                    SizedBox(height: 24.h),
                  ],
                ),
              ],
            ),
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


void _showVerificationDialog(BuildContext context, ProviderRequestedRideModel ride) {
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
          child: _verificationCard(context, ride),
        ),
      );
    },
  );
}

Widget _verificationCard(BuildContext context, ProviderRequestedRideModel ride) {
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
          "Reach the location by ${ride.dateTime != null ? _formatTime(ride.dateTime!) : 'time'} to pick up the passenger",
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
        CustomButtonCommon(title:  "View The Map", onpress: (){
          Get.toNamed(AppRoutes.trackDriversScreen, arguments: {'rideId': ride.jobId}, preventDuplicates: false);

          // Get.offAllNamed(
          //   AppRoutes.driverTrackRidesScreen,
          //   arguments: ride.jobId ?? '',
          // );
        },useGradient: true,),
      ],
    ),
  );
}


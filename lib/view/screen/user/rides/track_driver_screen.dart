import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/ride_controllers/ride_details_controller.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/utils.dart';
import '../../../widgets/address_card.dart';
import '../../../widgets/widgets.dart';

class TrackDriverScreen extends StatelessWidget {
  const TrackDriverScreen({super.key});

  String _estimateTime(double? distanceInKm) {
    if (distanceInKm == null || distanceInKm <= 0) return '0 Mins';
    double timeInHours = distanceInKm / 30.0;
    int timeInMinutes = (timeInHours * 60).round();
    if (timeInMinutes < 1) timeInMinutes = 1;
    return '$timeInMinutes Mins';
  }

  String _estimateArrivalTime(double? distanceInKm) {
    if (distanceInKm == null || distanceInKm <= 0) return '--:--';
    double timeInHours = distanceInKm / 30.0;
    int timeInMinutes = (timeInHours * 60).round();
    DateTime arrivalTime = DateTime.now().add(Duration(minutes: timeInMinutes));
    return DateFormat('hh:mm a').format(arrivalTime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<RideDetailsController>(
          builder: (controller) {
            if (controller.isLoadingRideDetails) {
              return const Center(child: CircularProgressIndicator());
            }

            final rideData = controller.rideDetails;
            final isProvider = controller.userRole == 'provider';

            // Getting the OTHER USER'S data
            final otherUserName = rideData?.otherUser?.name ?? 'Unknown User';
            final otherUserPhone = rideData?.otherUser?.phone ?? '--';

            // Getting Car Data
            final carName = rideData?.carModel?.name ?? 'Standard Car';
            final distance = rideData?.distance;

            return Stack(
              children: [
                // Map Background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey[200]!,
                        Colors.grey[100]!,
                        Colors.grey[200]!,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 400.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          image: DecorationImage(
                            image: AssetImage("${AppImages.trackImg}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Top App Bar Area
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.r,
                                  ),
                                ],
                              ),
                              child: Icon(Icons.close, size: 20.sp),
                            ),
                          ),
                          // DYNAMIC: App Bar Title
                          Text(
                            isProvider ? 'Track Passenger' : 'Track Driver',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Outfit",
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                          Container(
                            width: 44.w,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8.r,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Color(0xFF2D3748),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Map Control Buttons
                Positioned(
                  top: 300.h,
                  right: 20.w,
                  child: Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF45C4D9),
                          Color(0xFF6B7FEC),
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
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                Positioned(
                  top: 380.h,
                  right: 20.w,
                  child: Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.4),
                          blurRadius: 12.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.navigation,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),

                // Bottom Card Container
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20.r,
                          offset: Offset(0, -5.h),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Arrival Info Card
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    text: 'Arriving in  ',
                                    fontsize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[600],
                                  ),
                                  CustomText(
                                    text: _estimateTime(distance),
                                    fontsize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF7C3AED),
                                  ),
                                ],
                              ),
                              CustomText(
                                text: _estimateArrivalTime(distance),
                                fontsize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // Driver & Vehicle Info
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.driverDetailsScreen,
                                preventDuplicates: false,
                                arguments: {
                                  'driverId': rideData?.otherUser?.id,
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3E8FF),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Other User Details
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 70.w,
                                          height: 70.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF22D3EE),
                                              width: 3.w,
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF45C4D9),
                                                Color(0xFF6B7FEC),
                                                Color(0xFFB565D8),
                                              ],
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: Container(
                                              color: Colors.grey[300],
                                              // TODO: You can use CachedNetworkImage here with otherUser.profileImage later
                                              child: Icon(
                                                Icons.person,
                                                size: 40.sp,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        // SHOWING OTHER USER NAME HERE
                                        CustomText(
                                          text: otherUserName,
                                          fontsize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        SizedBox(height: 4.h),
                                        // SHOWING OTHER USER PHONE HERE
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              size: 11.sp,
                                              color: const Color(0xFF7C3AED),
                                            ),
                                            SizedBox(width: 4.w),
                                            CustomText(
                                              text: otherUserPhone,
                                              fontsize: 11,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Vehicle Info
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.directions_car,
                                          color: Colors.black87,
                                          size: 40.sp,
                                        ),
                                        SizedBox(height: 4.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 3.h,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              6.r,
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF45C4D9),
                                                Color(0xFF6B7FEC),
                                                Color(0xFFB565D8),
                                              ],
                                            ),
                                          ),
                                          // SHOWING CAR NAME HERE INSTEAD OF LEO 2321
                                          child: CustomText(
                                            text: carName,
                                            fontsize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        // SHOWING RIDE TYPE AND SEATS HERE
                                        CustomText(
                                          text:
                                          '${rideData?.seat ?? 0} Seats • ${rideData?.type?.capitalizeFirst ?? "Ride"}',
                                          fontsize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF7C3AED),
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomText(
                                          text: 'View profile',
                                          fontsize: 9,
                                          fontWeight: FontWeight.normal,
                                          color: const Color(0xFF7C3AED),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Location Details
                          AddressCard(
                            fromLocation:
                            rideData?.fromAddress ?? 'Unknown Pickup',
                            toLocation:
                            rideData?.toAddress ?? 'Unknown Dropoff',
                          ),
                          SizedBox(height: 20.h),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF45C4D9),
                                        Color(0xFF6B7FEC),
                                        Color(0xFFB565D8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(28.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF3B82F6,
                                        ).withOpacity(0.3),
                                        blurRadius: 12.r,
                                        offset: Offset(0, 4.h),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigate to Chat Screen
                                      Get.toNamed(
                                        AppRoutes.driverChatingScreen,
                                        arguments: {
                                          'otherUserId': rideData?.otherUser?.id,
                                          'driverName': otherUserName,
                                          'driverEmail': rideData?.otherUser?.email ?? '--',
                                          'driverPhone': otherUserPhone,
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          28.r,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_outline,
                                          size: 20.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.w),
                                        // DYNAMIC: Chat Button Text
                                        CustomText(
                                          text: isProvider
                                              ? 'Chat with your passenger'
                                              : 'Chat with your driver',
                                          fontsize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              GestureDetector(
                                onTap: () async {
                                  if (otherUserPhone.isNotEmpty && otherUserPhone != '--') {
                                    final Uri launchUri = Uri(scheme: 'tel', path: otherUserPhone);
                                    if (await canLaunchUrl(launchUri)) {
                                      await launchUrl(launchUri);
                                    }
                                  }
                                },
                                child: Container(
                                  width: 56.w,
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF45C4D9),
                                        Color(0xFF6B7FEC),
                                        Color(0xFFB565D8),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF3B82F6,
                                        ).withOpacity(0.3),
                                        blurRadius: 12.r,
                                        offset: Offset(0, 4.h),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
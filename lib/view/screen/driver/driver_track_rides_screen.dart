import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/driver_track_rides_controller.dart';

class DriverTrackRidesScreen extends StatefulWidget {
  final String jobId;

  const DriverTrackRidesScreen({Key? key, required this.jobId}) : super(key: key);

  @override
  State<DriverTrackRidesScreen> createState() => _DriverTrackRidesScreenState();
}

class _DriverTrackRidesScreenState extends State<DriverTrackRidesScreen> {
  late DriverTrackRidesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DriverTrackRidesController());
    controller.setJobId(widget.jobId);
  }

  @override
  void dispose() {
    Get.delete<DriverTrackRidesController>();
    super.dispose();
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar('Error', 'Could not launch phone call',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _showChatFeature() {
    Get.snackbar('Coming Soon', 'Chat feature will be available soon',
        snackPosition: SnackPosition.BOTTOM);
  }

  void _startRide() {
    Get.snackbar('Success', 'Ride started!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
    // TODO: Navigate to active ride tracking screen
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              // Google Map (fills entire screen)
              SizedBox.expand(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: controller.fromLat.value != 0.0
                        ? LatLng(controller.fromLat.value, controller.fromLng.value)
                        : const LatLng(37.7749, -122.4194),
                    zoom: 12,
                  ),
                  onMapCreated: (GoogleMapController mapController) {
                    controller.mapController = mapController;
                    controller.isMapCreated.value = true;
                  },
                  markers: controller.markers,
                  polylines: controller.polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
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
                        // Back Button
                        GestureDetector(
                          onTap: () {
                          Get.toNamed(AppRoutes.driverAvailableScreen);
                          },
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

                        // Title
                        Text(
                          'Track Ride',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Outfit",
                            color: Color(0xFF2D3748),
                          ),
                        ),

                        // Notification Button
                        InkWell(
                          onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                          child: Container(
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Location Button
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

              // Navigation Button
              Positioned(
                top: 380.h,
                right: 20.w,
                child: Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF7C3AED).withOpacity(0.4),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Icon(Icons.navigation, color: Colors.white, size: 24.sp),
                ),
              ),

              // Bottom Card
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
                          children: [
                            Text(
                              'Arriving in  ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[600],
                                fontFamily: 'Outfit',
                              ),
                            ),
                            Text(
                              controller.getArrivalTimeString(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7C3AED),
                                fontFamily: 'Outfit',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              controller.formattedTime,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Passenger Info Card
                        InkWell(
                          onTap: () {
                            // Navigate to passenger details if needed
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Profile Avatar
                                CircleAvatar(
                                  radius: 35.r,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: NetworkImage(controller.profileImageUrl),
                                  onBackgroundImageError: (exception, stackTrace) {
                                    debugPrint('Error loading image: $exception');
                                  },
                                ),
                                SizedBox(height: 6.h),

                                // Passenger Name
                                Text(
                                  controller.otherUserName.value,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                                SizedBox(height: 4.h),

                                // Passenger Rating (placeholder)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color(0xFFFFA726),
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '4.9',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Location Details
                        _buildLocationDetails(),
                        SizedBox(height: 20.h),

                        // Action Buttons
                        _buildActionButtons(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLocationDetails() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Pickup Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12.w,
                height: 12.h,
                margin: EdgeInsets.only(top: 4.h),
                decoration: BoxDecoration(
                  color: Color(0xFF00BCD4),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup Location',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontFamily: 'Outfit',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      controller.fromAddress.value,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: 'Outfit',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Dropoff Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: Color(0xFFe85f4c),
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dropoff Location',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontFamily: 'Outfit',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      controller.toAddress.value,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: 'Outfit',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Chat Button with gradient
        Expanded(
          child: InkWell(
            onTap: (){
  Get.toNamed(
    AppRoutes.driverChatingScreen,
    arguments: {
      'otherUserId': controller.otherUserId.value,
      'driverName': controller.otherUserName.value,
      'driverEmail': controller.otherUserEmail.value,
      'driverPhone': controller.otherUserPhone.value,
    },
  );
},
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF45C4D9),
                    Color(0xFF6B7FEC),
                    Color(0xFF5c58eb),
                    Color(0xFFB565D8),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(28.r),
              ),
              child: ElevatedButton(
                onPressed: _showChatFeature,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Outfit",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Start Ride / Picked Up / Review Button
        Expanded(
          child: Obx(() {
            // Only show button if actionState is not null
            if (controller.actionState == null) {
              return const SizedBox.shrink();
            }

            return Container(
              height: 56.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: const Color(0xFF8B5CF6),
                  width: 2.w,
                ),
              ),
              child: ElevatedButton(
                onPressed: _startRide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.actionButtonIcon,
                      color: const Color(0xFF8B5CF6),
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      controller.actionButtonText,
                      style: TextStyle(
                        color: const Color(0xFF8B5CF6),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Outfit",
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        SizedBox(width: 12.w),

        // Phone Button
        Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: IconButton(
            onPressed: () {
              if (controller.otherUserPhone.value.isNotEmpty) {
                _makePhoneCall(controller.otherUserPhone.value);
              } else {
                Get.snackbar('Error', 'No phone number available',
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            icon: Icon(
              Icons.phone_outlined,
              color: const Color(0xFF5B8DEF),
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }
}

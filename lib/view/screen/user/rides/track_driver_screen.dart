import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:split_ride/controllers/track_driver_screen_controller.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/address_card.dart';
import '../../../widgets/widgets.dart';

class TrackDriverScreen extends StatefulWidget {
  const TrackDriverScreen({super.key});

  @override
  State<TrackDriverScreen> createState() => _TrackDriverScreenState();
}

class _TrackDriverScreenState extends State<TrackDriverScreen> {
  late TrackDriverScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TrackDriverScreenController());
  }

  @override
  void dispose() {
    Get.delete<TrackDriverScreenController>();
    super.dispose();
  }

  String _estimateTime(double? distanceInKm) {
    if (distanceInKm == null || distanceInKm <= 0) return '0 Mins';
    double timeInHours = distanceInKm / 30.0;
    int timeInMinutes = (timeInHours * 60).round();
    if (timeInMinutes < 1) timeInMinutes = 1;
    
    // Convert to hours
    int totalHours = (timeInMinutes / 60).round();
    
    // If more than 24 hours, show in days
    if (totalHours >= 24) {
      int days = (totalHours / 24).ceil();
      return '$days ${days == 1 ? "Day" : "Days"}';
    }
    
    // If more than 60 minutes, show in hours
    if (timeInMinutes >= 60) {
      int hours = (timeInMinutes / 60).ceil();
      return '$hours ${hours == 1 ? "Hour" : "Hours"}';
    }
    
    return '$timeInMinutes Mins';
  }

  String formatToLocalTime(String utcTime) {
    DateTime parsedUtc = DateTime.parse(utcTime);
    DateTime localTime = parsedUtc.toLocal();

    return DateFormat('hh:mm a').format(localTime); // 08:30 PM
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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final isProvider = controller.userRole.value == 'provider';
          final otherUserName = controller.otherUserName.value;
          final otherUserEmail = controller.otherUserEmail.value;
          final otherUserPhone = controller.otherUserPhone.value;
          final carName = controller.carModelName.value;
          final distance = controller.distance.value;
          final status = controller.rideStatus.value;
          final driverImage = controller.profileImageUrl;
          final farePrice = controller.fare.value;
          final totalFare = controller.totalFare.value;

print("role role --- ${isProvider}");
          return Stack(
            children: [
              // Google Map
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
                          isProvider ? 'Track Passengers' : 'Track Driver',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Outfit",
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        InkWell(
                          onTap:() => Get.toNamed(AppRoutes.notificationScreen),
                          child: Container(
                            width: 44.w,
                              height: 44.h,
                              padding: EdgeInsets.all(8.r),
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
                              child: SvgPicture.asset(
                                'assets/icons/NotificationIcon.svg',
                              ),
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
                              text: formatToLocalTime(controller.dateTime.value.toString()),
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
                                          // 1. The padding acts as your border width!
                                          padding: EdgeInsets.all(3.w),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            // 2. The gradient goes on the OUTER container
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
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
                                              child: Image.network(driverImage,fit: BoxFit.cover,)
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
                                              Icons.email_outlined,
                                              size: 11.sp,
                                              color: const Color(0xFF7C3AED),
                                            ),
                                            // SvgPicture.asset('assets/icons/phone.svg'),
                                            SizedBox(width: 4.w),
                                            CustomText(
                                              text: otherUserEmail,
                                              fontsize: 12.sp,
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
                                        // Icon(
                                        //   Icons.directions_car,
                                        //   color: Colors.black87,
                                        //   size: 40.sp,
                                        // ),
                                        SvgPicture.asset(
                                          'assets/icons/Car.svg',
                                          height: 35.h,
                                          width: 35.w,
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
                                          '${controller.seats.value} Seats • ${controller.rideType.value.capitalizeFirst ?? "Ride"}',
                                          fontsize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF7C3AED),
                                        ),
                                        SizedBox(height: 4.h),
                                        InkWell(
                                          onTap: (){
                                            Get.toNamed(
                                              AppRoutes.driverDetailsScreen,
                                              preventDuplicates: false,
                                              arguments: {
                                                'driverId': controller.otherUserId.value,
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(1.4.w), // 🔥 border thickness
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF45C4D9),
                                                  Color(0xFF6B7FEC),
                                                  Color(0xFFB565D8),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(30.r),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 6.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF5F3FF), // inner bg
                                                borderRadius: BorderRadius.circular(30.r),
                                              ),
                                              child: CustomText(
                                                text: 'View driver profile',
                                                fontsize: 9,
                                                fontWeight: FontWeight.normal,
                                                color: const Color(0xFF7C3AED),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6.h,),
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
                                      SizedBox(height: 6.h,),
                                      !isProvider && status == "picked" ?  GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (_) => FareBreakdownDialog(
                                              controller: controller,
                                              fare: farePrice,
                                              totalFare: totalFare,
                                            ),
                                          );
                                        //  controller.markAsCompleted();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE8F8EE), // 🔥 light green bg
                                            borderRadius: BorderRadius.circular(16.r),
                                            border: Border.all(
                                              color: const Color(0xFF22C55E), // 🔥 green border
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            'Complete',
                                            style: TextStyle(
                                              color: const Color(0xFF16A34A), // 🔥 text green
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Outfit",
                                            ),
                                          ),
                                        ),
                                      ):SizedBox.shrink()
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
                            controller.fromAddress.value,
                            toLocation:
                            controller.toAddress.value,
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
                                          'otherUserId': controller.otherUserId.value,
                                          'driverName': otherUserName,
                                          'driverEmail': controller.otherUserEmail.value,
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
                                          Icons.message_outlined,
                                          size: 20.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.w),
                                        // DYNAMIC: Chat Button Text
                                        CustomText(
                                          text: isProvider
                                              ? 'Chat Passengers'
                                              : 'Chat with your driver',
                                          fontsize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // Picked Up / Review Status
                              isProvider ? Obx(() {
                                final status = controller.rideStatus.value;
                                return GestureDetector(
                                  onTap: () {
                                    if (status == 'picked') {
                                      // Already picked up, do nothing
                                      return;
                                    }
                                    if (status == 'accepted') {
                                      // Call the pickup API
                                      controller.markAsPickedUp();
                                    } else {
                                      // Show Review Bottom Sheet
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => RideReviewBottomSheet(
                                          controller: controller,
                                          otherUserId: controller.otherUserId.value,
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 56.h,
                                    padding: EdgeInsets.all(1.4.w), // 🔥 border thickness
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF45C4D9),
                                          Color(0xFF6B7FEC),
                                          Color(0xFFB565D8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F3FF), // inner bg
                                        borderRadius: BorderRadius.circular(30.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            status == 'picked' || status == 'accepted'
                                                ? Icons.check
                                                : Icons.rate_review,
                                            color: const Color(0xFF8B5CF6),
                                            size: 18.sp,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            status == 'accepted'
                                                ? 'Pick Up'
                                                :status == 'picked' ? "Picked Up" :'Review',
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
                                  ),
                                );
                              }):SizedBox.shrink(),
                              SizedBox(width: 12.w),
                              GestureDetector(
                                onTap: () async {
                                  if (otherUserPhone.isNotEmpty &&
                                      otherUserPhone != '--') {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: otherUserPhone,
                                    );
                                    if (await canLaunchUrl(launchUri)) {
                                      await launchUrl(launchUri);
                                    }
                                  }
                                },
                                child: Container(
                                  width: 56.w,
                                  height: 56.h,
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                    // gradient: const LinearGradient(
                                    //   begin: Alignment.topLeft,
                                    //   end: Alignment.bottomRight,
                                    //   colors: [
                                    //     Color(0xFF45C4D9),
                                    //     Color(0xFF6B7FEC),
                                    //     Color(0xFFB565D8),
                                    //   ],
                                    // ),
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE6F3FF),
                                    /*  boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF3B82F6,
                                        ).withOpacity(0.3),
                                        blurRadius: 12.r,
                                        offset: Offset(0, 4.h),
                                      ),
                                    ],*/
                                  ),
                                  // child: Icon(
                                  //   Icons.phone,
                                  //   color: Colors.white,
                                  //   size: 24.sp,
                                  // ),
                                  child: SvgPicture.asset(
                                    'assets/icons/phone.svg',
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
          }),
        ),
      );
  }
}

class FareBreakdownDialog extends StatelessWidget {
  final TrackDriverScreenController controller;
  final double fare;
  final double totalFare;

  const FareBreakdownDialog({
    super.key,
    required this.controller,
    required this.fare,
    required this.totalFare,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 24.w),
                Text(
                  "Fare Breakdown",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Outfit",
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 20.sp),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            /// Fare Row
            _row("Fare", "\$${fare.toStringAsFixed(2)}"),
            SizedBox(height: 12.h),

            _row("Booking Fee", "\$100.00"),

            SizedBox(height: 16.h),

            /// Divider
            Divider(color: Colors.grey.shade300),

            SizedBox(height: 12.h),

            /// Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Fare",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2563EB),
                  ),
                ),
                Text(
                  "\$${totalFare.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            /// Button
            Obx(() {
              final isLoading = controller.isLoading.value;
              return Container(
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF45C4D9),
                      Color(0xFF6B7FEC),
                      Color(0xFFB565D8),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                          controller.markAsCompleted();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "Mark As Completed",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Reusable row
  Widget _row(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: "Outfit",
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: "Outfit",
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}


class RideReviewBottomSheet extends StatefulWidget {
  final TrackDriverScreenController controller;
  final String otherUserId;

  const RideReviewBottomSheet({
    super.key,
    required this.controller,
    required this.otherUserId,
  });

  @override
  State<RideReviewBottomSheet> createState() => _RideReviewBottomSheetState();
}

class _RideReviewBottomSheetState extends State<RideReviewBottomSheet> {
  int _selectedStars = 1;
  final TextEditingController _commentController = TextEditingController();
  int _charCount = 0;
  static const int _maxChars = 300;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {
        _charCount = _commentController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    await widget.controller.submitReview(
      userId: widget.otherUserId,
      rating: _selectedStars,
      comment: _commentController.text.trim(),
    );

    if (mounted) {
      Navigator.pop(context);
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 28,
          bottom: MediaQuery.of(context).viewInsets.bottom + 28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            const Text(
              'How was your ride?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),

            const SizedBox(height: 20),

            // Driver avatar placeholder
            Obx(() {
              final driverImage = widget.controller.profileImageUrl;
              return Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: driverImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(driverImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: driverImage.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 36,
                        color: Colors.grey[400],
                      )
                    : null,
              );
            }),

            const SizedBox(height: 10),

            // Driver name
            Obx(() {
              final driverName = widget.controller.otherUserName.value;
              return Text(
                driverName.isNotEmpty ? driverName : 'Driver',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedStars = starIndex),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      starIndex <= _selectedStars
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 40,
                      color: starIndex <= _selectedStars
                          ? const Color(0xFFFFC107)
                          : Colors.grey[350],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Comment label + char count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Write your comment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                ),
                Text(
                  '$_charCount/$_maxChars',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Comment text field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextField(
                controller: _commentController,
                enabled: !_isSubmitting,
                maxLines: 4,
                maxLength: _maxChars,
                decoration: InputDecoration(
                  hintText: 'This ride was awesome!',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                  counterText: '',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C6FF), Color(0xFF845EC2),Color(0xFF845EC2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF845EC2).withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
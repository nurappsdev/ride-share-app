import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';
import '../../../controllers/driver_available_ride_controller.dart';
import '../../../model/provider_requested_ride_model.dart';
import '../../../utils/utils.dart';
import '../../widgets/address_card.dart';
import 'driver_drawer_screen.dart';
import 'passenger_details_screen.dart';


class DriverAvailableRideScreen extends StatelessWidget {
  const DriverAvailableRideScreen({super.key});

  void _showCustomDrawer(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => const DriverDrawerScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize Controller
    final controller = Get.put(DriverAvailableRidesController());

    return Scaffold(
      body: Stack(
        children: [
          // Map Background (Placeholder)
          Container(
            height: 400.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              image: DecorationImage(
                image: AssetImage("${AppImages.mapDriverImg}"),
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
                      onTap: () => _showCustomDrawer(context),
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
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6B7FEC).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(AppIcons.menuIcon),
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
                        color: const Color(0xFF2D3748),
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
                        color: const Color(0xFF2D3748),
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
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.requestedRides.isEmpty) {
                    return Center(
                      child: Text(
                        'No requested rides available.',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController, // Important for scrolling sheet
                    padding: EdgeInsets.all(16.r),
                    itemCount: controller.requestedRides.length,
                    itemBuilder: (context, index) {
                      final ride = controller.requestedRides[index];
                      return InkWell(
                        onTap: () {
                          // Pass details to Passenger Details Screen if needed
                          showPassengerDetails(context);
                        },
                        child: RideBookingCard(ride: ride),
                      );
                    },
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RideBookingCard extends StatelessWidget {
  final ProviderRequestedRideModel ride;

  const RideBookingCard({Key? key, required this.ride}) : super(key: key);

  String _formatTime(String? dateTimeString) {
    if (dateTimeString == null) return '--:--';
    try {
      DateTime dt = DateTime.parse(dateTimeString).toLocal();
      return DateFormat('hh:mm a').format(dt); // e.g., 10:30 PM
    } catch (e) {
      return '--:--';
    }
  }

  // Format Image properly
  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return 'https://i.pravatar.cc/150?img=12'; // Fallback
    if (path.startsWith('http')) return path;

    // Replace with your actual media base URL logic
    // String baseDomain = AppUrl.baseUrl.replaceAll('/api/v1', '');
    // return "$baseDomain/$path"; 

    return path; // Temporary, update to your backend image URL logic
  }

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
          // Passenger Info Section
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Passenger Avatar
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(_getImageUrl(ride.userProfile)),
                ),
                SizedBox(width: 12.w),
                // Passenger Name and Rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.userName ?? 'Unknown Passenger',
                        style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFFFA726),
                            size: 16.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${ride.avgRating?.toStringAsFixed(1) ?? '0.0'}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            ' (${ride.totalRating ?? 0})',
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
            padding: EdgeInsets.all(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
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
                    ride.jobId != null && ride.jobId!.length > 8
                        ? ride.jobId!.substring(ride.jobId!.length - 8).toUpperCase() // Display short hash
                        : ride.jobId ?? 'N/A',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7C3AED),
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
                      ride.distance != null ? ride.distance!.toStringAsFixed(1) : '0.0',
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
                    DashedLine( // Assumes you have this widget in your project
                      height: 28.h,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 4.h),
                    Icon(
                      Icons.location_on,
                      size: 12.sp,
                      color: const Color(0xFFe85f4c),
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
                        ride.fromAddress ?? 'Unknown Location',
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
                        ride.toAddress ?? 'Unknown Location',
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
                        color: const Color(0xFF7C3AED),
                        size: 18.r,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Pick up @ ${_formatTime(ride.dateTime)}',
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
                        color: const Color(0xFF2196F3),
                        size: 18.r,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '€ ${ride.fare?.toStringAsFixed(2) ?? '0.00'}',
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
                      onPressed: () {
                        // TODO: Implement decline logic
                      },
                      child: Text(
                        'Decline',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Outfit",
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Accept Button
                Expanded(
                    child: CustomButtonCommon(
                      title: 'Accept',
                      onpress: () {
                        _showVerificationDialog(context);
                      },
                      useGradient: true,
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog Logic
void _showVerificationDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Verification",
    barrierColor: Colors.black.withOpacity(0.25),
    transitionDuration: const Duration(milliseconds: 10),
    pageBuilder: (_, __, ___) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
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
          "Reach the location in time to pick up the passenger",
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
        CustomButtonCommon(
          title: "View The Map",
          onpress: () { Get.back(); },
          useGradient: true,
        ),
      ],
    ),
  );
}
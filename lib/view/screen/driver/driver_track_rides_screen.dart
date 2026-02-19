import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';

import '../../../../utils/utils.dart';
import '../../widgets/address_card.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class DriverTrackRidesScreen extends StatelessWidget {
  const DriverTrackRidesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                  // Map Grid Lines
                  Container(
                    height: 400.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      image: DecorationImage(
                        image: AssetImage(
                            "${AppImages.trackImg}"
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),


                  // Street Labels
                  Positioned(
                    top: 60.h,
                    left: 30.w,
                    child: Transform.rotate(
                      angle: -0.785,
                      child: CustomText(
                        text: '12 Ave',
                        fontsize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120.h,
                    right: 50.w,
                    child: CustomText(
                      text: 'Street name',
                      fontsize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
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

                          CustomText(
                            text: 'Arriving in  ',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[600],
                          ),

                          CustomText(
                            text: '10 Mins',
                            fontsize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7C3AED),
                          ),
                          SizedBox(width: 150.w,),
                          CustomText(
                            text: '10:30 PM',
                            fontsize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Driver & Vehicle Info
                      InkWell(
                        onTap: (){
                          Get.toNamed(AppRoutes.passengerDetailsReviewScreen,preventDuplicates: false);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 70.w,
                                        height: 70.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(

                                            color: Color(0xFF22D3EE),
                                            width: 3.w,
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [ Color(0xFF45C4D9),
                                              Color(0xFF6B7FEC),
                                              Color(0xFFB565D8),],
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.person,
                                              size: 40.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 6.h,),
                                      CustomText(
                                        text: 'Bernard Alvarado',
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      SizedBox(height: 6.h),
                                    ],
                                  ),
                          ),




                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Location Details
                      AddressCard(fromLocation: '', toLocation: '',),


              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                children: [
                  // Chat Button with gradient
                  Expanded(
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
                        onPressed: () {
                          // Handle chat action
                        },
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
                  SizedBox(width: 12.w),

                  // Start Ride Button
                  Expanded(
                    child: Container(
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
                        onPressed: () {
                          // Handle start ride action
                        },
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
                              Icons.check,
                              color: const Color(0xFF8B5CF6),
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Start Ride',
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
                        // Handle phone call action
                      },
                      icon: Icon(
                        Icons.phone_outlined,
                        color: const Color(0xFF5B8DEF),
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            )
                    ],
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

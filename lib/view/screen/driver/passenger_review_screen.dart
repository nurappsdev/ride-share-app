




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import '../../widgets/widgets.dart';

class PassengerReviewScreen extends StatelessWidget {
  const PassengerReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16.h,
                bottom: 16.h,
                left: 20.w,
                right: 20.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 24.sp, color: Colors.black87),
                  ),
                  CustomText(
                    text: 'Passenger Details',
                    fontsize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  Icon(Icons.notifications_outlined, size: 24.sp, color: Colors.black87),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 24.h),

                    // Driver Profile Card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile Picture
                          Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Icon(
                                Icons.person,
                                size: 60.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Name
                          CustomText(
                            text: 'Jane Cooper',
                            fontsize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          SizedBox(height: 12.h),

                          // Contact Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 14.sp,
                                color: Color(0xFF7C3AED),
                              ),
                              SizedBox(width: 6.w),
                              CustomText(
                                  text: 'janecooper@gmail.com',
                                  fontsize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black
                              ),
                              SizedBox(width: 16.w),
                              Icon(
                                Icons.phone,
                                size: 14.sp,
                                color: Color(0xFF7C3AED),
                              ),
                              SizedBox(width: 6.w),
                              CustomText(
                                  text: '+1 234 567 8901',
                                  fontsize: 12.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding:  EdgeInsets.only(left: 20.w,right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                text: 'Reviews ',
                                fontsize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              CustomText(
                                text: '(150)',
                                fontsize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          CustomText(
                            text: 'View All',
                            fontsize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7C3AED),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Reviews Section
                    Container(

                      padding: EdgeInsets.all(4.w),

                      child: Column(
                        children: [


                          // Review Item 1
                          InkWell(
                            onTap: (){
                              Get.toNamed(AppRoutes.passengerRideEndScreen,preventDuplicates: false);
                            },
                            child: _buildReviewItem(
                              name: 'Devon Lane',
                              role: 'Passenger',
                              rating: 5.0,
                              review: '"Expedited service was requested and pickup from the driver was very fast and earlier than expected"',
                              avatarColor: Color(0xFF00BFA5),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Review Item 2
                          _buildReviewItem(
                            name: 'Albert Flores',
                            role: 'Passenger',
                            rating: 4.9,
                            review: '',
                            avatarColor: Color(0xFFFFB74D),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.r,
                    offset: Offset(0, -2.h),
                  ),
                ],
              ),
              child: Container(
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [        Color(0xFF45C4D9),
                      Color(0xFF6B7FEC),
                      Color(0xFF5c58eb),
                      Color(0xFFB565D8),],
                  ),
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF7C3AED).withOpacity(0.3),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.passengerChatingScreen);
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
                      Icon(Icons.chat_bubble_outline, size: 20.sp),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: 'Chat with your passenger',
                        fontsize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  Widget _buildStatItem(String value, String label, Color valueColor) {
    return Column(
      children: [
        CustomText(
          text: value,
          fontsize: 20,
          fontWeight: FontWeight.bold,
          color: valueColor,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: label,
          fontsize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600]!,
        ),
      ],
    );
  }

  Widget _buildReviewItem({
    required String name,
    required String role,
    required double rating,
    required String review,
    required Color avatarColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: avatarColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 24.sp,
                    color: avatarColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Name and Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: name,
                      fontsize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      maxline: 5,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: role,
                      fontsize: 11,
                      maxline: 5,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600]!,
                    ),
                  ],
                ),
              ),

              // Rating
              Row(
                children: [
                  Icon(Icons.star, size: 16.sp, color: Color(0xFFFF6B00)),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: rating.toString(),
                    fontsize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ],
              ),
            ],
          ),

          if (review.isNotEmpty) ...[
            SizedBox(height: 12.h),
            CustomText(
              text: review,
              textAlign: TextAlign.start,
              maxline: 5,
              fontsize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey[700]!,
            ),
          ],
        ],
      ),
    );
  }
}

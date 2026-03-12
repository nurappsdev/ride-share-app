import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/details/drive_details_controller.dart';
import '../../../../controllers/review_controller.dart';
import '../../../widgets/widgets.dart';

class DriverDetailsScreen extends StatelessWidget {
  const DriverDetailsScreen({Key? key}) : super(key: key);

  String _calculateExperience(String? createdAtDate) {
    if (createdAtDate == null) return '--';
    try {
      DateTime createdDate = DateTime.parse(createdAtDate);
      int years = DateTime.now().year - createdDate.year;
      if (years == 0) return 'New';
      if (years == 1) return '1 Year';
      return '$years Years';
    } catch (e) {
      return '--';
    }
  }

  // Quick helper to generate a nice color based on a name
  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFF00BFA5),
      const Color(0xFFFFB74D),
      const Color(0xFF7C3AED),
      const Color(0xFFE91E63),
      const Color(0xFF3F51B5),
    ];
    int index = name.length % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: GetBuilder<DriverDetailsController>(
            init: DriverDetailsController(),
            builder: (controller) {

              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final driver = controller.driverDetails;

              return Column(
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
                          text: 'Driver Details',
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
                                CustomText(
                                  text: driver?.name ?? 'Unknown Driver',
                                  fontsize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 14.sp,
                                      color: const Color(0xFF7C3AED),
                                    ),
                                    SizedBox(width: 6.w),
                                    CustomText(
                                        text: driver?.email ?? '--',
                                        fontsize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black
                                    ),
                                    SizedBox(width: 16.w),
                                    Icon(
                                      Icons.phone,
                                      size: 14.sp,
                                      color: const Color(0xFF7C3AED),
                                    ),
                                    SizedBox(width: 6.w),
                                    CustomText(
                                        text: driver?.phone ?? '--',
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem(
                                      driver?.totalRides?.toString() ?? '0',
                                      'Rides Taken',
                                      const Color(0xFF7C3AED),
                                    ),
                                    Container(
                                      width: 1.w,
                                      height: 40.h,
                                      color: Colors.grey[300],
                                    ),
                                    _buildStatItem(
                                      driver?.avgRating?.toStringAsFixed(1) ?? '0.0',
                                      'Rating',
                                      const Color(0xFFFF6B00),
                                    ),
                                    Container(
                                      width: 1.w,
                                      height: 40.h,
                                      color: Colors.grey[300],
                                    ),
                                    _buildStatItem(
                                      _calculateExperience(driver?.createdAt),
                                      'Experience',
                                      const Color(0xFF7C3AED),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // ===========================
                          // REVIEWS SECTION START
                          // ===========================

                          // DYNAMIC: Reviews Header
                          GetBuilder<DriverReviewController>(
                              init: DriverReviewController(),
                              builder: (reviewCtrl) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
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
                                            text: '(${reviewCtrl.pagination?.totalCount ?? 0})',
                                            fontsize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(AppRoutes.driverReviewScreen, preventDuplicates: false);
                                        },
                                        child: CustomText(
                                          text: 'View All',
                                          fontsize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF7C3AED),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          ),
                          SizedBox(height: 4.h),

                          // DYNAMIC: Reviews List
                          GetBuilder<DriverReviewController>(
                            builder: (reviewCtrl) {
                              if (reviewCtrl.isLoading) {
                                return Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              }

                              if (reviewCtrl.reviews.isEmpty) {
                                return Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: CustomText(
                                    text: 'No reviews yet for this driver.',
                                    fontsize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                );
                              }

                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
                                child: Column(
                                  children: [
                                    ...reviewCtrl.reviews.map((review) {
                                      String reviewerName = review.reviewerId?.name ?? 'Unknown User';
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 16.h),
                                        child: _buildReviewItem(
                                          name: reviewerName,
                                          role: (review.reviewerId?.role ?? 'Passenger').capitalizeFirst!,
                                          rating: review.rating ?? 5.0,
                                          review: review.comment ?? '',
                                          avatarColor: _getAvatarColor(reviewerName),
                                        ),
                                      );
                                    }).toList(),

                                    // Pagination Indicator/Button
                                    if (reviewCtrl.isMoreLoading)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: CircularProgressIndicator(),
                                      )
                                    else if ((reviewCtrl.pagination?.currentPage ?? 1) < (reviewCtrl.pagination?.totalPages ?? 1))
                                      TextButton(
                                        onPressed: () {
                                          reviewCtrl.fetchReviews(isLoadMore: true);
                                        },
                                        child: CustomText(
                                          text: "Load More Reviews",
                                          fontsize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF7C3AED),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // ===========================
                          // REVIEWS SECTION END
                          // ===========================

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
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF22D3EE), Color(0xFF7C3AED)],
                              ),
                              borderRadius: BorderRadius.circular(28.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7C3AED).withOpacity(0.3),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.driverChatingScreen);
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
                                  Icon(Icons.chat_bubble_outline, size: 20.sp, color: Colors.white,),
                                  SizedBox(width: 8.w),
                                  CustomText(
                                    text: 'Chat with your driver',
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
                            final phoneNumber = driver?.phone;
                            if (phoneNumber != null && phoneNumber.isNotEmpty) {
                              // Create the URI for the phone dialer
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: phoneNumber,
                              );

                              // Check if the device can actually make a call, then launch it
                              if (await canLaunchUrl(launchUri)) {
                                await launchUrl(launchUri);
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Could not open the dialer for this number.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            } else {
                              Get.snackbar(
                                'Notice',
                                'No phone number available for this driver.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
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
                                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Icon(Icons.phone, color: Colors.white, size: 24.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
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
                  Icon(Icons.star, size: 16.sp, color: const Color(0xFFFF6B00)),
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
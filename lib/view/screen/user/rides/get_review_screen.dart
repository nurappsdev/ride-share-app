
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../screens.dart';

class GetReviewScreen extends StatelessWidget {
   GetReviewScreen({Key? key}) : super(key: key);
  int rating = 4;
  final TextEditingController controller = TextEditingController();
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
                            "${AppImages.endRideMap}"
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
                        'Your Ride has ended',
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
              top: 270.h,
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
                      SizedBox(height: 24.h),

                      // Booking Details with dotted separators
                      _buildDetailRow('Booking ID', '58136564', isBlue: true, fontSize: 15.sp, fontFamily: 'Outfit'),
                      _buildDetailRow('Base Fare', '€4.99', fontSize: 15.sp, fontFamily: 'Outfit'),
                      _buildDetailRow('Booking Fee', '€2.13', fontSize: 15.sp, fontFamily: 'Outfit'),
                      _buildDetailRow('Minimum Fare', '€7.00', fontSize: 15.sp, fontFamily: 'Outfit'),
                      _buildDetailRow('Cancellation Fee', '€0.00', fontSize: 15.sp, fontFamily: 'Outfit'),
                      _buildDetailRow('Distance Travelled', '19km', fontSize: 15.sp, fontFamily: 'Outfit'),
                      _buildDetailRow('Split Ride Discount', '- €3.00', fontSize: 15.sp, fontFamily: 'Outfit'),
                      _buildDetailRow('2 Passengers Discount', '- €4.00', fontSize: 15.sp, fontFamily: 'Outfit'),
                      SizedBox(height: 8.h),
                      _buildDetailRow('Total Fare', '\$65.90', isBlue: true, fontSize: 18.sp, fontFamily: 'Outfit',),
                      CustomButtonCommon(
                        title: "Review Your Ride",
                        onpress: () {
                          Get.toNamed(AppRoutes.createReviewScreen,preventDuplicates: false);
                        },
                        useGradient: true,
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

  Widget _buildDetailRow(String label, String value,
      {bool isBlue = false, bool isRed = false, bool isBlack = false, double fontSize = 15, String fontFamily = '', bool hasBottomPadding = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: hasBottomPadding ? 16.h : 0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontFamily: fontFamily.isNotEmpty ? fontFamily : null,
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: DottedLinePainter(),
              child: Container(),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: isBlue == true ? Color(0xff4869f0):  Colors.black,
              fontFamily: fontFamily.isNotEmpty ? fontFamily : null,
            ),
          ),
        ],
      ),
    );
  }

}

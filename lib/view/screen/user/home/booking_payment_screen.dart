

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/utils/app_colors.dart';

import '../../../../controllers/payment_controller.dart';
class PaymentBookingScreen extends StatefulWidget {
  const PaymentBookingScreen({Key? key}) : super(key: key);

  @override
  State<PaymentBookingScreen> createState() => _PaymentBookingScreenState();
}

class _PaymentBookingScreenState extends State<PaymentBookingScreen> {
  bool agreedToTerms = true;

  @override
  Widget build(BuildContext context) {
    // // Initialize ScreenUtil
    // ScreenUtil.init(context, designSize: const Size(375, 812));
    PaymentController paymentController = PaymentController() ;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'Payment System',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Information
                AddressCard(),
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
                SizedBox(height: 24.h),
      
                // Terms and Conditions5C58EB
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          agreedToTerms = value ?? false;
                        });
                      },
                      activeColor: Colors.purple,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Text(
                          'I agree to SplitRide Terms of service',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                        height: 1.5.h,
                      ),
                      children: [
                        TextSpan(
                          text:
                          'You may recieve SMS notifications from us for security and login purposes and will be used to support your ride experience. Message and data rates may apply. For other purposes also read our ',
                        ),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
      
                // VAT with dotted separator
                _buildDetailRow('VAT', '€5.60', fontSize: 15.sp,isBlue: true, fontFamily: 'Outfit', hasBottomPadding: false),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.bookingDetailsScreen,preventDuplicates: false);
                      },
                      child: Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                    Text(
                      '€60',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4869f0),
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
      
                // Confirm Button
                Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00D9FF), Color(0xFF9D4EDD)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(28.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 12.r,
                        offset: Offset(0, 6.h),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.bookingDetailsScreen,preventDuplicates: false);
                      paymentController.makePayment(totalAmount:"60", context: context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: Text(
                      'Confirm Your Booking',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    double dashWidth = 5.0;
    double dashSpace = 5.0;
    double startX = 0;

    while (startX < size.width) {
      // Draw the dash
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                Icons.play_arrow_rounded,
                size: 22.sp,
                color: Colors.black87,
              ),
              SizedBox(height: 4.h),
              DashedLine(
                height: 28.h,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 4.h),
              Icon(
                Icons.location_on_outlined,
                size: 22.sp,
                color: Colors.black87,
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1901 Thornridge Cir. Shiloh',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(height: 1.h),
                SizedBox(height: 16.h),
                Text(
                  '4140 Parker Rd. Allentown, New Mexico',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  final double height;
  final Color color;

  const DashedLine({
    super.key,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          6,
              (_) => Container(
            width: 2.w,
            height: 3.h,
            color: color,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';

import '../../../controllers/payment_controller.dart';
import '../screens.dart';

void showRideOverview(BuildContext context) {
  PaymentController paymentController = PaymentController() ;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
                    'Overview',
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
              SizedBox(height: 16.h),
              // Location Section
              AddressCard(),
              SizedBox(height: 24.h),
              // Blue Info Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF5FF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Approximate Price', '€60', isPrice: true),
                    SizedBox(height: 16.h),
                    _buildInfoRow('Car Type', 'Sadan (4 Seater)'),
                    SizedBox(height: 16.h),
                    // Luggage Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Luggage Info',
                          style: TextStyle(
                            color: const Color(0xFF616161),
                            fontSize: 15.sp,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            _buildLuggageChip('Suitcase', const Color(0xFFB3E5FC)),
                            SizedBox(width: 8.w),
                            _buildLuggageChip('Suitcase', const Color(0xFFE1BEE7)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoRow('Date', '25 May 2025'),
                    SizedBox(height: 16.h),
                    _buildInfoRow('Pickup time', '10 Min'),
                    SizedBox(height: 16.h),
                    _buildInfoRow('Car Seats', '4'),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Disclaimer:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  fontFamily: 'Outfit',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Bookings must be made at least 2 hours in advance. Cancellations made over 24 hours before pickup get a full refund, within 2-24 hours get 50%, and no refund if the driver is on the way or has arrived.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13.sp,
                  height: 1.4,
                  fontFamily: 'Outfit',
                ),
              ),
              SizedBox(height: 32.h),
              // Gradient Button
              Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF45C4D9),
                      Color(0xFF6B7FEC),
                      Color(0xFFB565D8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                   // paymentController.makePayment(totalAmount:"60");
                    Get.toNamed(AppRoutes.bookingPaymentScreen,preventDuplicates: false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      );
    },
  );
}

// Helper widget for Rows
Widget _buildInfoRow(String label, String value, {bool isPrice = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          color: const Color(0xFF616161),
          fontSize: 15.sp,
          fontFamily: 'Outfit',
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: isPrice ? const Color(0xFF7047EB) : Colors.black,
          fontFamily: 'Outfit',
        ),
      ),
    ],
  );
}

// Helper widget for Chips
Widget _buildLuggageChip(String label, Color borderColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: 'Outfit',
          ),
        ),
        SizedBox(width: 4.w),
        Icon(Icons.close, size: 14.sp, color: Colors.red),
      ],
    ),
  );
}
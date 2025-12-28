


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../screens.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking Details',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, size: 22.sp, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [

            /// Status
            Container(
              height: 40.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                gradient: const LinearGradient(
                  colors: [    Color(0xFF45C4D9),
                    Color(0xFF6B7FEC),
                    Color(0xFFB565D8),],
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 30.w,),
                  Text(
                    'Status',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 220.w,),
                  Text(
                    'Active',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 16.h),

            /// Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Booking ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _label('Booking ID:'),
                      _value('SR1284E6', color: const Color(0xFF6C4DF6)),
                    ],
                  ),

                  SizedBox(height: 12.h),
                  _divider(),

                  /// Locations
                  AddressCard(),
                  SizedBox(height: 16.h),
                  _divider(),

                  /// Details

                  _row('Date', '25 May 2025'),
                  _row('Time', '11:00 AM'),
                  _row('Passenger', '2'),
                  _row('Luggage', '1 Bag'),

                  SizedBox(height: 16.h),
                  _divider(),

                  /// Fare
                  _buildDetailRow('Total Distance', '16km', fontSize: 15.sp, fontFamily: 'Outfit'),
                  _buildDetailRow('Base Fare', '€4.99', fontSize: 15.sp, fontFamily: 'Outfit'),
                  _buildDetailRow('Booking Fee', '€2.13', fontSize: 15.sp, fontFamily: 'Outfit'),
                  _buildDetailRow('Minimum Fare', '€7.00', fontSize: 15.sp, fontFamily: 'Outfit'),
                  _buildDetailRow('Cancellation Fee', '€0.00', fontSize: 15.sp, fontFamily: 'Outfit'),

                  SizedBox(height: 8.h),
                  _buildDetailRow('Approx. Fare',isBlue: true,
                      '€65.90', fontSize: 16.sp, fontFamily: 'Outfit',),



                  SizedBox(height: 8.h),
                  _row(
                    'Approx. Fare',
                    '€65.90',
                    valueColor: const Color(0xFF6C4DF6),
                    bold: true,
                  ),

                  SizedBox(height: 12.h),

                  /// Cancel Ride
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_car, size: 18.sp),
                          SizedBox(width: 6.w),
                          _label('Cancel your ride?'),
                        ],
                      ),
                      Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14.sp,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  /// Disclaimer
                  _label('Disclaimer:'),
                  SizedBox(height: 6.h),
                  Text(
                    'Cancellations made over 24 hours before pickup get a full refund, '
                        'within 2–24 hours get 50%, and no refund if the driver is on the way or has arrived.',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12.sp,
                      height: 1.4,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            /// Back Button
            Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: const LinearGradient(
                  colors: [    Color(0xFF45C4D9),
                    Color(0xFF6B7FEC),
                    Color(0xFFB565D8),],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text(
                  'Back To Home',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
  /// Helpers
  Widget _row(String label, String value,
      {Color? valueColor, bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _label(label),
          _value(value,
           bold: bold),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() => Divider(height: 24.h, color: const Color(0xFFF1F1F1));

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 16.sp,
      color: const Color(0xFF090E18),
    ),
  );

  Widget _value(String text,
      {Color color = Colors.black, bool bold = false}) =>
      Text(
        text,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14.sp,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: color,
        ),
      );
}



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:split_ride/utils/app_colors.dart';

class MyPaymentScreen extends StatelessWidget {
  const MyPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'My payment',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _balanceCard(),
            SizedBox(height: 16.h),
            _filterRow(),
            SizedBox(height: 20.h),
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _transactionTile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Balance Card
  Widget _balanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF45C4D9),
            Color(0xFF6B7FEC),
            Color(0xFF5c58eb),
            Color(0xFFB565D8),
          ],
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'My Balance',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14.sp,
                ),
              ),
            ),
            Center(
              child: Text(
                '€ 453.00',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 30.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Filter Row
  Widget _filterRow() {
    return Row(
      children: [
        _chip('Filter'),
        SizedBox(width: 10.w),
        _chip('Sort'),
        const Spacer(),
        _circleIcon(Icons.download_outlined),
        SizedBox(width: 10.w),
        _circleIcon(Icons.clean_hands_outlined),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(0xfff2e3ff),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color:Color(0xffba63ff),
            ),
          ),
          SizedBox(width: 6.w,),
          Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return

      Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF45C4D9),

          Color(0xFF5c58eb),
          Color(0xFFB565D8),],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF3B82F6).withOpacity(0.3),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      );
  }

  // 🔹 Transaction Tile
  Widget _transactionTile() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: const Color(0xFFEDEAFF),
            child: const Icon(Icons.person, color: Color(0xFF6B6EF9)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Booking ID SR12405',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '€ 10.00',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                  color:Color(0xffba63ff),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '05 Jun 2023 | 10:00 AM',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

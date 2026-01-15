


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';

class DriverMyVehiclesScreen extends StatelessWidget {
  const DriverMyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'My vehicles',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _vehicleCard();
                },
              ),
            ),
            _addVehicleButton(),
          ],
        ),
      ),
    );
  }

  // 🔹 Vehicle Card
  Widget _vehicleCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Car Image
          Image.asset(
            'assets/images/carImg.png', // replace with your image
            width: 110.w,
            height: 60.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Honda Civic - 2021',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _gradientChip('LEO 232'),
                    SizedBox(width: 8.w),
                    _gradientChip('4 seater'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Gradient Chip
  Widget _gradientChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF45C4D9),
            Color(0xFF6B7FEC),
            Color(0xFF5c58eb),
            Color(0xFFB565D8),
          ],
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 🔹 Add New Vehicle Button
  Widget _addVehicleButton() {
    return
      InkWell(
        onTap: (){
          Get.toNamed(AppRoutes.vihicleAddScreen,preventDuplicates: false);
        },
        child: Container(
        margin: EdgeInsets.only(top: 10.h, bottom: 20.h),
        height: 52.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF45C4D9),
              Color(0xFF6B7FEC),
              Color(0xFF5c58eb),
              Color(0xFFB565D8),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Text(
              'Add New Vehicle',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: const Color(0xFF6B6EF9),
              ),
            ),
          ),
        ),
            ),
      );
  }
}



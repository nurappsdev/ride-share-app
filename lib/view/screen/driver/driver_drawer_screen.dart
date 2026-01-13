


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class DriverDrawerScreen extends StatelessWidget {
   DriverDrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🔥 TRANSPARENT + BLUR BACKGROUND
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ),
        ),

        // 🔥 DRAWER PANEL
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.78,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: _drawerContent(context),
          ),
        ),
      ],
    );
  }

  Widget _drawerContent(BuildContext context) {
    return Material(  // Add Material widget as ancestor for ListTile
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(height: 50.h),

          // Profile Card
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF6ECFF),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26.r,
                    backgroundColor: Colors.purple[100],
                    child: Icon(Icons.person,
                        color: const Color(0xFF6552EC), size: 28.sp),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kimmy Natasa',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            const LinearGradient(
                              colors: [Color(0xFF45C4D9), Color(0xFF6B7FEC)],
                            ).createShader(bounds),
                        child: Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          const Divider(),

          // Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                InkWell(
                    onTap:(){
                      Get.toNamed(AppRoutes.personalInfoScreen,preventDuplicates: false);
                    },
                    child: _menu(Icons.person_outline, "Personal Info")),
                _menu(Icons.payments_outlined, "My Payment"),
                _menu(Icons.watch_later_outlined, "My Rides"),
                _menu(Icons.directions_car_outlined, "My Vehicles"),
                InkWell(
                    onTap:(){
                      Get.toNamed(AppRoutes.privacyPolicyAllScreen,preventDuplicates: false);
                    },child: _menu(Icons.description_outlined, "Terms & Conditions")),
                InkWell(
                    onTap:(){
                      Get.toNamed(AppRoutes.privacyPolicyAllScreen,preventDuplicates: false);
                    },child: _menu(Icons.shield_outlined, "Privacy")),
                InkWell(
                    onTap:(){

                      Get.toNamed(AppRoutes.helpAndSupportScreen,preventDuplicates: false);

                    },child: _menu(Icons.help_outline, "Help & Support")),
                _menu(Icons.bookmark_outline, "Saved Places"),
                _menu(Icons.language_outlined, "Language"),
              ],
            ),
          ),

          // Bottom Actions
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _action(Icons.logout, "Log out"),
                SizedBox(height: 12.h),
                _action(Icons.delete_outline, "Delete account"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6552EC)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Outfit',
        ),
      ),
    );
  }

  Widget _action(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.red),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.sp,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }
}



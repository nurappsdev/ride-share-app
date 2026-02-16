import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/utils/app_image.dart';

// class RoleScreen extends StatelessWidget {
//   const RoleScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox.expand(
//         child: Image.asset(
//           '${AppImages.roleScreenImg}',
//           fit: BoxFit.cover, // পুরো screen fill করবে
//         ),
//       ),
//
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Background Image
          Positioned.fill(
            child: Image.asset('${AppImages.roleScreenImg}', fit: BoxFit.cover),
          ),

          /// 🔹 Top Logo Section
          Positioned(
            top: 60.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(height: 25.h),
                Image.asset('${AppImages.appLogo}', height: 70.h),
              ],
            ),
          ),

          /// 🔹 Middle Vehicle Image
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              '${AppImages.vihicle1}',
              height: 200.h,
              fit: BoxFit.contain,
            ),
          ),

          /// 🔹 Bottom Content
          Positioned(
            bottom: 40.h,
            left: 24.w,
            right: 24.w,
            child: Column(
              children: [
                Text(
                  "Welcome to Split Ride",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Outfit",
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Start saving with Split Ride app by sharing your \nride with others.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                    fontFamily: "Outfit",
                  ),
                ),
                SizedBox(height: 24.h),

                /// 🔹 Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: CustomButtonCommon(
                        title: "Login",
                        onpress: () {
                          Get.toNamed(
                            AppRoutes.roleScreen1,
                            preventDuplicates: false,
                            arguments: {"fromSignInPage": true},
                          );
                          // Get.toNamed(AppRoutes.signInScreen,preventDuplicates: false);
                        },
                        useGradient: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButtonCommon(
                        title: "Sign Up",
                        onpress: () {
                          Get.toNamed(
                            AppRoutes.roleScreen1,
                            preventDuplicates: false,
                            arguments: {"fromSignInPage": false},
                          );
                        },
                        titlecolor: Color(0xffBA63FF),
                        color: Color(0xffebddfb),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

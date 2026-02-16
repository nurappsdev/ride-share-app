import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:split_ride/helpers/get_storage.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';
import 'package:split_ride/helpers/user_enum.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/utils/app_image.dart';

import 'package:split_ride/view/widgets/custom_button_common.dart';

class RoleScreen1 extends StatelessWidget {
  const RoleScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final bool fromSignInPage = Get.arguments['fromSignInPage'] ?? false;
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
              '${AppImages.vihicle2}',
              height: 340.h,
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
                  "You're Passenger or Driver?",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Outfit",
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "You can find a ride or offer your services as a \ndriver, so choose who you are.",
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
                        title: "Passenger",
                        onpress: () async {
                          await GetStorageModel().saveString(
                            AppConstants.currentRole,
                            UserRole.user.name,
                          );
                          fromSignInPage
                              ? Get.offNamed(
                                  AppRoutes.signInScreen,
                                  preventDuplicates: false,
                                )
                              : Get.offNamed(
                                  AppRoutes.signUpScreen,
                                  preventDuplicates: false,
                                );
                        },
                        useGradient: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButtonCommon(
                        title: "Driver",
                        onpress: () async {
                          await GetStorageModel().saveString(
                            AppConstants.currentRole,
                            UserRole.provider.name,
                          );
                          fromSignInPage
                              ? Get.offNamed(
                            AppRoutes.signInScreen,
                            preventDuplicates: false,
                          )
                              : Get.offNamed(
                            AppRoutes.signUpScreen,
                            preventDuplicates: false,
                          );
                          // Get.toNamed(AppRoutes.completeProfileScreen,preventDuplicates: false);
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

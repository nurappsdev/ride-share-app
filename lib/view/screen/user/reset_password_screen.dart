
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/auth_controller.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_constant.dart';

import '../../widgets/custom_button_common.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final TextEditingController oldPassCNRL = TextEditingController();
  final TextEditingController newPass2 = TextEditingController();
  final TextEditingController conPass3 = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // ── Title ──────────────────────────────────────────────────
                  Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // ── Old Password ───────────────────────────────────────────
                  Text(
                    'Enter old password',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: oldPassCNRL,
                    isPassword: true,
                    hintText: 'Enter old password',
                    filColor: const Color(0xFFF2F3F5),
                    borderRadio: 14.r,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.primaryColor,
                        size: 22.sp,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 22.h),

                  // ── New Password ───────────────────────────────────────────
                  Text(
                    'New password',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: newPass2,
                    isPassword: true,
                    hintText: 'Enter new password',
                    filColor: const Color(0xFFF2F3F5),
                    borderRadio: 14.r,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.primaryColor,
                        size: 22.sp,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 22.h),

                  // ── Confirm Password ───────────────────────────────────────
                  Text(
                    'Confirm password',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: conPass3,
                    isPassword: true,
                    hintText: 'Confirm new password',
                    filColor: const Color(0xFFF2F3F5),
                    borderRadio: 14.r,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.primaryColor,
                        size: 22.sp,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      } else if (value != newPass2.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 36.h),

                  // ── Update Password Button ─────────────────────────────────
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF40C8E0), Color(0xFF9B59F5)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        child: ElevatedButton(
                          onPressed: authController.changePasswordLoading.value
                              ? null
                              : () async {
                            if (formKey.currentState!.validate()) {
                              final success = await authController.updatePassword(
                                oldPassword: oldPassCNRL.text,
                                newPassword: newPass2.text,
                                confirmPassword: conPass3.text,
                              );
                              
                              if (success && context.mounted) {
                                // Navigate back or to login
                                Get.back();
                                Get.snackbar(
                                  'Success',
                                  'Password updated successfully',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                          ),
                          child: authController.changePasswordLoading.value
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text(
                            'Update Password',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
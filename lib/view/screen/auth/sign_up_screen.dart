import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/auth_controller/sign_up_controller.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/custom_loading.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.put(SignUpController());
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Form(
            key: signUpController.formKey,

            child: Column(
              children: [
                SizedBox(height: 40.h),
                // Logo Section
                Column(
                  children: [
                    Image.asset('${AppImages.appLogo2}', height: 45.h),
                    SizedBox(height: 4.h),
                  ],
                ),
                SizedBox(height: 40.h),
                // White Card
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 16.h),
                          CustomText(
                            text: 'Create an account',
                            fontWeight: FontWeight.bold,
                            fontsize: 28.sp,
                            color: Color(0xFF2D3748),
                            fontName: "Outfit-ExtraBold.ttf",
                          ),

                          SizedBox(height: 6.h),

                          CustomText(
                            text: 'Enter your full name & phone to signup',
                            fontsize: 14.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),

                          SizedBox(height: 32.h),
                          // Full Name Field
                          CustomText(
                            text: 'Full Name',
                            fontWeight: FontWeight.w600,
                            fontsize: 14.sp,
                            color: AppColors.blackColor,
                            textAlign: TextAlign.left,
                          ),

                          SizedBox(height: 8.h),
                          CustomTextField(
                            controller: signUpController.fullNameTEController,
                            hintText: 'Enter your name',
                            hinTextColor: const Color(0xFFB8B8B8),
                            hinTextSize: 14,
                            filColor: const Color(0xFFF7FAFC),
                            borderColor: Colors.transparent,
                            borderRadio: 30.r,
                            contentPaddingHorizontal: 16.w,
                            contentPaddingVertical: 16.h,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 12,
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: const Color(0xFF6B7FEC),
                                size: 20,
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please Enter your name '.tr;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16.h),
                          CustomText(
                            text: 'Email',
                            fontWeight: FontWeight.w600,
                            fontsize: 14.sp,
                            color: AppColors.blackColor,
                            textAlign: TextAlign.left,
                          ),

                          SizedBox(height: 8.h),

                          CustomTextField(
                            controller: signUpController.emailTEController,
                            hintText: 'Enter your mail',
                            hinTextColor: const Color(0xFFB8B8B8),
                            hinTextSize: 14.sp,
                            filColor: const Color(0xFFF7FAFC),
                            borderColor: Colors.transparent,
                            borderRadio: 30.r,
                            contentPaddingHorizontal: 16.w,
                            contentPaddingVertical: 16.h,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 12.w),
                              child: Icon(
                                Icons.email_outlined,
                                color: const Color(0xFF6B7FEC),
                                size: 20.sp,
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please Enter your email '.tr;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          // Phone Number Field
                          CustomText(
                            text: 'Phone Number',
                            fontWeight: FontWeight.w600,
                            fontsize: 14.sp,
                            color: AppColors.blackColor,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8.h),

                          CustomTextField(
                            controller:
                                signUpController.phoneNumberTEController,
                            hintText: 'Enter your phone number',
                            hinTextColor: const Color(0xFFB8B8B8),
                            hinTextSize: 14.sp,
                            filColor: const Color(0xFFF7FAFC),
                            keyboardType: TextInputType.number,
                            borderColor: Colors.transparent,
                            borderRadio: 30.r,
                            contentPaddingHorizontal: 16.w,
                            contentPaddingVertical: 16.h,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 12.w),
                              child: Icon(
                                Icons.phone_in_talk_outlined,
                                color: const Color(0xFF6B7FEC),
                                size: 20.sp,
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please Enter your phone number '.tr;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          // Phone Number Field
                          CustomText(
                            text: 'Password',
                            fontWeight: FontWeight.w600,
                            fontsize: 14.sp,
                            color: AppColors.blackColor,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8.h),

                          CustomTextField(
                            controller: signUpController.passwordTEController,
                            hintText: 'Enter your password',
                            hinTextColor: const Color(0xFFB8B8B8),
                            hinTextSize: 14.sp,
                            filColor: const Color(0xFFF7FAFC),
                            borderColor: Colors.transparent,
                            borderRadio: 30.r,
                            contentPaddingHorizontal: 16.w,
                            contentPaddingVertical: 16.h,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 12.w),
                              child: Icon(
                                Icons.password,
                                color: const Color(0xFF6B7FEC),
                                size: 20.sp,
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please Enter your password '.tr;
                              }
                              return null;
                            },
                            isPassword: true,
                          ),
                          SizedBox(height: 20.h),
                          // Phone Number Field
                          CustomText(
                            text: 'Confirm Password',
                            fontWeight: FontWeight.w600,
                            fontsize: 14.sp,
                            color: AppColors.blackColor,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8.h),

                          CustomTextField(
                            controller:
                                signUpController.confirmPasswordTEController,
                            hintText: 'Confirm your Password',
                            hinTextColor: const Color(0xFFB8B8B8),
                            hinTextSize: 14.sp,
                            filColor: const Color(0xFFF7FAFC),
                            borderColor: Colors.transparent,
                            borderRadio: 30.r,
                            contentPaddingHorizontal: 16.w,
                            contentPaddingVertical: 16.h,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 12.w),
                              child: Icon(
                                Icons.password,
                                color: const Color(0xFF6B7FEC),
                                size: 20.sp,
                              ),
                            ),

                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please Confirm your password '.tr;
                              } else if (value !=
                                  signUpController.passwordTEController.text) {
                                return "Passwords do not match !!!";
                              }
                              return null;
                            },
                            isPassword: true,
                          ),
                          const SizedBox(height: 32),
                          // Login Button
                          Obx(
                            () => Visibility(
                              visible: signUpController.loader.value == false,
                              replacement: CustomLoading(),
                              child: CustomButtonCommon(
                                title: "Sign Up",
                                onpress: () async {
                                  await signUpController.handleSignUp();
                                },
                                useGradient: true,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // Or Divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  'Or',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: "Outfit",
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          // Facebook Button
                          Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                foregroundColor: const Color(0xFF2D3748),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                              icon: const Icon(
                                Icons.facebook,
                                color: Color(0xFF1877F2),
                              ),
                              label: const Text(
                                'Continue with Facebook',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Outfit",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Google Button
                          Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                foregroundColor: const Color(0xFF2D3748),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                              icon: Image.network(
                                'https://www.google.com/favicon.ico',
                                width: 20.w,
                                height: 20.h,
                              ),
                              label: const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Outfit",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                  fontFamily: "Outfit",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.signInScreen,
                                    preventDuplicates: false,
                                  );
                                },
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFF45C4D9),
                                          Color(0xFF6B7FEC),
                                          Color(0xFFB565D8),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds),
                                  child: const Text(
                                    'Login now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
}

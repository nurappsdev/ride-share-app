import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';
class SignInScreen extends StatelessWidget {
   SignInScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF45C4D9),
              Color(0xFF6B7FEC),
              Color(0xFFB565D8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
               SizedBox(height: 40.h),
              // Logo Section
              Column(
                children: [
                  Image.asset(
                    '${AppImages.appLogo2}',
                    height: 45.h,
                  ),
                   SizedBox(height: 4.h),
                ],
              ),
               SizedBox(height: 40.h),
              // White Card
              Expanded(
                child: Container(
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding:  EdgeInsets.all(24.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                         SizedBox(height: 16.h),
                         CustomText(text:  'Welcome Back',fontWeight: FontWeight.bold,fontsize: 28.sp,color: Color(0xFF2D3748),fontName: "Outfit-ExtraBold.ttf",),

                         SizedBox(height: 6.h),

                        CustomText(text: 'Enter your full name & phone to login',fontsize: 14.sp,color: Colors.grey[600],fontWeight: FontWeight.w600,),

                         SizedBox(height: 32.h),
                        // Full Name Field
                        CustomText(text: 'Full Name',fontWeight: FontWeight. w600,fontsize: 14.sp,color: AppColors.blackColor,textAlign: TextAlign.left,),

                         SizedBox(height: 8.h),
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Enter your name',
                          hinTextColor: const Color(0xFFB8B8B8),
                          hinTextSize: 14,
                          filColor: const Color(0xFFF7FAFC),
                          borderColor: Colors.transparent,
                          borderRadio: 30.r,
                          contentPaddingHorizontal: 16.w,
                          contentPaddingVertical: 16.h,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 12),
                            child: Icon(
                              Icons.person_outline,
                              color: const Color(0xFF6B7FEC),
                              size: 20,
                            ),
                          ),
                        ),

                         SizedBox(height: 20.h),
                        // Phone Number Field
                        CustomText(text:   'Phone Number',fontWeight: FontWeight. w600,fontsize: 14.sp,color: AppColors.blackColor,textAlign: TextAlign.left,),

                        SizedBox(height: 8.h),

                        CustomTextField(
                          controller: nameController,
                          hintText: 'Enter your phone number',
                          hinTextColor: const Color(0xFFB8B8B8),
                          hinTextSize: 14.sp,
                          filColor: const Color(0xFFF7FAFC),
                          borderColor: Colors.transparent,
                          borderRadio: 30.r,
                          contentPaddingHorizontal: 16.w,
                          contentPaddingVertical: 16.h,
                          prefixIcon: Padding(
                            padding:  EdgeInsets.only(left: 16.w, right: 12.w),
                            child: Icon(
                              Icons.phone_in_talk_outlined,
                              color: const Color(0xFF6B7FEC),
                              size: 20.sp,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Login Button
                      CustomButtonCommon(
                          title: "Login",
                          onpress: () {},
                          useGradient: true,
                        ),
                         SizedBox(height: 24.h),
                        // Or Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 16.w),
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
                            borderRadius: BorderRadius.circular(
                              30.r
                            ),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Colors.grey[100],
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
                            borderRadius: BorderRadius.circular(
                                30.r
                            ),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Colors.grey[100],
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
                              'Not a member? ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14.sp,
                                fontFamily: "Outfit",
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.signUpScreen,preventDuplicates: false);
                              },
                              child: ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFF45C4D9),
                                    Color(0xFF6B7FEC),
                                    Color(0xFFB565D8),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: const Text(
                                  'Signup now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
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
    );
  }
}
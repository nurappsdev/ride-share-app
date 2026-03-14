import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/auth_controller/sign_in_controller.dart';
import 'package:split_ride/helpers/user_enum.dart';
import 'package:split_ride/view/widgets/custom_loading.dart';
import '../../../helpers/get_storage.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInController signInController = Get.put(SignInController());
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Form(
            key: signInController.formKey,
            child: Column(
              children: [
                SizedBox(height: 40.h),
                // Logo Section
                Column(
                  children: [
                    Image.asset(AppImages.appLogo2, height: 45.h),
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
                            text: 'Welcome Back',
                            fontWeight: FontWeight.bold,
                            fontsize: 28.sp,
                            color: Color(0xFF2D3748),
                            fontName: "Outfit-ExtraBold.ttf",
                          ),

                          SizedBox(height: 6.h),

                          CustomText(
                            text: 'Enter your full name & phone to login',
                            fontsize: 14.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                          /*SizedBox(height: 16.h),
                          CustomText(
                            text: 'Select your role',
                            fontWeight: FontWeight.w600,
                            fontsize: 14.sp,
                            color: AppColors.blackColor,
                            textAlign: TextAlign.left,
                          ),*/

                          SizedBox(height: 8.h),
                          /*
                         /// ==========> ROLE SELECTION DROPDOWN ==================>
                         DropdownButtonFormField<String>(
                            value: UserRole.provider.name,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.withValues(alpha: 0.09),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                            items: [
                              DropdownMenuItem<String>(
                                value: UserRole.provider.name,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 20,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Driver',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: UserRole.user.name,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.directions_car_outlined,
                                      size: 20,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Passenger',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (String? newValue) async {
                              if (newValue != null) {
                                signInController.selectedRole.value = newValue;

                                // Optional: Reset dependent fields when role changes
                                if (newValue == UserRole.user.name) {
                                  await GetStorageModel().saveString(
                                    AppConstants.currentRole,
                                    UserRole.user.name,
                                  );
                                } else if (newValue == UserRole.provider.name) {
                                  await GetStorageModel().saveString(
                                    AppConstants.currentRole,
                                    UserRole.provider.name,
                                  );
                                }
                              }
                            },
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                              color: AppColors.primaryColor,
                            ),
                            elevation: 8,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          SizedBox(height: 32.h),*/
                          // Full Name Field
                          CustomText(
                            text: 'Email',
                            fontWeight: FontWeight.w600,
                            fontsize: 14.sp,
                            color: AppColors.blackColor,
                            textAlign: TextAlign.left,
                          ),

                          SizedBox(height: 8.h),
                          CustomTextField(
                            controller: signInController.emailTEController,
                            hintText: 'Enter your email',
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
                                Icons.email_outlined,
                                color: const Color(0xFF6B7FEC),
                                size: 20,
                              ),
                            ),

                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please Enter your email ';
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
                            controller: signInController.passwordTEController,
                            hintText: 'Enter your phone number',
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
                            isPassword: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please Enter your password!! ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          // Login Button
                          Obx(
                            () => Visibility(
                              replacement: CustomLoading(),
                              visible: signInController.loader.value == false,
                              child: CustomButtonCommon(
                                title: "Login",
                                onpress: () {
                                  signInController.handleSignIn();
                                  // Get.toNamed(AppRoutes.allBottomBar,preventDuplicates: false);
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
                                errorBuilder: (_,_, _)=> SizedBox.shrink() ,
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
                                  Get.toNamed(
                                    AppRoutes.signUpScreen,
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
                                    'Signup now',
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

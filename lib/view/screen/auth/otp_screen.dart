import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';
import 'package:split_ride/view/widgets/custom_loading.dart';

import '../../../controllers/auth_controller/verify_mail_controller.dart';
import '../../../utils/utils.dart';
import '../../widgets/commonGradientBackground.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmailVerifyController emailVerifyController = Get.put(
      EmailVerifyController(),
    );
    final TextEditingController otpController = TextEditingController();
    final registrationForm = Get.arguments['registration_form'] ?? {};
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(34.r),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Logo
                    Column(
                      children: [
                        Image.asset('${AppImages.appLogo2}', height: 45.h),
                      ],
                    ),
                    Spacer(),
                    SizedBox(width: 40.w), // Balance the back button
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // White Card
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 40.h),
                        // Title
                        Text(
                          'Please check your messages & enter your 6 digit code',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                            height: 1.5,
                            fontFamily: "Outfit",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // OTP Input Field using CustomPinCodeTextField
                        CustomPinCodeTextField(
                          textEditingController: otpController,
                          onCompleted: (value) {
                            print('OTP Completed: $value');
                            // Handle OTP verification here
                          },
                        ),
                        const SizedBox(height: 40),
                        // Verify Button
                        Obx(
                          () => Visibility(
                            visible:
                                emailVerifyController.loader.value == false,
                            replacement: CustomLoading(),
                            child: CustomButtonCommon(
                              title: 'Verify your account',
                              useGradient: true,
                              onpress: () {
                                emailVerifyController.handleOTPVerifyForSignUp(
                                  otp: otpController.text.trim(),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        // Resend Code Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't get code? ",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontFamily: "Outfit",
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible:
                                    emailVerifyController
                                        .resendOtpLoader
                                        .value ==
                                    false,
                                replacement: CustomLoading(),
                                child: GestureDetector(
                                  onTap: () {
                                    emailVerifyController
                                        .handleResendOTPForSignUp(
                                          registrationForm: registrationForm,
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
                                      'Resend',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: "Outfit",

                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
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
    );
  }
}

// Custom Pin Code TextField Widget
class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({
    super.key,
    this.textEditingController,
    this.onCompleted,
  });

  final TextEditingController? textEditingController;
  final Function(String)? onCompleted;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: textEditingController,
      autoDisposeControllers: false,
      length: 6,
      autoFocus: false,
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      textStyle: const TextStyle(
        color: Color(0xFF4E4E4E),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      beforeTextPaste: (text) {
        return true; // Allow paste
      },
      inputFormatters: [],
      onChanged: (value) {
        // keep empty
      },
      onCompleted: (value) {
        if (onCompleted != null) {
          onCompleted!(value);
        }
      },
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 60,
        fieldWidth: 50,
        activeColor: const Color(0xFF6B7FEC),
        inactiveColor: const Color(0xFFE8E8E8),
        selectedColor: const Color(0xFF6B7FEC),
        activeFillColor: const Color(0xFFF7FAFC),
        inactiveFillColor: const Color(0xFFF7FAFC),
        selectedFillColor: const Color(0xFFF7FAFC),
        borderWidth: 1,
      ),
    );
  }
}

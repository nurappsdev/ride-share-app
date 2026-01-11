import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';

import '../../../utils/utils.dart';
import '../../widgets/commonGradientBackground.dart';


class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }


  final bool isSignup = Get.arguments ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                        child:  Icon(
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
                        Image.asset(
                          '${AppImages.appLogo2}',
                          height: 45.h,
                        ),
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
                            fontFamily: "Outfit"
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // OTP Input Field using CustomPinCodeTextField
                        CustomPinCodeTextField(
                          textEditingController: _otpController,
                          onCompleted: (value) {
                            print('OTP Completed: $value');
                            // Handle OTP verification here
                          },
                        ),
                        const SizedBox(height: 40),
                        // Verify Button
                        CustomButtonCommon(title:  'Verify your account', useGradient: true, onpress: (){
                          _showVerificationDialog(context);
                          print('Verify OTP: ${_otpController.text}');

                        }),

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
                                  fontFamily: "Outfit"
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('Resend OTP');
                                // Handle resend OTP
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
                                  'Resend',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,     fontFamily: "Outfit",

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
    );
  }



  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF45C4D9),
                Color(0xFF6B7FEC),
                Color(0xFFB565D8),
              ],
            ),
          ),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Container(
              padding: EdgeInsets.all(40.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Icon with Gradient
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF45C4D9),
                          Color(0xFF6B7FEC),
                          Color(0xFFB565D8),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 60.sp,
                      weight: 4,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Title
                  Text(
                    "You're Verified!",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Subtitle
                  Text(
                    'You have successfully verified your account.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: "Outfit",
                      color: Colors.grey[600],
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 36.h),
                  // Start Button
                  Container(
                    width: double.infinity,
                    height: 60.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF45C4D9),
                          Color(0xFF6B7FEC),
                          Color(0xFFB565D8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6B7FEC).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                      Get.toNamed(AppRoutes.allBottomBar,preventDuplicates: false);
                        // Navigate to home or next screen
                        print('Start Enjoying Split Ride');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Start Enjoying Split Ride',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/help_support_controller.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/view/widgets/custom_loading.dart';

import '../../widgets/widgets.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HelpSupportController controller = Get.put(HelpSupportController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Help & Support',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none, size: 22.sp, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),

        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CustomLoading());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Contact Info Card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xfff4f4f4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email_outlined, color: AppColors.primary3rdColor),
                            SizedBox(width: 10.w),
                            CustomText(text: "info@splitride.com"),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Icon(Icons.phone_in_talk, color: AppColors.primary3rdColor),
                            SizedBox(width: 10.w),
                            CustomText(text: "+1234 567 8901"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Full Name (Non-editable)
                  _label('Full Name'),
                  SizedBox(height: 8.h),
                  AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(text: controller.userName.value),
                      hintText: 'Your name',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(Icons.person_outline, color: AppColors.primary3rdColor),
                      ),
                      filColor: const Color(0xFFF5F5F5),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Phone Number (Non-editable)
                  _label('Phone Number'),
                  SizedBox(height: 8.h),
                  AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(text: controller.userPhone.value),
                      hintText: 'Enter Phone Number',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(Icons.phone_in_talk_outlined, color: AppColors.primary3rdColor),
                      ),
                      filColor: const Color(0xFFF5F5F5),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Email (Non-editable)
                  _label('Email'),
                  SizedBox(height: 8.h),
                  AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(text: controller.userEmail.value),
                      hintText: 'Enter Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(Icons.email_outlined, color: AppColors.primary3rdColor),
                      ),
                      filColor: const Color(0xFFF5F5F5),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Booking ID (Editable)
                  _label('Booking ID'),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: controller.bookingIdController,
                    hintText: 'Enter your booking ID',
                    keyboardType: TextInputType.text,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(Icons.book_online, color: AppColors.primary3rdColor),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    color: Colors.grey,
                    textAlign: TextAlign.start,
                    text: "To find your Booking ID, go to Rides, select your ride, and you'll\nsee the Booking ID in the ride details.",
                    fontsize: 12.sp,
                  ),

                  SizedBox(height: 20.h),

                  // Your Message (Editable)
                  _label('Your Message'),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: controller.messageController,
                    maxLine: 5,
                    hintText: 'Describe your issue or inquiry...',
                    keyboardType: TextInputType.multiline,
                    contentPaddingHorizontal: 16.w,
                    contentPaddingVertical: 12.h,
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        }),

        // Submit Button
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
          child: Obx(() => controller.isSubmitting.value
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary3rdColor))
              : CustomButtonCommon(
                  title: "Submit",
                  onpress: () async {
                    final success = await controller.submitReport();
                    if (success && context.mounted) {
                      _showSuccessDialog(context);
                    }
                  },
                  useGradient: true,
                )),
        ),
      ),
    );
  }

  /// Label Widget
  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
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
                    "Report Submitted!",
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
                    'Your report has been submitted successfully. Our support team will get back to you soon.',
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
                  // Go Back Button
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
                        Get.back();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Go Back',
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

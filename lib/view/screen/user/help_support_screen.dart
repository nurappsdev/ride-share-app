

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_icons.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../widgets/widgets.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();




  @override
  Widget build(BuildContext context) {
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

        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 20.h),

              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color:   Color(0xfff4f4f4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email_outlined,color: AppColors.primary3rdColor,),
                        SizedBox(width: 10.w,),
                        CustomText(text: "info@splitride.com",),
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        Icon(Icons.phone_in_talk,color: AppColors.primary3rdColor,),
                        SizedBox(width: 10.w,),
                        CustomText(text: "+1234 567 8901",),
                      ],
                    ),
                  ],
                ),
                ),

              SizedBox(height: 32.h),

              /// Full Name
              _label('Full Name'),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: nameCtrl,
                hintText: 'Enter name',

                prefixIcon:
                Padding(
                  padding:  EdgeInsets.all(8.r),
                  child: Icon(Icons.person_outline, color: AppColors.primary3rdColor),
                ),
              ),

              SizedBox(height: 20.h),

              /// Phone Number
              _label('Phone Number'),
              SizedBox(height: 8.h),

              CustomTextField(

                controller: phoneCtrl,
                hintText: 'Enter Phone Number',
                keyboardType: TextInputType.phone,
                prefixIcon:          Padding(
                    padding:  EdgeInsets.all(8.r),child: Icon(Icons.phone_in_talk_outlined,color: AppColors.primary3rdColor,)),
              ),

              SizedBox(height: 20.h),

              /// Email
              _label('Booking ID'),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: emailCtrl,
                hintText: 'Enter Your booking ID (Optional)',
                keyboardType: TextInputType.emailAddress,
                prefixIcon:          Padding(
                    padding:  EdgeInsets.all(8.r),child: Icon(Icons.book_online, color: AppColors.primary3rdColor)),
              ),
              SizedBox(height: 8.h,),
              CustomText(
                color: Colors.grey,
                textAlign: TextAlign.start,text: "To find your Booking ID, go to Rides, select your ride, and you’ll \nsee the Booking ID in the ride details.",fontsize: 12.sp,),
              SizedBox(height: 20.h),
              _label('Your Message'),
              SizedBox(height: 8.h,),
              CustomTextField(
                controller: emailCtrl,
                maxLine: 4,
                hintText: 'Enter Your booking ID (Optional)',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 40.h),
              // CustomButtonCommon(title: "Save Change", onpress: (){} ,useGradient: true, )
            ],
          ),
        ),

        /// Save Button

        bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
            child: CustomButtonCommon(title: "Submit", onpress: (){
              _showVerificationDialog(context);

            },useGradient: true,)

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
          color:Colors.black
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
                       Get.back();
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
                        'Go Back Home',
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

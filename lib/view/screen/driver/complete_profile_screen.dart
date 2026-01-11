import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';
import 'package:split_ride/view/widgets/custom_text.dart';
import 'package:split_ride/view/widgets/custom_text_field.dart';
import '../../../utils/utils.dart';
import '../../widgets/commonGradientBackground.dart';


class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {





TextEditingController dateCNTRL = TextEditingController();
TextEditingController addressCNTRL = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Column(
                children: [
                  Image.asset(
                    '${AppImages.appLogo2}',
                    height: 45.h,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomText(text: "Vehicle Details",fontsize: 24.sp,fontWeight: FontWeight.bold,),
                        SizedBox(height: 8.h,),
                        // Title
                        Text(
                          'Enter your vehicle information.',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              height: 1.5,
                              fontFamily: "Outfit"
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        /// Profile Image Placeholder
                        SizedBox(height: 20.h),
                        CustomText(text: "Date of Birth",textAlign: TextAlign.start,fontWeight: FontWeight.w600,),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller: dateCNTRL,
                          hintText: "Enter date of birth",
                          readOnly: true,
                          onTap: () async {
                        FocusScope.of(context).unfocus();

                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.primary3rdColor,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          dateCNTRL.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}-"
                              "${pickedDate.month.toString().padLeft(2, '0')}-"
                              "${pickedDate.year}";
                        }
                      },
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Icon(
                              Icons.calendar_month,
                              color: AppColors.primary3rdColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomText(text: "Address",textAlign: TextAlign.start,fontWeight: FontWeight.w600,),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller: addressCNTRL,
                          hintText: "Enter your address",
                          onTap: () {},
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primary3rdColor,
                            ),
                          ),
                        ),

                        Spacer(),
                        CustomButtonCommon(title: "Next", onpress: (){
                          Get.toNamed(AppRoutes.vehicleDetailsScreen,preventDuplicates: false);
                        },useGradient: true,),


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

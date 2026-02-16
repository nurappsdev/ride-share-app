import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:split_ride/controllers/auth_controller/driver_profile_reistration_controller.dart';
import 'package:split_ride/helpers/app_sizes.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';
import 'package:split_ride/view/widgets/custom_loading.dart';
import 'package:split_ride/view/widgets/custom_text.dart';
import 'package:split_ride/view/widgets/custom_text_field.dart';
import '../../../utils/utils.dart';
import '../../widgets/commonGradientBackground.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DriverProfileRegistrationController
    driverProfileRegistrationController = Get.put(
      DriverProfileRegistrationController(),
    );
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Column(
                children: [
                  Image.asset(AppImages.appLogo2, height: 45.h),
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
                        CustomText(
                          text: "Complete your profile",
                          fontsize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 8.h),
                        // Title
                        Text(
                          'Enter your information and create your new account',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            height: 1.5,
                            fontFamily: "Outfit",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),

                        /// Profile Image Placeholder
                        /*InkWell(
                          onTap: (){
                            driverProfileRegistrationController.pickProfileImage(ImageSource.camera) ;
                          },
                          child: Container(
                            padding: EdgeInsets.all(AppSizes.xxxL * 1.02),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary3rdColor.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child:  Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: AppColors.primary3rdColor,
                                  size: 48,
                                ),
                            ),
                          ),
                        ),*/
                        Center(
                          child: Obx(() {
                            final bool isUploading =
                                driverProfileRegistrationController
                                    .isUploadingProfileImage
                                    .value;
                            final File? profileImage =
                                driverProfileRegistrationController
                                    .profileImage
                                    .value;

                            return InkWell(
                              onTap: isUploading
                                  ? null
                                  : () {
                                      driverProfileRegistrationController
                                          .showProfileImagePicker();
                                    },
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary3rdColor.withOpacity(
                                    0.1,
                                  ),
                                  border: Border.all(
                                    color: AppColors.primary3rdColor,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: profileImage != null
                                      ? Image.file(
                                          profileImage,
                                          fit: BoxFit.cover,
                                          width: 140,
                                          height: 140,
                                        )
                                      : Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: AppColors.primary3rdColor,
                                          size: 48,
                                        ),
                                ),
                              ),
                            );
                          }),
                        ),

                        SizedBox(height: 20.h),
                        CustomText(
                          text: "Date of Birth",
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 8.h),
                        CustomTextField(
                          controller: driverProfileRegistrationController
                              .dateTEController,
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
                              driverProfileRegistrationController
                                      .dateTEController
                                      .text =
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
                        CustomText(
                          text: "Address",
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 8.h),

                        /*  /// === OLD Address picking ========>
                        CustomTextField(
                          controller: driverProfileRegistrationController
                              .addressTEController,
                          hintText: "Enter your address",
                          readOnly: true,
                          onTap: () async {
                            await driverProfileRegistrationController
                                .openLocationPicker();
                          },
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primary3rdColor,
                            ),
                          ),
                        ),*/

                        /// ==================== NEW address picking ================>
                        GooglePlaceAutoCompleteTextField(
                          boxDecoration: BoxDecoration(border: Border()),
                          textEditingController:
                              driverProfileRegistrationController
                                  .addressTEController,
                          googleAPIKey: AppConstants.googleMapKey,
                          // Add your API key
                          inputDecoration: InputDecoration(
                            hintText: "Enter your address",
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.r),
                              child: Icon(
                                Icons.location_on_outlined,
                                color: AppColors.primary3rdColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColors.primary3rdColor,
                              ),
                            ),
                          ),
                          debounceTime: 600,
                          // countries: ["bd"], // Restrict to Bangladesh, or remove for worldwide

                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (Prediction prediction) {
                            // This callback gives you the selected place details
                            driverProfileRegistrationController
                                .setSelectedLocation(
                                  latitude: double.parse(prediction.lat ?? '0'),
                                  longitude: double.parse(
                                    prediction.lng ?? '0',
                                  ),
                                  address: prediction.description ?? '',
                                );
                          },
                          itemClick: (Prediction prediction) {
                            driverProfileRegistrationController
                                    .addressTEController
                                    .text =
                                prediction.description ?? '';
                          },
                          seperatedBuilder: Divider(),
                          // containerHorizontalPadding: 10,
                          // itemBuilder: (context, index, Prediction prediction) {
                          //   return Container(
                          //     padding: EdgeInsets.all(10),
                          //     child: Row(
                          //       children: [
                          //         Icon(Icons.location_on, color: AppColors.primary3rdColor),
                          //         SizedBox(width: 10),
                          //         Expanded(
                          //           child: Text(
                          //             prediction.description ?? "",
                          //             style: TextStyle(fontSize: 14),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // },
                          isCrossBtnShown: true,
                        ),

                        Spacer(),
                        Obx(
                          () => Visibility(
                            visible:
                                driverProfileRegistrationController
                                    .isUploadingProfileImage
                                    .value ==
                                false,
                            replacement: CustomButtonCommon(
                              title: "Next",
                              onpress: () {},
                              useGradient: false,
                            ),

                            child: CustomButtonCommon(
                              title: "Next",
                              onpress: () {
                                final bool formValidated =
                                    driverProfileRegistrationController
                                        .checkFirstScreenValidation();
                                if (formValidated) {
                                  driverProfileRegistrationController
                                      .fetchCarTypes();
                                  Get.toNamed(
                                    AppRoutes.vehicleDetailsScreen,
                                    preventDuplicates: false,
                                  );
                                }
                              },
                              useGradient: true,
                            ),
                          ),
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

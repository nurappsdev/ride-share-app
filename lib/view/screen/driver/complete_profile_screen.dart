import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:split_ride/controllers/auth_controller/driver_profile_reistration_controller.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';
import 'package:split_ride/view/widgets/custom_text.dart';
import 'package:split_ride/view/widgets/custom_text_field.dart';
import '../../../utils/utils.dart';
import '../../widgets/commonGradientBackground.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DriverProfileRegistrationController driverProfileRegistrationController = Get.put(
      DriverProfileRegistrationController(),
    );
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Image.asset(AppImages.appLogo2, height: 45.h),
              SizedBox(height: 40.h),

              /// Main Content Card
              Container(
                height: 1000.h,
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

                        /// Profile Image
                        Center(
                          child: Obx(() {
                            final bool isUploading = driverProfileRegistrationController.isUploadingProfileImage.value;
                            final File? profileImage = driverProfileRegistrationController.profileImage.value;

                            return InkWell(
                              onTap: isUploading ? null : () {
                                driverProfileRegistrationController.showProfileImagePicker();
                              },
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary3rdColor.withValues(alpha: 0.1),
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
                                      : const Icon(
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
                          controller: driverProfileRegistrationController.dateTEController,
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
                              driverProfileRegistrationController.dateTEController.text =
                                  "${pickedDate.day.toString().padLeft(2, '0')}-"
                                  "${pickedDate.month.toString().padLeft(2, '0')}-"
                                  "${pickedDate.year}";
                            }
                          },
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: const Icon(
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

                        /// Google Places Address Picker
                        GooglePlaceAutoCompleteTextField(
                          boxDecoration: const BoxDecoration(border: Border()),
                          textEditingController: driverProfileRegistrationController.addressTEController,
                          googleAPIKey: AppConstants.googleMapKey,
                          inputDecoration: InputDecoration(
                            hintText: "Enter your address",
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.r),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: AppColors.primary3rdColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: AppColors.primary3rdColor),
                            ),
                          ),
                          debounceTime: 600,
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (Prediction prediction) {
                            driverProfileRegistrationController.setSelectedLocation(
                              latitude: double.parse(prediction.lat ?? '0'),
                              longitude: double.parse(prediction.lng ?? '0'),
                              address: prediction.description ?? '',
                            );
                          },
                          itemClick: (Prediction prediction) {
                            driverProfileRegistrationController.addressTEController.text = prediction.description ?? '';
                          },
                          seperatedBuilder: const Divider(),
                          isCrossBtnShown: true,
                        ),

                        SizedBox(height: 30.h),
                        Obx(
                          () => Visibility(
                            visible: driverProfileRegistrationController.isUploadingProfileImage.value == false,
                            replacement: CustomButtonCommon(
                              title: "Next",
                              onpress: () {},
                              useGradient: false,
                            ),
                            child: CustomButtonCommon(
                              title: "Next",
                              onpress: () {
                                final bool formValidated = driverProfileRegistrationController.checkFirstScreenValidation();
                                if (formValidated) {
                                  driverProfileRegistrationController.fetchCarTypes();
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
                        SizedBox(height: 20.h),
                      ],
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

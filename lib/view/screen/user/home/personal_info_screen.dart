import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/personal_info_controller.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import '../../../widgets/widgets.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final PersonalInfoController controller = Get.put(PersonalInfoController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Personal Info',
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
              icon: Icon(
                Icons.notifications_none,
                size: 22.sp,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Obx(() {
          // Show loading indicator while fetching profile
          if (controller.isLoadingProfile.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary3rdColor,
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                /// Profile Image
                Center(
                  child: GestureDetector(
                    onTap: () => _showImagePickerBottomSheet(context, controller),
                    child: Obx(() => Stack(
                      children: [
                        Container(
                          width: 110.w,
                          height: 110.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF2ECFF),
                            image: _getProfileImage(controller),
                          ),
                          child: _getProfileImage(controller) == null
                              ? Center(
                            child:Icon(Icons.person, size: 32,),
                          )
                              : null,
                        ),
                        // Edit icon
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary3rdColor,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),

                SizedBox(height: 32.h),

                /// Full Name
                _label('Full Name'),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: controller.nameController,
                  hintText: 'Enter name',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.primary3rdColor,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// Phone Number
                _label('Phone Number'),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: controller.phoneController,
                  hintText: 'Enter Phone Number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(
                      Icons.phone_in_talk_outlined,
                      color: AppColors.primary3rdColor,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// Email
                _label('Email'),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: controller.emailController,
                  hintText: 'Enter Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(
                      Icons.mail_outline,
                      color: AppColors.primary3rdColor,
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          );
        }),

        /// Save Button
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
          child: Obx(
                () => controller.loader.value
                ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary3rdColor,
              ),
            )
                : CustomButtonCommon(
              title: "Save Change",
              onpress: () => controller.updateProfile(),
              useGradient: true,
            ),
          ),
        ),
      ),
    );
  }

  /// Get profile image decoration
  DecorationImage? _getProfileImage(PersonalInfoController controller) {
    // Priority: Local selected image > Network image
    if (controller.selectedImage.value != null) {
      return DecorationImage(
        image: FileImage(controller.selectedImage.value!),
        fit: BoxFit.cover,
      );
    } else if (controller.profileImageUrl.value.isNotEmpty && controller.profileImageUrl.value.startsWith('http')) {
      return DecorationImage(
        image: CachedNetworkImageProvider("${controller.profileImageUrl.value}"),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  /// Show image picker bottom sheet
  void _showImagePickerBottomSheet(
      BuildContext context,
      PersonalInfoController controller,
      ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Text(
                  'Choose Photo',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                SizedBox(height: 16.h),

                // Camera option
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary3rdColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.primary3rdColor,
                    ),
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.camera);
                  },
                ),

                // Gallery option
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary3rdColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.photo_library,
                      color: AppColors.primary3rdColor,
                    ),
                  ),
                  title: Text(
                    'Gallery',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.gallery);
                  },
                ),


              ],
            ),
          ),
        );
      },
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
}
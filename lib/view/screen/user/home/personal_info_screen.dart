
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_icons.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/widgets.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();



  File? selectedImage;
  final ImagePicker _picker = ImagePicker();



  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });

      // 🔹 এখানে API upload call দিতে পারো
      // uploadImage(selectedImage);
    }
  }


  void showImagePickerBottomSheet() {
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
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


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
      
              /// Profile Image Placeholder
              Center(
                child: GestureDetector(
                  onTap: showImagePickerBottomSheet,
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF2ECFF),
                      image: selectedImage != null
                          ? DecorationImage(
                        image: FileImage(selectedImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: selectedImage == null
                        ? Center(
                      child: SvgPicture.asset(
                        AppIcons.imgIcon,
                        height: 40.h,
                        width: 40.w,
                      ),
                    )
                        : null,
                  ),
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
              _label('Email'),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: emailCtrl,
                hintText: 'Enter Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon:          Padding(
                    padding:  EdgeInsets.all(8.r),child: Icon(Icons.mail_outline, color: AppColors.primary3rdColor)),
              ),
      
              SizedBox(height: 40.h),
              // CustomButtonCommon(title: "Save Change", onpress: (){} ,useGradient: true, )
            ],
          ),
        ),
      
        /// Save Button

        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
          child: CustomButtonCommon(title: "Save Change", onpress: (){},useGradient: true,)

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
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';  // Unused import
import 'package:image_picker/image_picker.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';  // Now we need this import
import 'package:split_ride/view/widgets/custom_text.dart';
import 'package:split_ride/view/widgets/custom_text_field.dart';
import '../../../utils/utils.dart';
import '../../widgets/commonGradientBackground.dart';
import 'package:get/get.dart';  // For navigation
import '../../../routes/app_routes.dart';  // For navigation

// Class to hold controllers for each vehicle
class VehicleControllers {
  late TextEditingController vehicleModelCtrl;
  late TextEditingController vehicleNumberCtrl;
  late TextEditingController seatCountCtrl;
  late TextEditingController manufacturingYearCtrl;
  
  VehicleControllers() {
    vehicleModelCtrl = TextEditingController();
    vehicleNumberCtrl = TextEditingController();
    seatCountCtrl = TextEditingController();
    manufacturingYearCtrl = TextEditingController();
  }
  
  void dispose() {
    vehicleModelCtrl.dispose();
    vehicleNumberCtrl.dispose();
    seatCountCtrl.dispose();
    manufacturingYearCtrl.dispose();
  }
}

class VihicleDetailsScreen extends StatefulWidget {
  const VihicleDetailsScreen({super.key});

  @override
  State<VihicleDetailsScreen> createState() => _VihicleDetailsScreenState();
}

class _VihicleDetailsScreenState extends State<VihicleDetailsScreen> {

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
  
  // Controllers for the first vehicle (main vehicle)
  TextEditingController vehicleModelCtrl = TextEditingController();
  TextEditingController vehicleNumberCtrl = TextEditingController();
  TextEditingController seatCountCtrl = TextEditingController();
  TextEditingController manufacturingYearCtrl = TextEditingController();
  
  // List to hold controllers for additional vehicles
  List<VehicleControllers> additionalVehicles = [];

  @override
  void dispose() {
    // Dispose of the main vehicle controllers
    vehicleModelCtrl.dispose();
    vehicleNumberCtrl.dispose();
    seatCountCtrl.dispose();
    manufacturingYearCtrl.dispose();
    
    // Dispose of all additional vehicle controllers
    for (var vehicle in additionalVehicles) {
      vehicle.dispose();
    }
    super.dispose();
  }

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
                child: SingleChildScrollView(
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
                          SizedBox(height: 8.h,),
                          CustomText(text: "Vehicle Details",textAlign:TextAlign.center,fontsize: 24.sp,fontWeight: FontWeight.bold,),
                          SizedBox(height: 8.h),

                          Center(
                            child: Text(
                              "Enter your vehicle information.",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                                fontFamily: "Outfit",
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),
                          CustomText(text: "Vehicle",textAlign:TextAlign.start,fontsize: 16.sp,fontWeight: FontWeight.bold,),
                          SizedBox(height: 8.h),
                          /// Vehicle Model
                          CustomTextField(
                            controller: vehicleModelCtrl,
                            hintText: "Vehicle model",
                            filColor: const Color(0xFFF6F7FB),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.r),
                              child: Icon(
                                Icons.directions_car_outlined,
                                color: AppColors.primary3rdColor,
                                size: 20.sp,
                              ),
                            ),
                            borderColor: Colors.transparent,
                          ),

                          SizedBox(height: 12.h),

                          /// Vehicle Number
                          CustomTextField(
                            controller: vehicleNumberCtrl,
                            hintText: "Vehicle number",
                            filColor: const Color(0xFFF6F7FB),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.r),
                              child: Icon(
                                Icons.confirmation_number_outlined,
                                color: AppColors.primary3rdColor,
                                size: 20.sp,
                              ),
                            ),
                            borderColor: Colors.transparent,
                          ),

                          SizedBox(height: 12.h),

                          /// Manufacturing Year
                          CustomTextField(
                            controller: manufacturingYearCtrl,
                            hintText: "Manufacturing year",
                            keyboardType: TextInputType.number,
                            filColor: const Color(0xFFF6F7FB),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.r),
                              child: Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors.primary3rdColor,
                                size: 20.sp,
                              ),
                            ),
                            borderColor: Colors.transparent,
                          ),

                          SizedBox(height: 12.h),

                          /// Number of Seats
                          CustomTextField(
                            controller: seatCountCtrl,
                            hintText: "Number of seats",
                            keyboardType: TextInputType.number,
                            filColor: const Color(0xFFF6F7FB),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.r),
                              child: Icon(
                                Icons.grid_view_outlined,
                                color: AppColors.primary3rdColor,
                                size: 20.sp,
                              ),
                            ),
                            borderColor: Colors.transparent,
                          ),

                          SizedBox(height: 20.h),

                          /// Display additional vehicle fields if any exist
                          ...additionalVehicles.asMap().entries.map((entry) {
                            int index = entry.key;
                            VehicleControllers vehicle = entry.value;
                            return Container(
                              margin: EdgeInsets.only(bottom: 20.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F7FB),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.r),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Vehicle ${index + 2}",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary3rdColor,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              additionalVehicles.removeAt(index);
                                              vehicle.dispose();
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),

                                    /// Vehicle Model
                                    CustomTextField(
                                      controller: vehicle.vehicleModelCtrl,
                                      hintText: "Vehicle model",
                                      filColor: Colors.white,
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(10.r),
                                        child: Icon(
                                          Icons.directions_car_outlined,
                                          color: AppColors.primary3rdColor,
                                          size: 20.sp,
                                        ),
                                      ),
                                      borderColor: Colors.grey,
                                    ),

                                    SizedBox(height: 12.h),

                                    /// Vehicle Number
                                    CustomTextField(
                                      controller: vehicle.vehicleNumberCtrl,
                                      hintText: "Vehicle number",
                                      filColor: Colors.white,
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(10.r),
                                        child: Icon(
                                          Icons.confirmation_number_outlined,
                                          color: AppColors.primary3rdColor,
                                          size: 20.sp,
                                        ),
                                      ),
                                      borderColor: Colors.grey,
                                    ),

                                    SizedBox(height: 12.h),

                                    /// Manufacturing Year
                                    CustomTextField(
                                      controller: vehicle.manufacturingYearCtrl,
                                      hintText: "Manufacturing year",
                                      keyboardType: TextInputType.number,
                                      filColor: Colors.white,
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(10.r),
                                        child: Icon(
                                          Icons.calendar_month_outlined,
                                          color: AppColors.primary3rdColor,
                                          size: 20.sp,
                                        ),
                                      ),
                                      borderColor: Colors.grey,
                                    ),

                                    SizedBox(height: 12.h),

                                    /// Number of Seats
                                    CustomTextField(
                                      controller: vehicle.seatCountCtrl,
                                      hintText: "Number of seats",
                                      keyboardType: TextInputType.number,
                                      filColor: Colors.white,
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(10.r),
                                        child: Icon(
                                          Icons.grid_view_outlined,
                                          color: AppColors.primary3rdColor,
                                          size: 20.sp,
                                        ),
                                      ),
                                      borderColor: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),

                          SizedBox(height: 20.h),

                          /// Add More Vehicles Button
                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  additionalVehicles.add(VehicleControllers());
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColors.primary3rdColor,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                              ),
                              child: Text(
                                "Add more vehicles",
                                style: TextStyle(
                                  color: AppColors.primary3rdColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Outfit",
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 12.h),

                          /// Next Button
                          CustomButtonCommon(
                            title: "Next",
                            onpress: () {
                              // Navigate to the next screen after vehicle details are entered
                              Get.toNamed(AppRoutes.driverDocScreen, preventDuplicates: false);
                            },
                            useGradient: true,
                          ),
                          SizedBox(height: 400.h),
                        ],
                      ),
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
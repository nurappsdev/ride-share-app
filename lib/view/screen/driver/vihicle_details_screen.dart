import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/auth_controller/driver_profile_reistration_controller.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/model/driver_registration/car_type_model.dart';
import 'package:split_ride/view/widgets/custom_button_common.dart';
import 'package:split_ride/view/widgets/custom_text.dart';
import 'package:split_ride/view/widgets/custom_text_field.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';
import '../../../utils/utils.dart';
import '../../widgets/commonGradientBackground.dart';
import '../../../routes/app_routes.dart';

// Class to hold controllers for each vehicle
class VehicleDetailsModel {
  late TextEditingController vehicleLicenceCtrl;
  late TextEditingController manufacturingYearCtrl;

  Rx<CarTypeModel?> selectedCarType = Rx<CarTypeModel?>(null);
  RxInt selectedSeats = 0.obs;

  VehicleDetailsModel() {
    vehicleLicenceCtrl = TextEditingController();
    manufacturingYearCtrl = TextEditingController();
  }

  void dispose() {
    vehicleLicenceCtrl.dispose();
    manufacturingYearCtrl.dispose();
  }

  Map<String, dynamic> toJson() {
    return {
      'carModelId': selectedCarType.value?.id,
      'licenseNo': vehicleLicenceCtrl.text,
      'year': manufacturingYearCtrl.text,
      'seat': selectedSeats.value,
    };
  }
}

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final DriverProfileRegistrationController controller = Get.find();

  // Main vehicle
  final mainVehicle = VehicleDetailsModel();

  // List to hold controllers for additional vehicles
  List<VehicleDetailsModel> additionalVehicles = [];

  @override
  void dispose() {
    mainVehicle.dispose();
    for (var vehicle in additionalVehicles) {
      vehicle.dispose();
    }
    super.dispose();
  }

  // Build vehicle model dropdown
  Widget _buildVehicleModelDropdown(
    VehicleDetailsModel vehicle, {
    bool isMain = false,
  }) {
    return Obx(() {
      if (controller.loader.value && controller.carTypes.isEmpty) {
        return Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7FB),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: isMain ? const Color(0xFFF6F7FB) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isMain ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: DropdownButtonFormField<CarTypeModel>(
          value: vehicle.selectedCarType.value,
          decoration: InputDecoration(
            hintText: 'Select vehicle model',
            prefixIcon: Icon(
              Icons.directions_car_outlined,
              color: AppColors.primary3rdColor,
              size: 20.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          items: controller.carTypes.map((CarTypeModel carType) {
            return DropdownMenuItem<CarTypeModel>(
              value: carType,
              child: Text(
                carType.name ?? 'Unknown',
                style: TextStyle(fontSize: 14.sp, fontFamily: 'Outfit'),
              ),
            );
          }).toList(),
          onChanged: (CarTypeModel? newValue) {
            vehicle.selectedCarType.value = newValue;
            // Reset seats when vehicle type changes
            vehicle.selectedSeats.value = 0;
          },
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.primary3rdColor),
        ),
      );
    });
  }

  // Build seats dropdown
  Widget _buildSeatsDropdown(
    VehicleDetailsModel vehicle, {
    bool isMain = false,
  }) {
    return Obx(() {
      final selectedCar = vehicle.selectedCarType.value;
      final availableSeats = selectedCar?.seats ?? [];

      return Container(
        decoration: BoxDecoration(
          color: isMain ? const Color(0xFFF6F7FB) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isMain ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: DropdownButtonFormField<int>(
          value: vehicle.selectedSeats.value == 0
              ? null
              : vehicle.selectedSeats.value,
          decoration: InputDecoration(
            hintText: selectedCar == null
                ? 'Select vehicle model first'
                : 'Select number of seats',
            prefixIcon: Icon(
              Icons.event_seat_outlined,
              color: selectedCar == null
                  ? Colors.grey
                  : AppColors.primary3rdColor,
              size: 20.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          items: availableSeats.isEmpty
              ? null
              : availableSeats.map((int seats) {
                  return DropdownMenuItem<int>(
                    value: seats,
                    child: Text(
                      '$seats ${seats == 1 ? 'Seat' : 'Seats'}',
                      style: TextStyle(fontSize: 14.sp, fontFamily: 'Outfit'),
                    ),
                  );
                }).toList(),
          onChanged: selectedCar == null
              ? null
              : (int? newValue) {
                  if (newValue != null) {
                    vehicle.selectedSeats.value = newValue;
                  }
                },
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: selectedCar == null
                ? Colors.grey
                : AppColors.primary3rdColor,
          ),
        ),
      );
    });
  }

  // Build additional vehicle card
  Widget _buildAdditionalVehicleCard(int index, VehicleDetailsModel vehicle) {
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
                  icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Vehicle Model Dropdown
            _buildVehicleModelDropdown(vehicle),
            SizedBox(height: 12.h),

            // Vehicle Number
            CustomTextField(
              controller: vehicle.vehicleLicenceCtrl,
              hintText: "Vehicle Licence Number",
              filColor: Colors.white,
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.r),
                child: Icon(
                  Icons.confirmation_number_outlined,
                  color: AppColors.primary3rdColor,
                  size: 20.sp,
                ),
              ),
              borderColor: Colors.grey.shade300,
            ),
            SizedBox(height: 12.h),

            // Manufacturing Year
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
              borderColor: Colors.grey.shade300,
            ),
            SizedBox(height: 12.h),

            // Number of Seats Dropdown
            _buildSeatsDropdown(vehicle),
          ],
        ),
      ),
    );
  }

  // Validate form
  bool _validateForm() {
    if (mainVehicle.selectedCarType.value == null) {
      Toast.showError('Please select vehicle model');

      return false;
    }

    if (mainVehicle.vehicleLicenceCtrl.text.isEmpty) {
      Toast.showError('Please enter vehicle number');

      return false;
    }

    if (mainVehicle.manufacturingYearCtrl.text.isEmpty) {
      Toast.showError('Please enter manufacturing year');

      return false;
    }

    if (mainVehicle.selectedSeats.value == 0) {
      Toast.showError('Please select number of seats');

      return false;
    }

    // Validate additional vehicles
    for (int i = 0; i < additionalVehicles.length; i++) {
      final VehicleDetailsModel vehicle = additionalVehicles[i];
      if (vehicle.selectedCarType.value == null ||
          vehicle.vehicleLicenceCtrl.text.isEmpty ||
          vehicle.manufacturingYearCtrl.text.isEmpty ||
          vehicle.selectedSeats.value == 0) {
        Toast.showError('Please complete all fields for Vehicle ${i + 2}');
        return false;
      }
    }

    return true;
  }

  // Submit form
  void _submitForm() {
    if (!_validateForm()) return;

    // Collect all vehicle data
    List<Map<String, dynamic>> vehicles = [
      mainVehicle.toJson(),
      ...additionalVehicles.map((v) => v.toJson()),
    ];

    LoggerUtils.debug('Vehicles Data: $vehicles');

    // Navigate to next screen
    Get.toNamed(AppRoutes.driverDocScreen, preventDuplicates: false);
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
                  Image.asset(AppImages.appLogo2, height: 45.h),
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
                          SizedBox(height: 8.h),
                          CustomText(
                            text: "Vehicle Details",
                            textAlign: TextAlign.center,
                            fontsize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
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
                          CustomText(
                            text: "Vehicle",
                            textAlign: TextAlign.start,
                            fontsize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 8.h),

                          /// Vehicle Model Dropdown
                          _buildVehicleModelDropdown(mainVehicle, isMain: true),
                          SizedBox(height: 12.h),

                          /// Vehicle Number
                          CustomTextField(
                            controller: mainVehicle.vehicleLicenceCtrl,
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
                            controller: mainVehicle.manufacturingYearCtrl,
                            hintText: "Manufacturing year (e.g., 2020)",
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

                          /// Number of Seats Dropdown
                          _buildSeatsDropdown(mainVehicle, isMain: true),
                          SizedBox(height: 20.h),

                          /// Display additional vehicle fields
                          ...additionalVehicles.asMap().entries.map((entry) {
                            return _buildAdditionalVehicleCard(
                              entry.key,
                              entry.value,
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
                                  additionalVehicles.add(VehicleDetailsModel());
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
                          Obx(
                            () => CustomButtonCommon(
                              title: controller.loader.value
                                  ? "Loading..."
                                  : "Next",
                              onpress: controller.loader.value
                                  ? () {}
                                  : _submitForm,
                              useGradient: true,
                            ),
                          ),
                          SizedBox(height: 20.h),
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

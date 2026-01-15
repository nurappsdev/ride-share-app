



// Class to hold controllers for each vehicle
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class VehicleControllerss {
  late TextEditingController vehicleModelCtrl;
  late TextEditingController vehicleNumberCtrl;
  late TextEditingController seatCountCtrl;
  late TextEditingController manufacturingYearCtrl;

  VehicleControllerss() {
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

class VihicleAddScreen extends StatefulWidget {
  const VihicleAddScreen({super.key});

  @override
  State<VihicleAddScreen> createState() => _VihicleAddScreenState();
}

class _VihicleAddScreenState extends State<VihicleAddScreen> {



  // Controllers for the first vehicle (main vehicle)
  TextEditingController vehicleModelCtrl = TextEditingController();
  TextEditingController vehicleNumberCtrl = TextEditingController();
  TextEditingController seatCountCtrl = TextEditingController();
  TextEditingController manufacturingYearCtrl = TextEditingController();

  // List to hold controllers for additional vehicles
  List<VehicleControllerss> additionalVehicles = [];

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
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Add New Vehicle',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40.h),


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
                          VehicleControllerss vehicle = entry.value;
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





                      ],
                    ),
                  ),
                ),
              ),
            ),
            /// Next Button
            CustomButtonCommon(
              title: "Save",
              onpress: () {
                // Navigate to the next screen after vehicle details are entered
                //   Get.toNamed(AppRoutes.driverDocScreen, preventDuplicates: false);
              },
              useGradient: true,
            ),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }
}

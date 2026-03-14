



// Class to hold controllers for each vehicle
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/utils/app_constant.dart';

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

  // Car models list
  List<dynamic> _carModels = [];
  bool _isLoadingCarModels = false;
  String? _selectedCarModelId;
  List<int> _availableSeats = [];
  String? _selectedSeat;
  
  // Save state
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchCarModels();
  }

  Future<void> _fetchCarModels() async {
    setState(() {
      _isLoadingCarModels = true;
    });

    try {
      final response = await NetworkCaller().getRequest(
        AppUrl.getCarType,
      );

      if (response.isSuccess && response.jsonResponse != null) {
        setState(() {
          _carModels = response.jsonResponse!['data'] ?? [];
        });
      }
    } catch (e) {
      print('Error fetching car models: $e');
    } finally {
      setState(() {
        _isLoadingCarModels = false;
      });
    }
  }

  void _onCarModelSelected(String? carModelId) {
    setState(() {
      _selectedCarModelId = carModelId;
      _availableSeats = [];
      _selectedSeat = null;
      
      // Find selected car model and get seats
      if (carModelId != null) {
        final selectedModel = _carModels.firstWhere(
          (model) => model['_id'] == carModelId,
          orElse: () => null,
        );
        
        if (selectedModel != null) {
          final seats = selectedModel['seats'] as List? ?? [];
          _availableSeats = seats.map((s) => s as int).toList();
        }
      }
    });
  }

  Future<void> _saveVehicles() async {
    // Validate main vehicle
    if (_selectedCarModelId == null || _selectedCarModelId!.isEmpty) {
      _showSnackBar('Please select a vehicle model');
      return;
    }
    if (_selectedSeat == null || _selectedSeat!.isEmpty) {
      _showSnackBar('Please select number of seats');
      return;
    }
    if (vehicleNumberCtrl.text.isEmpty) {
      _showSnackBar('Please enter vehicle number');
      return;
    }
    if (manufacturingYearCtrl.text.isEmpty) {
      _showSnackBar('Please enter manufacturing year');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final token = await PrefsHelper.getString(AppConstants.bearerToken);

      // Build vehicles array
      List<Map<String, dynamic>> vehicles = [];

      // Add main vehicle
      vehicles.add({
        'carModelId': _selectedCarModelId,
        'seat': int.tryParse(_selectedSeat!) ?? 0,
        'licenseNo': vehicleNumberCtrl.text,
        'year': int.tryParse(manufacturingYearCtrl.text) ?? 0,
      });

      // Add additional vehicles
      for (var vehicle in additionalVehicles) {
        vehicles.add({
          'carModelId': vehicle.vehicleModelCtrl.text,
          'seat': int.tryParse(vehicle.seatCountCtrl.text) ?? 0,
          'licenseNo': vehicle.vehicleNumberCtrl.text,
          'year': int.tryParse(vehicle.manufacturingYearCtrl.text) ?? 0,
        });
      }

      final response = await NetworkCaller().putRequest(
        '${AppUrl.baseUrl}/provider/profile',
        body: {
          'vehicles': vehicles,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.isSuccess) {
        _showSnackBar('Vehicle(s) saved successfully!');
        Get.back();
      } else {
        _showSnackBar(response.errorMessage ?? 'Failed to save vehicles');
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'Outfit',
        color: const Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?>? onChanged,
    bool isEnabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFF6F7FB) : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isEnabled ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: 13.sp,
            color: isEnabled ? Colors.grey.shade500 : Colors.grey.shade400,
            fontFamily: "Outfit",
          ),
        ),
        items: items,
        onChanged: isEnabled ? onChanged : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: isEnabled ? AppColors.primary3rdColor : Colors.grey.shade400,
            size: 18.sp,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: isEnabled ? AppColors.primary3rdColor : Colors.grey.shade400,
          size: 18.sp,
        ),
        dropdownColor: Colors.white,
        menuMaxHeight: 300.h,
        style: TextStyle(
          fontSize: 13.sp,
          fontFamily: "Outfit",
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: CustomTextField(
        controller: controller,
        hintText: hintText,
        filColor: Colors.transparent,
        keyboardType: keyboardType,
        prefixIcon: Icon(
          icon,
          color: AppColors.primary3rdColor,
          size: 18.sp,
        ),
        borderColor: Colors.transparent,
        hinTextSize: 13.sp,
        contentPaddingHorizontal: 12.w,
        contentPaddingVertical: 12.h,
      ),
    );
  }

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
                        /// Section Title
                        _buildSectionTitle('Type Of Car & Seats'),
                        SizedBox(height: 12.h),
                        
                        /// Type Of Car & Seats - Column Layout
                        _buildDropdown(
                          label: 'Car Type',
                          value: _selectedCarModelId,
                          hint: 'Select car type',
                          icon: Icons.directions_car_outlined,
                          items: _carModels.map((model) {
                            return DropdownMenuItem<String>(
                              value: model['_id'],
                              child: Text(
                                model['name'] ?? model['model'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _onCarModelSelected,
                        ),

                        SizedBox(height: 16.h),

                        /// Seat Dropdown
                        _buildDropdown(
                          label: 'Seats',
                          value: _selectedSeat,
                          hint: 'Select seats',
                          icon: Icons.grid_view_outlined,
                          items: _availableSeats.map((seat) {
                            return DropdownMenuItem<String>(
                              value: seat.toString(),
                              child: Text(
                                '$seat',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _availableSeats.isEmpty 
                              ? null 
                              : (value) {
                                  setState(() {
                                    _selectedSeat = value;
                                  });
                                },
                          isEnabled: _availableSeats.isNotEmpty,
                        ),

                        SizedBox(height: 20.h),

                        /// Section Title
                        _buildSectionTitle('Vehicle Details'),
                        SizedBox(height: 12.h),

                        /// Vehicle Number
                        _buildTextField(
                          controller: vehicleNumberCtrl,
                          hintText: "Vehicle number (e.g., ABC-123)",
                          icon: Icons.confirmation_number_outlined,
                        ),

                        SizedBox(height: 16.h),

                        /// Manufacturing Year
                        _buildTextField(
                          controller: manufacturingYearCtrl,
                          hintText: "Manufacturing year (e.g., 2021)",
                          icon: Icons.calendar_month_outlined,
                          keyboardType: TextInputType.number,
                        ),

                        SizedBox(height: 20.h),

                        /// Display additional vehicle fields if any exist
                        ...additionalVehicles.asMap().entries.map((entry) {
                          int index = entry.key;
                          VehicleControllerss vehicle = entry.value;
                          return _buildAdditionalVehicleCard(index, vehicle);
                        }).toList(),

                        /// Add Another Vehicle Button
                        _buildAddAnotherVehicleButton(),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /// Next Button
            CustomButtonCommon(
              title: _isSaving ? "Saving..." : "Save",
              onpress: _isSaving ? () {} : _saveVehicles,
              useGradient: true,
              loading: _isSaving,
            ),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalVehicleCard(int index, VehicleControllerss vehicle) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF45C4D9),
                          Color(0xFF6B7FEC),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 2}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Additional Vehicle",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary3rdColor,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    additionalVehicles.removeAt(index);
                    vehicle.dispose();
                  });
                },
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.grey.shade200, height: 1),
          SizedBox(height: 16.h),
          
          /// Vehicle Model Dropdown
          _buildDropdown(
            label: 'Car Type',
            value: vehicle.vehicleModelCtrl.text.isEmpty ? null : vehicle.vehicleModelCtrl.text,
            hint: 'Select car type',
            icon: Icons.directions_car_outlined,
            items: _carModels.map((model) {
              return DropdownMenuItem<String>(
                value: model['_id'],
                child: Text(
                  model['name'] ?? model['model'] ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                vehicle.vehicleModelCtrl.text = value ?? '';
              });
            },
          ),

          SizedBox(height: 12.h),

          /// Vehicle Number
          _buildTextField(
            controller: vehicle.vehicleNumberCtrl,
            hintText: "Vehicle number",
            icon: Icons.confirmation_number_outlined,
          ),

          SizedBox(height: 12.h),

          /// Manufacturing Year
          _buildTextField(
            controller: vehicle.manufacturingYearCtrl,
            hintText: "Manufacturing year",
            icon: Icons.calendar_month_outlined,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildAddAnotherVehicleButton() {
    return InkWell(
      onTap: () {
        setState(() {
          additionalVehicles.add(VehicleControllerss());
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primary3rdColor.withOpacity(0.3),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppColors.primary3rdColor,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Add Another Vehicle',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary3rdColor,
                fontFamily: 'Outfit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

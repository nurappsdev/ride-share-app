



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/services/network/network_caller.dart';

import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

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

  // Car models list
  List<dynamic> _carModels = [];
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
      debugPrint('Error fetching car models: $e');
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

  Future<void> _saveVehicle() async {
    // Validate vehicle
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

      final response = await NetworkCaller().putRequest(
        '${AppUrl.baseUrl}/provider/add-vehicle',
        body: {
          'carModelId': _selectedCarModelId,
          'seat': int.tryParse(_selectedSeat!) ?? 0,
          'licenseNo': vehicleNumberCtrl.text,
          'year': int.tryParse(manufacturingYearCtrl.text) ?? 0,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.isSuccess) {
        _showSnackBar('Vehicle added successfully!');
        Get.back(result: true);
      } else {
        _showSnackBar(response.errorMessage ?? 'Failed to add vehicle');
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
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade500,
            fontFamily: "Outfit",
          ),
        ),
        items: items,
        onChanged: isEnabled ? onChanged : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: AppColors.primary3rdColor,
            size: 18.sp,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.primary3rdColor,
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
            onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /// Save Button
            CustomButtonCommon(
              title: _isSaving ? "Saving..." : "Save",
              onpress: _isSaving ? () {} : _saveVehicle,
              useGradient: true,
              loading: _isSaving,
            ),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }
}

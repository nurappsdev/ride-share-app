


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/model/vehicle/vehicle_model.dart';

class DriverMyVehiclesScreen extends StatefulWidget {
  const DriverMyVehiclesScreen({super.key});

  @override
  State<DriverMyVehiclesScreen> createState() => _DriverMyVehiclesScreenState();
}

class _DriverMyVehiclesScreenState extends State<DriverMyVehiclesScreen> {
  List<VehicleModel> _vehicles = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await PrefsHelper.getString(AppConstants.bearerToken);
      
      // First, fetch provider profile to get vehicles
      final profileResponse = await NetworkCaller().getRequest(
        '${AppUrl.baseUrl}/provider/profile',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (profileResponse.isSuccess && profileResponse.jsonResponse != null) {
        final data = profileResponse.jsonResponse!['data'] ?? {};
        final List<dynamic> vehiclesData = data['vehicles'] ?? [];
        
        // Fetch car model details for each vehicle
        List<VehicleModel> loadedVehicles = [];
        for (var vehicleData in vehiclesData) {
          final vehicle = VehicleModel.fromJson(vehicleData);
          
          // Fetch car model details if carModelId exists
          if (vehicle.carModelId != null) {
            final carModelResponse = await NetworkCaller().getRequest(
              '${AppUrl.baseUrl}/car-model/${vehicle.carModelId}',
              headers: {
                'Authorization': 'Bearer $token',
              },
            );
            
            if (carModelResponse.isSuccess && carModelResponse.jsonResponse != null) {
              final carModelData = carModelResponse.jsonResponse!['data'] ?? carModelResponse.jsonResponse!;
              vehicle.carModelName = carModelData['name'] ?? carModelData['model'] ?? 'Unknown';
            }
          }
          
          loadedVehicles.add(vehicle);
        }
        
        setState(() {
          _vehicles = loadedVehicles;
        });
      } else {
        setState(() {
          _errorMessage = profileResponse.errorMessage ?? 'Failed to load vehicles';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          'My vehicles',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80.sp, color: Colors.red),
                      SizedBox(height: 16.h),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14.sp,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton.icon(
                        onPressed: _fetchVehicles,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: _vehicles.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.directions_car_outlined, size: 80.sp, color: Colors.grey),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'No vehicles added yet',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 16.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _vehicles.length,
                                itemBuilder: (context, index) {
                                  final vehicle = _vehicles[index];
                                  return _vehicleCard(vehicle);
                                },
                              ),
                      ),
                      _addVehicleButton(),
                    ],
                  ),
                ),
    );
  }

  // 🔹 Vehicle Card
  Widget _vehicleCard(VehicleModel vehicle) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Car Image
          Image.asset(
            'assets/images/carImg.png',
            width: 110.w,
            height: 60.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.carModelName ?? 'Unknown'} - ${vehicle.year ?? 'N/A'}',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _gradientChip(vehicle.licenseNo ?? 'N/A'),
                    SizedBox(width: 8.w),
                    _gradientChip('${vehicle.seat ?? 0} seater'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Gradient Chip
  Widget _gradientChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF45C4D9),
            Color(0xFF6B7FEC),
            Color(0xFF5c58eb),
            Color(0xFFB565D8),
          ],
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 🔹 Add New Vehicle Button
  Widget _addVehicleButton() {
    return
      InkWell(
        onTap: (){
          Get.toNamed(AppRoutes.vihicleAddScreen,preventDuplicates: false);
        },
        child: Container(
        margin: EdgeInsets.only(top: 10.h, bottom: 20.h),
        height: 52.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF45C4D9),
              Color(0xFF6B7FEC),
              Color(0xFF5c58eb),
              Color(0xFFB565D8),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Text(
              'Add New Vehicle',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: const Color(0xFF6B6EF9),
              ),
            ),
          ),
        ),
            ),
      );
  }
}



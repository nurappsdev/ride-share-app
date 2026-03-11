import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/passenger_home_controller.dart';
import 'package:split_ride/utils/app_colors.dart';

class SavedPlacesScreen extends StatefulWidget {
  const SavedPlacesScreen({super.key});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  final PassengerHomeController controller =
      Get.find<PassengerHomeController>();

  @override
  void initState() {
    super.initState();
    controller.fetchSavedPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(width: 80.w),
                  const Text(
                    'Saved Places',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: Obx(() {
                  // Loading state
                  if (controller.isLoadingSavedPlaces.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primary3rdColor,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Loading saved places...',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Outfit',
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Empty state
                  if (controller.savedPlaces.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off_outlined,
                            size: 56.sp,
                            color: AppColors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No saved places yet',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Outfit',
                              color: AppColors.headlineText,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Save your frequently visited\nplaces for quick access',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Outfit',
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Saved places list
                  return ListView.separated(
                    itemCount: controller.savedPlaces.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final place = controller.savedPlaces[index];
                      return _PlaceCard(
                        address: place.address,
                        latitude: place.latitude,
                        longitude: place.longitude,
                        onDelete: () {
                          controller.unsavePlace(
                            latitude: place.latitude,
                            longitude: place.longitude,
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final String address;
  final double latitude;
  final double longitude;
  final VoidCallback onDelete;

  const _PlaceCard({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            child: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF5B5BD6),
              size: 26,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Lat: ${latitude.toStringAsFixed(4)}, Lng: ${longitude.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Outfit',
                    color: AppColors.greyLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onDelete,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.delete_outline,
                color: Colors.grey.shade400,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

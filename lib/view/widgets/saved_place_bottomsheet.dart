import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/passenger_home_controller.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

class SavedPlacesBottomSheet extends StatefulWidget {
  final bool isFromLocation;

  const SavedPlacesBottomSheet({super.key, this.isFromLocation = true});

  @override
  State<SavedPlacesBottomSheet> createState() => _SavedPlacesBottomSheetState();
}

class _SavedPlacesBottomSheetState extends State<SavedPlacesBottomSheet> {
  int selectedIndex = 0;
  late PassengerHomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PassengerHomeController>();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose from Saved Places',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Outfit",
                            color: AppColors.headlineText,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    /// Saved Places List
                    Obx(() {
                      // Loading state
                      if (controller.isLoadingSavedPlaces.value) {
                        return Container(
                          padding: EdgeInsets.all(40.r),
                          child: Center(
                            child: Column(
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
                          ),
                        );
                      }

                      // Empty state
                      if (controller.savedPlaces.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(40.r),
                          child: Center(
                            child: Column(
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
                          ),
                        );
                      }

                      // Saved places list
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xffEAF4FF),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.savedPlaces.length,
                          itemBuilder: (context, index) {
                            final place = controller.savedPlaces[index];
                            final isSelected = selectedIndex == index;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary3rdColor
                                      .withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    // Radio button
                                    Container(
                                      width: 24.w,
                                      height: 24.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary3rdColor
                                              : AppColors.grey,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? AppColors.primary3rdColor
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? Icon(
                                        Icons.circle,
                                        size: 12.sp,
                                        color: Colors.white,
                                      )
                                          : null,
                                    ),
                                    SizedBox(width: 12.w),

                                    // Location icon
                                    Icon(
                                      Icons.location_on,
                                      size: 24.sp,
                                      color: AppColors.primary3rdColor,
                                    ),
                                    SizedBox(width: 12.w),

                                    // Address text
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            place.address,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Outfit',
                                              color: AppColors.headlineText,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Lat: ${place.latitude.toStringAsFixed(4)}, Lng: ${place.longitude.toStringAsFixed(4)}',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontFamily: 'Outfit',
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Divider(
                                color: AppColors.white,
                                thickness: 1,
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    SizedBox(height: 24.h),

                    /// Action Buttons
                    Obx(() {
                      if (controller.isLoadingSavedPlaces.value ||
                          controller.savedPlaces.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final canSelect =
                          selectedIndex < controller.savedPlaces.length;

                      return Column(
                        children: [
                          // First gradient button
                          _gradientButton(
                            text: 'Choose as start address',
                            onTap: canSelect
                                ? () {
                              final selectedPlace =
                              controller.savedPlaces[selectedIndex];

                              controller
                                  .useSavedPlaceAsFrom(selectedPlace);
                              Navigator.pop(context);

                           Toast.show(message: 'Pickup location updated',) ;
                            }
                                : null,
                          ),
                          SizedBox(height: 12.h),

                          // Second gradient button
                          _gradientButton(
                            text: 'Choose as ride destination',
                            onTap: canSelect
                                ? () {
                              final selectedPlace =
                              controller.savedPlaces[selectedIndex];

                              controller.useSavedPlaceAsTo(selectedPlace);
                              Navigator.pop(context);

                              Toast.show(message: 'Destination updated',) ;

                            }
                                : null,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _gradientButton({
    required String text,
    required VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: isEnabled
              ? const LinearGradient(
            colors: [
              Color(0xFF45C4D9),
              Color(0xFF6B7FEC),
              Color(0xFFB565D8),
            ],
          )
              : null,
          color: isEnabled ? null : AppColors.grey.withOpacity(0.3),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isEnabled ? Colors.white : AppColors.grey,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "Outfit",
          ),
        ),
      ),
    );
  }
}
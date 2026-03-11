import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_icons.dart';
import 'package:split_ride/utils/app_image.dart';
import 'package:split_ride/model/driver_registration/car_type_model.dart';
import '../../../controllers/passenger_home_controller.dart';
import '../../widgets/location_auto_complete.dart';
import '../../widgets/saved_place_bottomsheet.dart';
import 'drwer_screen.dart';
import 'over_view_screen.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({Key? key}) : super(key: key);

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  late PassengerHomeController passengerHomeController;

  @override
  void initState() {
    super.initState();
    passengerHomeController = Get.put(PassengerHomeController());
  }

  void _showCustomDrawer() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => const CustomDrawer(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              image: DecorationImage(
                image: AssetImage(AppImages.mapImg),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _showCustomDrawer,
                      child: Container(
                        width: 44.w,
                        height: 44.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF45C4D9),
                              Color(0xFF6B7FEC),
                              Color(0xFFB565D8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6B7FEC).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(AppIcons.menuIcon),
                        ),
                      ),
                    ),
                    const Text(
                      'Start Your Ride',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Outfit",
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Color(0xFF2D3748),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            right: 20.w,
            top: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF45C4D9),
                    Color(0xFF6B7FEC),
                    Color(0xFF725bf0),
                    Color(0xFFB565D8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B7FEC).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(20.w),
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Split Your Ride / Private Ride Buttons
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildRideTypeButton('Split Your Ride'),
                          ),
                          // SizedBox(width: 12.w),
                          Expanded(child: _buildRideTypeButton('Private Ride')),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Info Text
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: "Outfit",
                          color: const Color(0xFF6B6B6B),
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'Save up-to  50%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B7FEC),
                            ),
                          ),
                          const TextSpan(
                            text:
                                ' by choosing Split Ride instead of Private Ride. You\'ll share the trip with others going the same way.',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Passengers & Date Time
                    Row(
                      children: [
                        Expanded(child: _buildPassengerSection()),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildDateTimeSection()),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Car Type and Seat Options
                    _buildSectionTitle('Type Of Car & Seats'),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: _buildCarTypeDropdown()),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildSeatOptionDropdown()),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Luggage Type Section
                    _buildSectionTitle('Luggage Type'),
                    SizedBox(height: 12.h),

                    Obx(() {
                      if (passengerHomeController
                          .selectedLuggageItems
                          .isNotEmpty) {
                        return Column(
                          children: [
                            _buildLuggageItemsContainer(),
                            SizedBox(height: 12.h),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    Obx(() {
                      if (passengerHomeController.showLuggageDropdown.value) {
                        return Column(
                          children: [
                            _buildLuggageTypeDropdown(),
                            SizedBox(height: 12.h),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    InkWell(
                      onTap: () =>
                          passengerHomeController.showLuggageDropdownField(),
                      child: Text(
                        'Add Luggage',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5C58EB),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Add this section after the "Add Luggage" button in PassengerHomeScreen
                    // Insert this after line ~380 (after the "Add Luggage" InkWell)

                    // Optional Luggage Notes Field
                    Obx(() {
                      if (passengerHomeController
                          .selectedLuggageItems
                          .isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            Text(
                              'Luggage Notes (Optional)',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3748),
                                fontFamily: "Outfit",
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextField(
                              focusNode: passengerHomeController.luggageFocus,
                              controller:
                                  passengerHomeController.luggageNoteController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText:
                                    'e.g., Handle with care, fragile items',
                                hintStyle: TextStyle(
                                  color: const Color(0xFFB8B8B8),
                                  fontSize: 13.sp,
                                  fontFamily: "Outfit",
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF7FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    SizedBox(height: 16.h),

                    // FROM LOCATION SECTION
                    Row(
                      children: [
                        Text(
                          'From',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Outfit",
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        const Spacer(),
                        Obx(() {
                          final bool isSaved =
                              passengerHomeController.isFromLocationSaved;
                          final hasLocation =
                              passengerHomeController
                                  .fromLocation
                                  .value
                                  .isNotEmpty &&
                              passengerHomeController.fromLatitude.value != 0.0;

                          return Visibility(
                            visible:
                                passengerHomeController
                                    .isSavingFromPlace
                                    .value ==
                                false,
                            replacement: TextButton(
                              onPressed: null,
                              child: Text('Saving...'),
                            ),
                            child: TextButton(
                              onPressed: hasLocation
                                  ? () => passengerHomeController
                                        .toggleSaveFromLocation()
                                  : null,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSaved ? Icons.star : Icons.star_border,
                                    color: hasLocation
                                        ? (isSaved
                                              ? AppColors.orange
                                              : AppColors.primary3rdColor)
                                        : AppColors.grey,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    isSaved ? 'Saved' : 'Save this place',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Outfit",
                                      color: hasLocation
                                          ? (isSaved
                                                ? AppColors.orange
                                                : AppColors.primary3rdColor)
                                          : AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    Obx(() {
                      final position =
                          passengerHomeController.currentLocationBias.value;
                      return passengerHomeController
                              .isLoadingCurrentLocation
                              .value
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7FAFC),
                                borderRadius: BorderRadius.circular(34.r),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary3rdColor,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Getting current location...',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: "Outfit",
                                      color: const Color(0xFF6B6B6B),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : LocationAutocompleteWidget(
                              controller: passengerHomeController
                                  .fromLocationController,
                              focusNode: passengerHomeController.fromLocationControllerFocus,
                              hintText: "Select pickup location",
                              biasLatitude: position?.latitude,
                              biasLongitude: position?.longitude,
                              onLocationSelected: (lat, lng, address) {
                                passengerHomeController.setFromLocation(
                                  location: address,
                                  latitude: lat,
                                  longitude: lng,
                                );
                              },
                            );
                    }),
                    SizedBox(height: 8.h),

                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => const SavedPlacesBottomSheet(
                            isFromLocation: true,
                          ),
                        );
                      },
                      child: Text(
                        'Choose from Saved Places',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary3rdColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // TO LOCATION SECTION
                    Row(
                      children: [
                        Text(
                          'To',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Outfit",
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        const Spacer(),
                        Obx(() {
                          final isSaved =
                              passengerHomeController.isToLocationSaved;
                          final hasLocation =
                              passengerHomeController
                                  .toLocation
                                  .value
                                  .isNotEmpty &&
                              passengerHomeController.toLatitude.value != 0.0;

                          return Visibility(
                            visible:
                                passengerHomeController
                                    .isSavingToPlace
                                    .value ==
                                false,
                            replacement: TextButton(
                              onPressed: null,
                              child: Text('Saving...'),
                            ),
                            child: TextButton(
                              onPressed: hasLocation
                                  ? () => passengerHomeController
                                        .toggleSaveToLocation()
                                  : null,
                              style: TextButton.styleFrom(
                                // padding: EdgeInsets.symmetric(
                                //   horizontal: 12.w,
                                //   vertical: 6.h,
                                // ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSaved ? Icons.star : Icons.star_border,
                                    color: hasLocation
                                        ? (isSaved
                                              ? AppColors.orange
                                              : AppColors.primary3rdColor)
                                        : AppColors.grey,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    isSaved ? 'Saved' : 'Save this place',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Outfit",
                                      color: hasLocation
                                          ? (isSaved
                                                ? AppColors.orange
                                                : AppColors.primary3rdColor)
                                          : AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    Obx(() {
                      final Position? position =
                          passengerHomeController.currentLocationBias.value;
                      return LocationAutocompleteWidget(
                        controller:
                            passengerHomeController.toLocationController,
                        focusNode: passengerHomeController.toLocationControllerFocus,
                        hintText: "Ride Destination",
                        biasLatitude: position?.latitude,
                        biasLongitude: position?.longitude,
                        onLocationSelected: (lat, lng, address) {
                          passengerHomeController.setToLocation(
                            location: address,
                            latitude: lat,
                            longitude: lng,
                          );
                        },
                      );
                    }),
                    SizedBox(height: 8.h),

                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => const SavedPlacesBottomSheet(
                            isFromLocation: false,
                          ),
                        );
                      },
                      child: Text(
                        'Choose from Saved Places',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary3rdColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Note for Driver
                    _buildSectionTitle('Enter note for driver'),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: passengerHomeController.noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Type here',
                        hintStyle: TextStyle(
                          color: const Color(0xFFB8B8B8),
                          fontSize: 14.sp,
                          fontFamily: "Outfit",
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Book Your Ride Button
                    Obx(
                      () => Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF45C4D9),
                              Color(0xFF6B7FEC),
                              Color(0xFFB565D8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6B7FEC).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: passengerHomeController.loader.value
                              ? null
                              : () {
                                  showRideOverview(context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.r),
                            ),
                          ),
                          child: passengerHomeController.loader.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Book Your Ride',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: "Outfit",
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRideTypeButton(String label) {
    return Obx(() {
      bool isSelected = passengerHomeController.selectedRideType.value == label;
      return GestureDetector(
        onTap: () => passengerHomeController.selectRideType(label),
        child: Container(
          height: 48.h,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Color(0xFF45C4D9),
                      Color(0xFF6B7FEC),
                      Color(0xFFB565D8),
                    ],
                  )
                : null,
            color: isSelected ? null : const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.primary3rdColor,
                fontFamily: "Outfit",
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPassengerSection() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passengers',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF6B6B6B),
                fontFamily: "Outfit",
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                _buildCounterButton(
                  Icons.remove,
                  passengerHomeController.decrementPassengers,
                ),
                SizedBox(width: 12.w),
                Text(
                  '${passengerHomeController.passengers.value}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Outfit",
                  ),
                ),
                SizedBox(width: 12.w),
                _buildCounterButton(
                  Icons.add,
                  passengerHomeController.incrementPassengers,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date & Time',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF6B6B6B),
                fontFamily: "Outfit",
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: _selectDateTime,
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20.sp,
                    color: const Color(0xFF6B7FEC),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      passengerHomeController.selectedDateTime.value != null
                          ? '${passengerHomeController.selectedDateTime.value!.day}/${passengerHomeController.selectedDateTime.value!.month}/${passengerHomeController.selectedDateTime.value!.year} ${passengerHomeController.selectedDateTime.value!.hour.toString().padLeft(2, '0')}:${passengerHomeController.selectedDateTime.value!.minute.toString().padLeft(2, '0')}'
                          : 'Date & Time',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Outfit",
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 28.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF45C4D9), Color(0xFF6B7FEC), Color(0xFFB565D8)],
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16.sp),
      ),
    );
  }

  Widget _buildCarTypeDropdown() {
    return Obx(() {
      if (passengerHomeController.loader.value &&
          passengerHomeController.carTypes.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.transparent, width: 1.5),
        ),
        child: DropdownButton<CarTypeModel>(
          value: passengerHomeController.selectedCarType.value,
          isExpanded: true,
          underline: Container(),
          hint: Row(
            children: [
              Icon(
                Icons.directions_car,
                color: const Color(0xFF6B7FEC),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Select Car Type',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Outfit",
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ),
            ],
          ),
          items: passengerHomeController.carTypes.map((CarTypeModel carType) {
            return DropdownMenuItem<CarTypeModel>(
              value: carType,
              child: Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    color: const Color(0xFF6B7FEC),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      carType.name ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Outfit",
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (CarTypeModel? newValue) {
            passengerHomeController.selectCarType(newValue);
          },
          icon: Icon(
            Icons.arrow_drop_down,
            color: const Color(0xFF6B7FEC),
            size: 24.sp,
          ),
          iconSize: 24,
        ),
      );
    });
  }

  Widget _buildSeatOptionDropdown() {
    return Obx(() {
      final availableSeats = passengerHomeController.getAvailableSeats();
      final isDisabled = passengerHomeController.isSeatsDropdownDisabled();

      return Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(34.r),
          border: Border.all(color: Colors.transparent, width: 1.5),
        ),
        child: DropdownButton<int>(
          value: passengerHomeController.selectedSeats?.value,
          isExpanded: true,
          underline: Container(),
          hint: Row(
            children: [
              Icon(
                Icons.airline_seat_recline_normal,
                color: isDisabled ? Colors.grey : const Color(0xFF6B7FEC),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  isDisabled ? 'Select car type first' : 'Select Seats',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Outfit",
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ),
            ],
          ),
          items: availableSeats.isEmpty
              ? null
              : availableSeats.map((int seats) {
                  return DropdownMenuItem<int>(
                    value: seats,
                    child: Row(
                      children: [
                        Icon(
                          Icons.airline_seat_recline_normal,
                          color: const Color(0xFF6B7FEC),
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            '$seats ${seats == 1 ? 'Seat' : 'Seats'}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Outfit",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          onChanged: isDisabled
              ? null
              : (int? newValue) {
                  passengerHomeController.selectSeats(newValue);
                },
          icon: Icon(
            Icons.arrow_drop_down,
            color: isDisabled ? Colors.grey : const Color(0xFF6B7FEC),
            size: 24.sp,
          ),
          iconSize: 24,
        ),
      );
    });
  }

  Widget _buildLuggageTypeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(34.r),
      ),
      child: DropdownButton<String>(
        value: null,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(
          'Select Luggage Type',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "Outfit",
            color: const Color(0xFF6B6B6B),
          ),
        ),

        items:
            [
              'suitcase',
              'duffel_bag',
              'backpack',
              'trolley',
              'handbag',
              'sports_bag',
              'box',
              'golf_bag',
            ].map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value == "duffel_bag"
                      ? "Duffel Bag"
                      : value == "sports_bag"
                      ? "Sports Bag"
                      : value == "golf_bag"
                      ? "Golf Bag"
                      : value.capitalizeFirst ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Outfit",
                  ),
                ),
              );
            }).toList(),
        onChanged: (value) {
          if (value != null) {
            passengerHomeController.addLuggageItem(value);
          }
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFF6B7FEC),
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildLuggageItemsContainer() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: passengerHomeController.selectedLuggageItems.map((value) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF1FF),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value == "duffel_bag"
                    ? "Duffel Bag"
                    : value == "sports_bag"
                    ? "Sports Bag"
                    : value == "golf_bag"
                    ? "Golf Bag"
                    : value.capitalizeFirst ?? '',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Outfit",
                  color: const Color(0xFF2D2F7F),
                ),
              ),
              SizedBox(width: 6.w),
              GestureDetector(
                onTap: () => passengerHomeController.removeLuggageItem(value),
                child: Icon(
                  Icons.close,
                  size: 16.sp,
                  color: const Color(0xFF2D2F7F),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2D3748),
        fontFamily: "Outfit",
      ),
    );
  }

  Future<void> _selectDateTime() async {
    DateTime currentDate =
        passengerHomeController.selectedDateTime.value ?? DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B7FEC),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime;

      if (pickedDate.day == DateTime.now().day &&
          pickedDate.month == DateTime.now().month &&
          pickedDate.year == DateTime.now().year) {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF6B7FEC),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
      } else {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 9, minute: 0),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF6B7FEC),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
      }

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        passengerHomeController.setSelectedDateTime(combinedDateTime);
      }
    }
  }
}

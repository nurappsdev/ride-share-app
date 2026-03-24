import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
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
  const PassengerHomeScreen({super.key});

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
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Map Background
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              image: DecorationImage(
                image: AssetImage(AppImages.mapImg),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Custom App Bar
          _HomeAppBarWidget(onMenuTap: _showCustomDrawer),

          // 3. Current Location Button
          const _CurrentLocationButtonWidget(),

          // 4. Booking Bottom Sheet Form
          const _BookingBottomSheetWidget(),
        ],
      ),
    );
  }
}

// =============================================================================
// EXTRACTED WIDGETS
// =============================================================================

class _HomeAppBarWidget extends StatelessWidget {
  final VoidCallback onMenuTap;

  const _HomeAppBarWidget({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                onTap: onMenuTap,
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
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  padding: EdgeInsets.all(8.r),
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
                  // child: const Icon(
                  //   Icons.notifications_outlined,
                  //   color: Color(0xFF2D3748),
                  //   size: 24,
                  // ),
                  child: SvgPicture.asset('assets/icons/NotificationIcon.svg'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentLocationButtonWidget extends StatelessWidget {
  const _CurrentLocationButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
        child: const Icon(Icons.my_location, color: Colors.white, size: 24),
      ),
    );
  }
}

class _BookingBottomSheetWidget extends StatelessWidget {
  const _BookingBottomSheetWidget();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
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
              const _RideTypeToggleWidget(),
              SizedBox(height: 16.h),
              const _PromoInfoTextWidget(),
              SizedBox(height: 20.h),
              const _PassengerAndDateTimeWidget(),
              SizedBox(height: 16.h),
              const _CarAndSeatSelectionWidget(),
              SizedBox(height: 16.h),
              const _LuggageSelectionWidget(),
              SizedBox(height: 16.h),
              const _FromLocationInputWidget(),
              SizedBox(height: 16.h),
              const _ToLocationInputWidget(),
              SizedBox(height: 16.h),
              const _RideBookingBottomSectionWidget(),
            ],
          ),
        );
      },
    );
  }
}

class _RideTypeToggleWidget extends StatelessWidget {
  const _RideTypeToggleWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassengerHomeController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Expanded(child: _buildButton(controller, 'Split Your Ride')),
          Expanded(child: _buildButton(controller, 'Private Ride')),
        ],
      ),
    );
  }

  Widget _buildButton(PassengerHomeController controller, String label) {
    return Obx(() {
      bool isSelected = controller.selectedRideType.value == label;
      return GestureDetector(
        onTap: () => controller.selectRideType(label),
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
}

class _PromoInfoTextWidget extends StatelessWidget {
  const _PromoInfoTextWidget();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 17.sp,
          fontFamily: "Outfit",
          color: const Color(0xFF6B6B6B),
          height: 1.5,
        ),
        children: const [
          TextSpan(
            text: 'Save up-to  50%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B7FEC),
            ),
          ),
          TextSpan(
            text:
                ' by choosing Split Ride instead of Private Ride. You\'ll share the trip with others going the same way.',
          ),
        ],
      ),
    );
  }
}

class _PassengerAndDateTimeWidget extends StatelessWidget {
  const _PassengerAndDateTimeWidget();

  Future<void> _selectDateTime(
    BuildContext context,
    PassengerHomeController controller,
  ) async {
    DateTime currentDate = controller.selectedDateTime.value ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF6B7FEC),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );

    if (pickedDate != null) {
      bool isToday =
          pickedDate.day == DateTime.now().day &&
          pickedDate.month == DateTime.now().month &&
          pickedDate.year == DateTime.now().year;
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: isToday
            ? TimeOfDay.fromDateTime(DateTime.now())
            : const TimeOfDay(hour: 9, minute: 0),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B7FEC),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        ),
      );

      if (pickedTime != null) {
        controller.setSelectedDateTime(
          DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassengerHomeController>();
    return Row(
      children: [
        Expanded(
          child: Obx(
                () => Column(
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
                Container(
                  height: 50.h, // 🚨 FIX: Force a specific height
                  padding: EdgeInsets.symmetric(horizontal: 16.w), // 🚨 FIX: Horizontal padding only
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8FA),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCounterBtn(
                        Icons.remove,
                        controller.decrementPassengers,
                        const Color(0xFF5C58EB),
                      ),
                      Text(
                        '${controller.passengers.value}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Outfit",
                        ),
                      ),
                      _buildCounterBtn(
                        Icons.add,
                        controller.incrementPassengers,
                        const Color(0xFFBA63FF),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Obx(
                () => Column(
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
                // 🚨 FIX: Wrap the container so the whole card is clickable
                GestureDetector(
                  onTap: () => _selectDateTime(context, controller),
                  child: Container(
                    height: 50.h, // 🚨 FIX: Force the exact same height as the first card
                    padding: EdgeInsets.symmetric(horizontal: 16.w), // 🚨 FIX: Match padding
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/CalendarIcon.svg',
                          height: 20.h, // Keep icon size constrained
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            controller.selectedDateTime.value != null
                                ? '${controller.selectedDateTime.value!.day}/${controller.selectedDateTime.value!.month}/${controller.selectedDateTime.value!.year} ${controller.selectedDateTime.value!.hour.toString().padLeft(2, '0')}:${controller.selectedDateTime.value!.minute.toString().padLeft(2, '0')}'
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCounterBtn(IconData icon, VoidCallback onTap, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          border: Border.all(color: iconColor, width: 3),
          // gradient: LinearGradient(
          //   colors: [Color(0xFF45C4D9), Color(0xFF6B7FEC), Color(0xFFB565D8)],
          // ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 16.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CarAndSeatSelectionWidget extends StatelessWidget {
  const _CarAndSeatSelectionWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassengerHomeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type Of Car & Seats',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
            fontFamily: "Outfit",
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.loader.value && controller.carTypes.isEmpty) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
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
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: DropdownButton<CarTypeModel>(
                    value: controller.selectedCarType.value,
                    isExpanded: true,
                    underline: Container(),
                    hint: Row(
                      children: [
                        // Icon(
                        //   Icons.directions_car,
                        //   color: const Color(0xFF6B7FEC),
                        //   size: 20.sp,
                        // ),
                        SvgPicture.asset('assets/icons/carIcon.svg'),
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
                    items: controller.carTypes
                        .map(
                          (car) => DropdownMenuItem<CarTypeModel>(
                            value: car,
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.directions_car,
                                //   color: const Color(0xFF6B7FEC),
                                //   size: 20.sp,
                                // ),
                                SvgPicture.asset('assets/icons/carIcon.svg'),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    car.name ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Outfit",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: controller.selectCarType,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: const Color(0xFF6B7FEC),
                      size: 24.sp,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Obx(() {
                final availableSeats = controller.getAvailableSeats();
                final isDisabled = controller.isSeatsDropdownDisabled();
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(34.r),
                  ),
                  child: DropdownButton<int>(
                    value: controller.selectedSeats?.value,
                    isExpanded: true,
                    underline: Container(),
                    hint: Row(
                      children: [
                        // Icon(
                        //   Icons.airline_seat_recline_normal,
                        //   color: isDisabled
                        //       ? Colors.grey
                        //       : const Color(0xFF6B7FEC),
                        //   size: 20.sp,
                        // ),
                        SvgPicture.asset('assets/icons/carIcon.svg'),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            isDisabled
                                ? 'Select car type first'
                                : 'Select Seats',
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
                    items: availableSeats
                        .map(
                          (seats) => DropdownMenuItem<int>(
                            value: seats,
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.airline_seat_recline_normal,
                                //   color: const Color(0xFF6B7FEC),
                                //   size: 20.sp,
                                // ),
                                SvgPicture.asset('assets/icons/carIcon.svg'),
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
                          ),
                        )
                        .toList(),
                    onChanged: isDisabled ? null : controller.selectSeats,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: isDisabled ? Colors.grey : const Color(0xFF6B7FEC),
                      size: 24.sp,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}

class _LuggageSelectionWidget extends StatelessWidget {
  const _LuggageSelectionWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassengerHomeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Luggage Type',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
            fontFamily: "Outfit",
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => controller.selectedLuggageItems.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildChips(controller),
                )
              : const SizedBox.shrink(),
        ),
        Obx(
          () => controller.showLuggageDropdown.value
              ? Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildDropdown(controller),
                )
              : const SizedBox.shrink(),
        ),
        InkWell(
          onTap: controller.showLuggageDropdownField,
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
        Obx(
          () => controller.selectedLuggageItems.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
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
                      focusNode: controller.luggageFocus,
                      controller: controller.luggageNoteController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'e.g., Handle with care, fragile items',
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
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildChips(PassengerHomeController controller) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: controller.selectedLuggageItems.map((value) {
        String label = value == "duffel_bag"
            ? "Duffel Bag"
            : value == "sports_bag"
            ? "Sports Bag"
            : value == "golf_bag"
            ? "Golf Bag"
            : value.capitalizeFirst ?? '';
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
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Outfit",
                  color: const Color(0xFF2D2F7F),
                ),
              ),
              SizedBox(width: 6.w),
              GestureDetector(
                onTap: () => controller.removeLuggageItem(value),
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

  Widget _buildDropdown(PassengerHomeController controller) {
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
                ]
                .map(
                  (val) => DropdownMenuItem(
                    value: val,
                    child: Text(
                      val == "duffel_bag"
                          ? "Duffel Bag"
                          : val == "sports_bag"
                          ? "Sports Bag"
                          : val == "golf_bag"
                          ? "Golf Bag"
                          : val.capitalizeFirst ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Outfit",
                      ),
                    ),
                  ),
                )
                .toList(),
        onChanged: (v) {
          if (v != null) controller.addLuggageItem(v);
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFF6B7FEC),
          size: 24.sp,
        ),
      ),
    );
  }
}

class _FromLocationInputWidget extends StatelessWidget {
  const _FromLocationInputWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassengerHomeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              final isSaved = controller.isFromLocationSaved;
              final hasLocation =
                  controller.fromLocation.value.isNotEmpty &&
                  controller.fromLatitude.value != 0.0;
              return controller.isSavingFromPlace.value
                  ? const TextButton(onPressed: null, child: Text('Saving...'))
                  : TextButton(
                      onPressed: hasLocation
                          ? controller.toggleSaveFromLocation
                          : null,
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
                    );
            }),
          ],
        ),
        SizedBox(height: 8.h),
        Obx(() {
          if (controller.isLoadingCurrentLocation.value) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
            );
          }
          return LocationAutocompleteWidget(
            controller: controller.fromLocationController,
            focusNode: controller.fromLocationControllerFocus,
            hintText: "Select pickup location",
            biasLatitude: controller.currentLocationBias.value?.latitude,
            biasLongitude: controller.currentLocationBias.value?.longitude,
            onLocationSelected: (lat, lng, addr) => controller.setFromLocation(
              location: addr,
              latitude: lat,
              longitude: lng,
            ),
          );
        }),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => const SavedPlacesBottomSheet(isFromLocation: true),
          ),
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
      ],
    );
  }
}

class _ToLocationInputWidget extends StatelessWidget {
  const _ToLocationInputWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassengerHomeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              final isSaved = controller.isToLocationSaved;
              final hasLocation =
                  controller.toLocation.value.isNotEmpty &&
                  controller.toLatitude.value != 0.0;
              return controller.isSavingToPlace.value
                  ? const TextButton(onPressed: null, child: Text('Saving...'))
                  : TextButton(
                      onPressed: hasLocation
                          ? controller.toggleSaveToLocation
                          : null,
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
                    );
            }),
          ],
        ),
        SizedBox(height: 8.h),
        Obx(
          () => LocationAutocompleteWidget(
            controller: controller.toLocationController,
            focusNode: controller.toLocationControllerFocus,
            hintText: "Ride Destination",
            biasLatitude: controller.currentLocationBias.value?.latitude,
            biasLongitude: controller.currentLocationBias.value?.longitude,
            onLocationSelected: (lat, lng, addr) => controller.setToLocation(
              location: addr,
              latitude: lat,
              longitude: lng,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => const SavedPlacesBottomSheet(isFromLocation: false),
          ),
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
      ],
    );
  }
}

class _RideBookingBottomSectionWidget extends StatelessWidget {
  const _RideBookingBottomSectionWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassengerHomeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter note for driver',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
            fontFamily: "Outfit",
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller.noteController,
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
        Obx(
          () => Container(
            height: 56.h,
            width: double.infinity,
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
              onPressed: controller.loader.value
                  ? null
                  : () => showRideOverview(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: controller.loader.value
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
    );
  }
}

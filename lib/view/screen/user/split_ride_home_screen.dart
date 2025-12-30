

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_image.dart';

import 'drwer_screen.dart';
import 'over_view_screen.dart';

class SplitRideHomeScreen extends StatefulWidget {
  const SplitRideHomeScreen({Key? key}) : super(key: key);

  @override
  State<SplitRideHomeScreen> createState() => _SplitRideHomeScreenState();
}

class _SplitRideHomeScreenState extends State<SplitRideHomeScreen> {
  int passengers = 2;
  String selectedCarType = 'Sedan';
  String selectedLuggageType = 'Suitcase';
  int luggageCount = 2;
  String selectedRideType = 'Split Your Ride'; // Default to 'Split Your Ride'
  DateTime? selectedDateTime;
  String selectedSeatOption = '4 Seats'; // Default seat option
  String selectedLuggageTypeOption = 'Suitcase'; // Default luggage type for the main item
  List<String> selectedLuggageItems = []; // List to store selected luggage items

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background (Placeholder)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              image: DecorationImage(
                image: AssetImage(
                  "${AppImages.mapImg}"
                ),
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
                    // Menu Button
                    GestureDetector(
                      onTap: () {
                     Get.toNamed(AppRoutes.drawerScreen);
                      },
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
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6B7FEC).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.menu_sharp,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Title
                    const Text(
                      'Start Your Ride',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Outfit",
                        color: Color(0xFF2D3748),
                      ),
                    ),

                    // Notification Button
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildRideTypeButton('Split Your Ride'),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildRideTypeButton('Private Ride'),
                        ),
                      ],
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
                            text: ' by choosing Split Ride instead of Private Ride. You\'ll share the trip with others going the same way.',
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

                    // Luggage Type
                    _buildSectionTitle('Luggage Type'),
                    SizedBox(height: 12.h),
                    _buildLuggageTypeDropdown(),
                    SizedBox(height: 12.h),

                    // Show items when luggage type is selected
                    Visibility(
                      visible: selectedLuggageItems.isNotEmpty,
                      child: _buildLuggageItemsContainer(),
                    ),
                    SizedBox(height: 8.h),



                    // Add More Luggage
                    Text(
                      'Add More Luggage',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: "Outfit",
                        color: Color(0xFF5C58EB),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // F
                    // Star button row
                    Row(
                      children: [
                        Text(
                          'Form',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Outfit",
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            // color: const Color(0xFFFFF9DB), // Light yellow background
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: const Color(0xFF5C58EB), // Amber color for star
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Save this place',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Outfit",
                                  color: const Color(0xFF5C58EB),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Location Dropdown Field
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(34.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: const Color(0xFF6B7FEC),
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: DropdownButton<String>(
                              value: null, // No default value
                              isExpanded: true,
                              underline: Container(), // Remove the default underline
                              hint: Text(
                                'Select Location',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF2D3748),
                                  fontFamily: "Outfit",
                                ),
                              ),
                              items: <String>['Home', 'Office', 'Airport', 'University', 'Shopping Mall', 'Other']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: "Outfit",
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Handle location selection
                                setState(() {
                                  // You can add logic here to handle the selected location
                                });
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: const Color(0xFF6B7FEC),
                                size: 24.sp,
                              ),
                              iconSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Choose from Saved Places
                    InkWell(
                      onTap:(){
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const SavedPlacesBottomSheet(),
                        );

                      },
                      child: Text(
                        'Choose from Saved Places',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: "Outfit",
                          color: Color(0xFF5C58EB),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
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
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            // color: const Color(0xFFFFF9DB), // Light yellow background
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: const Color(0xFF5C58EB), // Amber color for star
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Save this place',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Outfit",
                                  color: const Color(0xFF5C58EB),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Location Dropdown Field
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(34.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: const Color(0xFF6B7FEC),
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: DropdownButton<String>(
                              value: null, // No default value
                              isExpanded: true,
                              underline: Container(), // Remove the default underline
                              hint: Text(
                                'Select Location',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF2D3748),
                                  fontFamily: "Outfit",
                                ),
                              ),
                              items: <String>['Home', 'Office', 'Airport', 'University', 'Shopping Mall', 'Other']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: "Outfit",
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Handle location selection
                                setState(() {
                                  // You can add logic here to handle the selected location
                                });
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: const Color(0xFF6B7FEC),
                                size: 24.sp,
                              ),
                              iconSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Choose from Saved Places
                    InkWell(
                      onTap:(){
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const SavedPlacesBottomSheet(),
                        );
                      },
                      child: Text(
                        'Choose from Saved Places',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: "Outfit",
                          color: Color(0xFF5C58EB),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Note for Driver
                    _buildSectionTitle('Enter note for driver'),
                    SizedBox(height: 8.h),
                    TextField(
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
                    Container(
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
                        onPressed: () {
                          showRideOverview(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                        ),
                        child: Text(
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
    bool isSelected = selectedRideType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          // Select the clicked option, switching from the other one
          selectedRideType = label;
        });
      },
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
              color: isSelected ? Colors.white :  AppColors.primary3rdColor,
              fontFamily: "Outfit",
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerSection() {
    return Container(
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
              _buildCounterButton(Icons.remove, () {
                if (passengers > 1) setState(() => passengers--);
              }),
              SizedBox(width: 12.w),
              Text(
                '$passengers',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Outfit",
                ),
              ),
              SizedBox(width: 12.w),
              _buildCounterButton(Icons.add, () {
                setState(() => passengers++);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Container(
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
                Text(
                  selectedDateTime != null
                      ? '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} ${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}'
                      : 'Date & Time',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Outfit",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 28.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF45C4D9),
              Color(0xFF6B7FEC),
              Color(0xFFB565D8),
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16.sp),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2D3748),
        fontFamily: "Outfit",
      ),
    );
  }

  Widget _buildCarTypeOption(String label, IconData icon) {
    final isSelected = selectedCarType == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCarType = label),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF6B7FEC) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF6B7FEC),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Outfit",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarTypeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Colors.transparent,
          width: 1.5,
        ),
      ),
      child: DropdownButton<String>(
        value: selectedCarType,
        isExpanded: true,
        underline: Container(), // Remove the default underline
        hint: Text(
          'Select Car Type',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "Outfit",
            color: const Color(0xFF6B6B6B),
          ),
        ),
        items: <String>['Sedan', '4 Seater', 'SUV', 'Luxury', 'Van']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(
                  value == 'Sedan' || value == '4 Seater' ? Icons.directions_car :
                        value == 'SUV' ? Icons.local_shipping :
                        value == 'Luxury' ? Icons.star : Icons.airline_seat_recline_normal,
                  color: const Color(0xFF6B7FEC),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Outfit",
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedCarType = newValue;
            });
          }
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFF6B7FEC),
          size: 24.sp,
        ),
        iconSize: 24,
      ),
    );
  }

  Widget _buildSeatOptionDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(34.r),
        border: Border.all(
          color: Colors.transparent,
          width: 1.5,
        ),
      ),
      child: DropdownButton<String>(
        value: selectedSeatOption,
        isExpanded: true,
        underline: Container(), // Remove the default underline
        hint: Text(
          'Seats',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "Outfit",
            color: const Color(0xFF6B6B6B),
          ),
        ),
        items: <String>['4 Seats', '6 Seats', '7 Seats', 'More than 7']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(
                  Icons.airline_seat_recline_normal,
                  color: const Color(0xFF6B7FEC),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Outfit",
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedSeatOption = newValue;
            });
          }
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFF6B7FEC),
          size: 24.sp,
        ),
        iconSize: 24,
      ),
    );
  }

  Widget _buildLuggageTypeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(34.r),
      ),
      child: DropdownButton<String>(
        value: selectedLuggageTypeOption,
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
        items: ['Suitcase', 'Handcarry', 'Backpack', 'Box', 'Bag']
            .map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Outfit",
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            selectedLuggageTypeOption = value;
            if (!selectedLuggageItems.contains(value)) {
              selectedLuggageItems.add(value);
            }
          });
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFF6B7FEC),
          size: 24.sp,
        ),
      ),
    );
  }



  Widget _buildLuggageOption(String label, IconData icon) {
    final isSelected = selectedLuggageType == label;
    return GestureDetector(
      onTap: () => setState(() => selectedLuggageType = label),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF6B7FEC) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF6B7FEC),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Outfit",
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAddButton() {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.add,
        color: const Color(0xFF6B7FEC),
        size: 20.sp,
      ),
    );
  }


  Widget _buildVerticalItem(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF6B7FEC),
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: "Outfit",
              color: const Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 1.h,
      width: double.infinity,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildLuggageItemsContainer() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: selectedLuggageItems.map((item) {
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
                item,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Outfit",
                  color: const Color(0xFF2D2F7F),
                ),
              ),
              SizedBox(width: 6.w),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLuggageItems.remove(item);
                  });
                },
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


  Widget _buildLuggageItemWithClose(String item, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            item == 'Suitcase' ? Icons.luggage :
            item == 'Backpack' ? Icons.backpack :
            item == 'Box' ? Icons.inventory :
            item == 'Bag' ? Icons.shopping_bag : Icons.help_outline,
            color: const Color(0xFF6B7FEC),
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Outfit",
                color: const Color(0xFF2D3748),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              size: 16.sp,
              color: const Color(0xFF6B7FEC),
            ),
            onPressed: () => _removeLuggageItem(index),
          ),
        ],
      ),
    );
  }

  void _removeLuggageItem(int index) {
    setState(() {
      selectedLuggageItems.removeAt(index);
    });
  }


  Future<void> _selectDateTime() async {
    // Get the current date or use today if no date is selected
    DateTime currentDate = selectedDateTime ?? DateTime.now();

    // Show date picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Allow selecting dates up to 1 year ahead
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B7FEC), // Primary color for selected date
              onPrimary: Colors.white, // Text color for selected date
              surface: Colors.white, // Background color for the dialog
              onSurface: Colors.black, // Text color for the dialog
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime;

      // If the selected date is today, use the current time as initial time
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
                  primary: Color(0xFF6B7FEC), // Primary color for selected time
                  onPrimary: Colors.white, // Text color for selected time
                  surface: Colors.white, // Background color for the dialog
                  onSurface: Colors.black, // Text color for the dialog
                ),
              ),
              child: child!,
            );
          },
        );
      } else {
        // For future dates, allow selecting any time
        pickedTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 9, minute: 0), // Default to 9 AM
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF6B7FEC), // Primary color for selected time
                  onPrimary: Colors.white, // Text color for selected time
                  surface: Colors.white, // Background color for the dialog
                  onSurface: Colors.black, // Text color for the dialog
                ),
              ),
              child: child!,
            );
          },
        );
      }

      if (pickedTime != null) {
        // Combine the selected date and time
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDateTime = combinedDateTime;
        });
      }
    }
  }
}









class SavedPlacesBottomSheet extends StatefulWidget {
  const SavedPlacesBottomSheet({super.key});

  @override
  State<SavedPlacesBottomSheet> createState() => _SavedPlacesBottomSheetState();
}

class _SavedPlacesBottomSheetState extends State<SavedPlacesBottomSheet> {
  int selectedIndex = 0;

  final List<String> locations = [
    'F2 Square',
    'Location 2',
    'Location 3',
    'Location 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin:
        EdgeInsets.all(16.r),
        padding:  EdgeInsets.all(16.r),
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
                        const Text(
                          'Choose from Saved Places',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Outfit"
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Locations Container with scroll
                    Container(
                      padding:  EdgeInsets.symmetric(vertical: 8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffEAF4FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          locations.length,
                              (index) => RadioListTile<int>(
                            value: index,
                            groupValue: selectedIndex,
                            activeColor: Colors.blue,
                            title: Text(
                              locations[index],
                              style:  TextStyle(fontSize: 14.sp),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedIndex = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                     SizedBox(height: 20.h),

                    /// Buttons
                    _gradientButton(
                      text: 'Choose as start address',
                      onTap: () {},
                    ),
                     SizedBox(height: 12.h),
                    _gradientButton(
                      text: 'Choose as ride destination',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Gradient Button Widget
  Widget _gradientButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF45C4D9),
              Color(0xFF6B7FEC),
              Color(0xFFB565D8),
            ],
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
              fontFamily: "Outfit"
          ),
        ),
      ),
    );
  }
}

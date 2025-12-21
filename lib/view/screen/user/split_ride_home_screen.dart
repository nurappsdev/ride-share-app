

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  String? selectedRideType; // null means unselected, 'Split Your Ride' or 'Private Ride'

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
                image: NetworkImage(
                  'https://api.mapbox.com/styles/v1/mapbox/light-v10/static/-73.9857,40.7484,12,0/400x800@2x?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw',
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
                        Scaffold.of(context).openDrawer();
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
                          fontSize: 13.sp,
                          fontFamily: "Outfit",
                          color: const Color(0xFF6B6B6B),
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'Save up-to '),
                          TextSpan(
                            text: '50%',
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

                    // Car Type
                    _buildSectionTitle('Type Of Car'),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: _buildCarTypeOption('Sedan', Icons.directions_car)),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildCarTypeOption('4 Seater', Icons.airline_seat_recline_normal)),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Luggage Type
                    _buildSectionTitle('Luggage Type'),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: _buildLuggageOption('Suitcase', Icons.luggage)),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _buildLuggageCounter()),
                              SizedBox(width: 8.w),
                              _buildAddButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Add More Luggage
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(
                        'Add More Luggage',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: "Outfit",
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7FEC),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // From Location
                    _buildLocationField('From', 'F2 Square', true),
                    SizedBox(height: 12.h),

                    // Choose from Saved Places
                    _buildSavedPlacesButton(),
                    SizedBox(height: 16.h),

                    // To Location
                    _buildLocationField('To', 'Ride Destination', false),
                    SizedBox(height: 12.h),

                    // Choose from Saved Places
                    _buildSavedPlacesButton(),
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
                        onPressed: () {},
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
          // If the button is already selected, deselect it (toggle off)
          // If the button is not selected, select it (toggle on)
          if (selectedRideType == label) {
            selectedRideType = null;
          } else {
            selectedRideType = label;
          }
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
              color: isSelected ? Colors.white : const Color(0xFF6B6B6B),
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
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 20.sp,
                color: const Color(0xFF6B7FEC),
              ),
              SizedBox(width: 8.w),
              Text(
                'Date & Time',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Outfit",
                ),
              ),
            ],
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

  Widget _buildLuggageCounter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$luggageCount',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: "Outfit",
            ),
          ),
        ],
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

  Widget _buildLocationField(String label, String placeholder, bool isFrom) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
            fontFamily: "Outfit",
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12.r),
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
                child: Text(
                  placeholder,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF2D3748),
                    fontFamily: "Outfit",
                  ),
                ),
              ),
              Icon(
                Icons.bookmark_outline,
                color: const Color(0xFF6B7FEC),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavedPlacesButton() {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.bookmark_outline, size: 18),
      label: Text(
        'Choose from Saved Places',
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: "Outfit",
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF6B7FEC),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
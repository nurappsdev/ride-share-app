import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:split_ride/view/screen/user/rides/my_ride_screen.dart';

import 'user/home/personal_info_screen.dart';
import 'user/split_ride_home_screen.dart';

class AllBottomBar extends StatefulWidget {
  const AllBottomBar({super.key});

  @override
  State<AllBottomBar> createState() => _AllBottomBarState();
}

class _AllBottomBarState extends State<AllBottomBar> {
  int _selectedIndex = 0;

  static final List _screens = [
    const SplitRideHomeScreen(),
    const MyRidesScreen(),
    const PersonalInfoScreen(),
  ];

  void _itemIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: _screens.elementAt(_selectedIndex),
            ),
            // Custom Bottom Navigation Bar
            Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Tab
                  _buildNavItem(
                    index: 0,
                    label: 'Home',
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                  ),
                  // Rides Tab
                  _buildNavItem(
                    index: 1,
                    label: 'Rides',
                    icon: Icons.directions_car_outlined,
                    selectedIcon: Icons.directions_car,
                  ),
                  // Account Tab
                  _buildNavItem(
                    index: 2,
                    label: 'Account',
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _itemIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20.w : 12.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF45C4D9),
              Color(0xFF6B7FEC),
              Color(0xFF725bf0),
              Color(0xFFB565D8),
            ],
          )
              : null,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? Colors.white : const Color(0xFF6B6B6B),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF6B6B6B),
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontFamily: "Outfit",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF45C4D9),
            Color(0xFF6B7FEC),
            Color(0xFFB565D8),
          ],
        ),
      ),
      child: const Center(
        child: Text(
          'Home Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}



class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'Account Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ),
    );
  }
}
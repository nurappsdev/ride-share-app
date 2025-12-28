


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close the drawer when clicking outside of it
        Navigator.of(context).pop();
      },
      child: Drawer(
        child: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF87CEEB),
                    Color(0xFFB19CD9),
                    Color(0xFF9B7EBD),
                  ],
                ),
              ),
            ),
            // Content - prevent closing when clicking inside the drawer
            Container(
              margin: EdgeInsets.only(right: 70.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                children: [
                  // Profile Section
                  Container(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6ECFF),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundColor: Colors.purple[100],
                                child: Icon(
                                  Icons.person,
                                  color: const Color(0xFF6552EC),
                                  size: 30.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kimmy Natasa',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF50565A),
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Container(
                                    child: ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        colors: [
                                          Color(0xFF57D8E9),
                                          Color(0xFF5A9BEA),
                                        ],
                                      ).createShader(bounds),
                                      child: Text(
                                        'Verified',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Outfit',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Menu Items
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Do nothing - prevent the parent GestureDetector from triggering
                        // This ensures that taps on the drawer content don't close the drawer
                      },
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        children: [
                          _buildMenuItem(
                            icon: Icons.person_outline,
                            title: 'Personal Info',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.lock_outline,
                            title: 'Login & Security',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.description_outlined,
                            title: 'Terms & Conditions',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.shield_outlined,
                            title: 'Privacy',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.bookmark_outline,
                            title: 'Saved Places',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.language_outlined,
                            title: 'Language',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Action Buttons
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        _buildActionButton(
                          icon: Icons.logout,
                          title: 'Log out',
                          color: Colors.red,
                          onTap: () {},
                        ),
                        SizedBox(height: 12.h),
                        _buildActionButton(
                          icon: Icons.delete_outline,
                          title: 'Delete account',
                          color: Colors.red,
                          onTap: () {},
                        ),
                        SizedBox(height: 20.h),
                      ],
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF6552EC),
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          color: const Color(0xFF50565A),
          fontWeight: FontWeight.w500,
          fontFamily: 'Outfit',
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              color: color,
              fontWeight: FontWeight.w500,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }
}
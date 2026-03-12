import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/passenger_drawer_controller.dart';
import 'package:split_ride/helpers/app_url.dart';

import '../../../routes/app_routes.dart';
import 'rides/save_places_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late PassengerDrawerController passengerDrawerController;

  @override
  void initState() {
    super.initState();
    passengerDrawerController = Get.put(PassengerDrawerController());
    // Refresh user data when drawer opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      passengerDrawerController.refreshUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🔥 TRANSPARENT + BLUR BACKGROUND
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withValues(alpha: 0.05)),
          ),
        ),

        // 🔥 DRAWER PANEL
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.78,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: _drawerContent(context, passengerDrawerController),
          ),
        ),
      ],
    );
  }

  Widget _drawerContent(BuildContext context, PassengerDrawerController passengerDrawerController) {
    return Material(
      // Add Material widget as ancestor for ListTile
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(height: 50.h),

          // Profile Card
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Obx(() {
              if (passengerDrawerController.isLoadingUser.value) {
                // Loading state
                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6ECFF),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26.r,
                        backgroundColor: Colors.purple[100],
                        child: Icon(
                          Icons.person,
                          color: const Color(0xFF6552EC),
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120.w,
                            height: 18.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6552EC).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            width: 80.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6552EC).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              // User data loaded
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6ECFF),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    // Profile Image or Avatar
                    CircleAvatar(
                      radius: 26.r,
                      backgroundColor: Colors.purple[100],
                      backgroundImage: passengerDrawerController.userProfileImage != null &&
                              passengerDrawerController.userProfileImage!.isNotEmpty
                          ? NetworkImage('${AppUrl.imageServeUrl}/${passengerDrawerController.userProfileImage}')
                          : null,
                      child: passengerDrawerController.userProfileImage == null ||
                              passengerDrawerController.userProfileImage!.isEmpty
                          ? Icon(
                              Icons.person,
                              color: const Color(0xFF6552EC),
                              size: 28.sp,
                            )
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            passengerDrawerController.userName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3748),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF45C4D9), Color(0xFF6B7FEC)],
                            ).createShader(bounds),
                            child: Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          const Divider(),

          // Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.personalInfoScreen,
                      preventDuplicates: false,
                    );
                  },
                  child: _menu(Icons.person_outline, "Personal Info"),
                ),
                // _menu(Icons.lock_outline, "Login & Security"),
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.privacyPolicyAllScreen,
                      preventDuplicates: false,
                    );
                  },
                  child: _menu(
                    Icons.description_outlined,
                    "Terms & Conditions",
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.privacyPolicyAllScreen,
                      preventDuplicates: false,
                    );
                  },
                  child: _menu(Icons.shield_outlined, "Privacy"),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.helpAndSupportScreen,
                      preventDuplicates: false,
                    );
                  },
                  child: _menu(Icons.help_outline, "Help & Support"),
                ),
                InkWell(
                    onTap: (){
                      Get.to(()=>SavedPlacesScreen());
                    },
                    child: _menu(Icons.bookmark_outline, "Saved Places")),
                // _menu(Icons.language_outlined, "Language"),
              ],
            ),
          ),

          // Bottom Actions
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _showVerificationDialog(context);
                  },
                  child: _action(Icons.logout, "Log out"),
                ),
                SizedBox(height: 12.h),
                InkWell(
                  onTap: () {
                    _showDeleteAccountDialog(context);
                  },
                  child: _action(Icons.delete_outline, "Delete account"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6552EC)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Outfit',
        ),
      ),
    );
  }

  Widget _action(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.red),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.sp,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

void _showVerificationDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Verification",
    barrierColor: Colors.black.withOpacity(0.25),
    // soft dim
    transitionDuration: const Duration(milliseconds: 10),
    pageBuilder: (_, __, ___) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Center(child: _logoutDialog(context)),
      );
    },
  );
}

Widget _logoutDialog(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(16.r),
    child: Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Logout Icon
          Container(
            height: 70.w,
            width: 70.w,
            decoration: const BoxDecoration(
              color: Color(0xFFFF3B30),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.logout_rounded, color: Colors.white, size: 34.sp),
          ),

          SizedBox(height: 16.h),

          /// Title
          Text(
            'Logout?',
            style: TextStyle(
              fontSize: 20.sp,

              decoration: TextDecoration.none,
              fontWeight: FontWeight.w600,
              fontFamily: 'Outfit',

              color: const Color(0xFF2B2B2B),
            ),
          ),

          SizedBox(height: 6.h),

          /// Subtitle
          Text(
            'Are you sure you want to log out of SplitRide?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,

              decoration: TextDecoration.none,
              fontFamily: 'Outfit',
              color: const Color(0xFF8A8A8A),
            ),
          ),

          SizedBox(height: 22.h),

          /// Buttons
          Row(
            children: [
              /// Cancel
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF45C4D9),
                          Color(0xFF6B7FEC),
                          Color(0xFF5c58eb),
                          Color(0xFFB565D8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        decoration: TextDecoration.none,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              /// Logout
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.find<PassengerDrawerController>()
                        .handlePassengerLogout();

                    /// logout logic
                  },
                  child: Container(
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3B30),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Text(
                      'Logout',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,

                        decoration: TextDecoration.none,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _showDeleteAccountDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Delete Account",
    barrierColor: Colors.black.withOpacity(0.25),
    transitionDuration: const Duration(milliseconds: 10),
    pageBuilder: (_, __, ___) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Center(child: _deleteAccountDialog(context)),
      );
    },
  );
}

Widget _deleteAccountDialog(BuildContext context) {
  return DeleteAccountDialogContent();
}

class DeleteAccountDialogContent extends StatefulWidget {
  const DeleteAccountDialogContent({Key? key}) : super(key: key);

  @override
  State<DeleteAccountDialogContent> createState() =>
      _DeleteAccountDialogContentState();
}

class _DeleteAccountDialogContentState
    extends State<DeleteAccountDialogContent> {
  String selectedReason = 'no-longer-using';

  final List<Map<String, String>> reasons = [
    {'id': 'no-longer-using', 'label': 'I am no longer using my account'},
    {'id': 'not-pay-well', 'label': "The service doesn't pay well"},
    {'id': 'change-number', 'label': 'I want to change my phone number'},
    {
      'id': 'dont-understand',
      'label': "I don't understand how to use the service",
    },
    {'id': 'not-available', 'label': 'The service is not available in my city'},
    {'id': 'other', 'label': 'Other'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          padding: EdgeInsets.all(32.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Delete Icon
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 40.r,
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                Text(
                  "We're really sorry\nto see you go",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                    height: 1.3,
                    fontFamily: 'Outfit',
                  ),
                ),
                SizedBox(height: 8),

                // Subtitle
                Text(
                  'Please share the reason you are leaving',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Outfit',
                  ),
                ),
                SizedBox(height: 20.h),

                // Radio Options
                ...reasons.map((reason) {
                  final isSelected = selectedReason == reason['id'];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedReason = reason['id']!;
                        });
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            // Custom Radio Button
                            Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? Color(0xFF3B82F6)
                                      : Color(0xFFD1D5DB),
                                  width: 2.w,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 12.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Color(0xFF3B82F6)
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                reason['label']!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: isSelected
                                      ? Color(0xFF111827)
                                      : Color(0xFF6B7280),
                                  fontWeight: isSelected
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF45C4D9),
                              Color(0xFF6B7FEC),
                              Color(0xFF5c58eb),
                              Color(0xFFB565D8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            borderRadius: BorderRadius.circular(28),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),

                    // Delete Account Button
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          ),
                          borderRadius: BorderRadius.circular(28.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Account deleted successfully',
                                    style: TextStyle(fontFamily: 'Outfit'),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(28),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.r),
                                child: Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

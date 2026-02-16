import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class VerificationDialog {
  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Verification",
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: const Duration(milliseconds: 10),
      pageBuilder: (_, __, ___) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: const Center(
            child: _VerificationContent(),
          ),
        );
      },
    );
  }
}

class _VerificationContent extends StatelessWidget {
  const _VerificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF45C4D9),
                    Color(0xFF6B7FEC),
                    Color(0xFF5C58EB),
                    Color(0xFFB565D8),
                  ],
                ),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
                weight: 4,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            const Text(
              "You're Verified!",
              style: TextStyle(
                fontSize: 28,
                fontFamily: "Outfit",
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
                letterSpacing: -0.5,
                decoration: TextDecoration.none,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              'You have successfully verified your account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Outfit",
                color: Colors.grey[600],
                height: 1.5,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),

            const SizedBox(height: 24),

            // Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF45C4D9),
                    Color(0xFF6B7FEC),
                    Color(0xFF5C58EB),
                    Color(0xFFB565D8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B7FEC).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.allBottomBar,
                    preventDuplicates: false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Start Enjoying Split Ride',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "Outfit",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

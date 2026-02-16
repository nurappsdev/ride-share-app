import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/get_storage.dart';
import 'package:split_ride/helpers/user_enum.dart';
import 'package:split_ride/routes/app_routes.dart';

import '../../helpers/secured_storage.dart';
import '../../utils/app_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () async {
      final String? token = await SecureStorageService().read(
        AppConstants.accessToken,
      );
      final String currentRole =
          GetStorageModel().read(AppConstants.currentRole) ?? '';
      if (token != null && token.isNotEmpty) {
        if (currentRole == UserRole.user.name) {

          Get.offAllNamed(AppRoutes.allBottomBar);
        } else if (currentRole == UserRole.provider.name) {
          Get.offAllNamed(AppRoutes.driverAvailableScreen);
        }
      } else {
        Get.toNamed(AppRoutes.roleScreen, preventDuplicates: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/1.png',
          fit: BoxFit.cover, // পুরো screen fill করবে
        ),
      ),
    );
  }
}

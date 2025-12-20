import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_ride/routes/app_routes.dart';

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
    Timer(Duration(seconds: 3),(){

      Get.toNamed(AppRoutes.roleScreen,preventDuplicates: false);
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


import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:split_ride/routes/app_routes.dart';

import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {



  File? cnicFront;
  File? cnicBack;
  File? licenseFront;
  File? licenseBack;
  File? carPapers;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        switch (type) {
          case 'cnicFront':
            cnicFront = File(image.path);
            break;
          case 'cnicBack':
            cnicBack = File(image.path);
            break;
          case 'licenseFront':
            licenseFront = File(image.path);
            break;
          case 'licenseBack':
            licenseBack = File(image.path);
            break;
          case 'carPapers':
            carPapers = File(image.path);
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Column(
                children: [
                  Image.asset(
                    '${AppImages.appLogo2}',
                    height: 45.h,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Upload Required Documents',textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Outfit",
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Upload the required documents to verify your account.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Outfit",
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Upload CNIC
                          const Text(
                            'Upload CNIC',

                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildUploadBox(
                                  'Upload image of CNIC\n(Front side)',
                                  cnicFront,
                                      () => _pickImage('cnicFront'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildUploadBox(
                                  'Upload image of CNIC\n(back side)',
                                  cnicBack,
                                      () => _pickImage('cnicBack'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Upload Driving License
                          const Text(
                            'Upload Driving License',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildUploadBox(
                                  'Upload image of driving\nlicense (front side)',
                                  licenseFront,
                                      () => _pickImage('licenseFront'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildUploadBox(
                                  'Upload image of driving\nlicense (back side)',
                                  licenseBack,
                                      () => _pickImage('licenseBack'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Upload Car Papers
                          const Text(
                            'Upload Car Papers',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildUploadBox(
                            'Upload image of your driving license',
                            carPapers,
                                () => _pickImage('carPapers'),
                            isFullWidth: true,
                          ),
                          const SizedBox(height: 40),

                          // Submit Button
                          CustomButtonCommon(title:  "Submit", onpress: (){_showVerificationDialog(context);},useGradient: true,),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }

  void _showVerificationDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Verification",
      barrierColor: Colors.black.withOpacity(0.25), // soft dim
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: Center(
            child: _verificationCard(context),
          ),
        );
      },
    );
  }

  Widget _verificationCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Gradient Success Icon
          Container(
            width: 100.w,
            height: 100.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF45C4D9),
                  Color(0xFF6B7FEC),
                  Color(0xFFB565D8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              Icons.check,
              size: 60.sp,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 24.h),

          Text(
            "Driver Registration Received",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontFamily: "Outfit",
              fontWeight: FontWeight.w700,

              decoration: TextDecoration.none,
              color: const Color(0xFF2D3748),
            ),
          ),

          SizedBox(height: 12.h),

          Text(
            "We will review the provided information and get back to you after verification",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: "Outfit",
              color: Colors.grey[600],
              height: 1.5,

              decoration: TextDecoration.none,
            ),
          ),

          SizedBox(height: 28.h),

          /// Button
          CustomButtonCommon(title:  "Go Back to Homescreen", onpress: (){Get.toNamed(AppRoutes.driverAvailableScreen);},useGradient: true,),
        ],
      ),
    );
  }

  Widget _buildUploadBox(String label, File? image, VoidCallback onTap,
      {bool isFullWidth = false}) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DottedBorderPainter(
          color:  AppColors.primary3rdColor,
          strokeWidth: 2,
          gap: 5,
        ),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xfff9f0ff),
          ),
          child: image != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              image,
              fit: BoxFit.cover,
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                color: Color(0xFFba63ff),
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "Outfit",
                  color: Color(0xFFadadad),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const radius = 12.0;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));

    _drawDottedRRect(canvas, rrect, paint);
  }

  void _drawDottedRRect(Canvas canvas, RRect rrect, Paint paint) {
    final path = Path()..addRRect(rrect);
    final metric = path.computeMetrics().first;
    double distance = 0.0;

    while (distance < metric.length) {
      final start = metric.getTangentForOffset(distance)!.position;
      distance += gap;
      final end = metric.getTangentForOffset(distance)!.position;
      canvas.drawLine(start, end, paint);
      distance += gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
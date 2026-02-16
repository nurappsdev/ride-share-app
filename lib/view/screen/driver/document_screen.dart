import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/auth_controller/driver_profile_reistration_controller.dart';
import 'package:split_ride/helpers/context_extentions.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/custom_loading.dart';
import '../../../controllers/auth_controller/driver_document_upload_controller.dart';
import '../../../utils/utils.dart';
import '../../widgets/widgets.dart';

class DriverDocumentRegistrationScreen extends StatelessWidget {
  DriverDocumentRegistrationScreen({super.key});

  final DriverDocumentUploadController driverDocumentController = Get.put(
    DriverDocumentUploadController(),
  );
  final DriverProfileRegistrationController
  driverProfileRegistrationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Image.asset(AppImages.appLogo2, height: 45.h),
              SizedBox(height: 40.h),

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
                            'Upload Required Documents',
                            textAlign: TextAlign.center,
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

                          // CNIC Section
                          _buildSectionTitle('Upload CNIC'),
                          const SizedBox(height: 12),
                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: _buildUploadBox(
                                    context,
                                    'Upload image of CNIC\n(Front side)',
                                    driverDocumentController.cnicFront.value,
                                    () => driverDocumentController.pickImage(
                                      'cnicFront',
                                    ),
                                    isUploading:
                                        driverDocumentController
                                            .uploadingStates['cnicFront'] ??
                                        false,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildUploadBox(
                                    context,
                                    'Upload image of CNIC\n(back side)',
                                    driverDocumentController.cnicBack.value,
                                    () => driverDocumentController.pickImage(
                                      'cnicBack',
                                    ),
                                    isUploading:
                                        driverDocumentController
                                            .uploadingStates['cnicBack'] ??
                                        false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // License Section
                          _buildSectionTitle('Upload Driving License'),
                          const SizedBox(height: 12),
                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: _buildUploadBox(
                                    context,
                                    'Upload image of driving\nlicense (front side)',
                                    driverDocumentController.licenseFront.value,
                                    () => driverDocumentController.pickImage(
                                      'licenseFront',
                                    ),
                                    isUploading:
                                        driverDocumentController
                                            .uploadingStates['licenseFront'] ??
                                        false,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildUploadBox(
                                    context,
                                    'Upload image of driving\nlicense (back side)',
                                    driverDocumentController.licenseBack.value,
                                    () => driverDocumentController.pickImage(
                                      'licenseBack',
                                    ),
                                    isUploading:
                                        driverDocumentController
                                            .uploadingStates['licenseBack'] ??
                                        false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Car Papers Section
                          _buildSectionTitle('Upload Car Papers'),
                          const SizedBox(height: 12),

                          // Display all car papers
                          Obx(
                            () => Wrap(
                              children: [
                                ...driverDocumentController.carPapers
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12.h),
                                        child: Stack(
                                          children: [
                                            _buildUploadBox(
                                              context,
                                              'Car Paper ${entry.key + 1}',
                                              entry.value,
                                              () {},
                                              isFullWidth: true,
                                              isUploading:
                                                  driverDocumentController
                                                      .uploadingStates['carPapers_${entry.key}'] ??
                                                  false,
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    driverDocumentController
                                                        .removeCarPaper(
                                                          entry.key,
                                                        ),
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        blurRadius: 4,
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                    .toList(),

                                // Add more button
                                _buildUploadBox(
                                  context,
                                  'Upload image of your other relevant document',
                                  null,
                                  () => driverDocumentController.pickImage(
                                    'carPapers',
                                  ),
                                  isFullWidth: true,
                                  isAddButton: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Submit Button
                          Obx(
                            () =>
                                (driverProfileRegistrationController
                                        .isSubmitting
                                        .value ||
                                    driverDocumentController.isUploading.value)
                                ? const Center(child: CustomLoading())
                                : CustomButtonCommon(
                                    title: "Submit",
                                    onpress: () => _handleSubmit(context),
                                    useGradient: true,
                                  ),
                          ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: "Outfit",
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  /// Handle final submission
  void _handleSubmit(BuildContext context) async {
    // Validate documents
    if (!driverDocumentController.validateDocuments()) {
      return;
    }

    // Get document data
    final Map<String, dynamic> documentData = driverDocumentController
        .getDocumentData();

    // Submit to API
    final bool isRegistered = await driverProfileRegistrationController
        .submitDriverRegistration(documentData);

    // Show success dialog if submission was successful
    if (driverProfileRegistrationController.isSubmitting.value == false &&
        isRegistered) {
      _showVerificationDialog(context);
    }
  }

  void _showVerificationDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Verification",
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Center(child: _verificationCard(context)),
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
            child: Icon(Icons.check, size: 60.sp, color: Colors.white),
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
          CustomButtonCommon(
            title: "Go Back to Homescreen",
            onpress: () => Get.offAllNamed(AppRoutes.driverAvailableScreen),
            useGradient: true,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(
    BuildContext context,
    String label,
    File? image,
    VoidCallback onTap, {
    bool isFullWidth = false,
    bool isUploading = false,
    bool isAddButton = false,
  }) {
    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: CustomPaint(
        painter: DottedBorderPainter(
          color: AppColors.primary3rdColor,
          strokeWidth: 2,
          gap: 5,
        ),
        child: Container(
          height: 120,
          width: context.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xfff9f0ff),
          ),
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(image, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAddButton ? Icons.add_circle_outline : Icons.add,
                      color: const Color(0xFFba63ff),
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

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/secured_storage.dart';
import '../../routes/app_routes.dart';
import '../../services/api_client.dart';
import '../../services/network/network_caller.dart';
import '../../utils/app_constant.dart';

// Simple fixed-height bottom sheet modal (RECOMMENDED)
class CommonWebViewModal extends StatefulWidget {
  final String url;

  const CommonWebViewModal({super.key, required this.url});

  @override
  State<CommonWebViewModal> createState() => _CommonWebViewModalState();
}

class _CommonWebViewModalState extends State<CommonWebViewModal> {
  late final CommonWebViewController controller;

  @override
  void initState() {
    super.initState();
    // Use a unique tag to prevent rebuilds
    controller = Get.put(CommonWebViewController(), tag: widget.url);
    controller.url = widget.url;
    controller.initializeWebview();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 85% of screen height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: <Widget>[
          // Modal handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with close button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // WebView content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return WebViewWidget(
                  controller: controller.webViewController,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer(),
                    ),
                    Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                    Factory<LongPressGestureRecognizer>(
                      () => LongPressGestureRecognizer(),
                    ),
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller with the specific tag
    Get.delete<CommonWebViewController>(tag: widget.url);
    super.dispose();
  }
}

// Alternative: Scaffold-based modal (More stable for complex WebViews)
class CommonWebViewScaffoldModal extends StatefulWidget {
  final String url;

  const CommonWebViewScaffoldModal({super.key, required this.url});

  @override
  State<CommonWebViewScaffoldModal> createState() =>
      _CommonWebViewScaffoldModalState();
}

class _CommonWebViewScaffoldModalState
    extends State<CommonWebViewScaffoldModal> {
  late final CommonWebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CommonWebViewController(), tag: widget.url);

    controller.url = widget.url;
    controller.initializeWebview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Modal handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header with close button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Payment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // WebView content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return WebViewWidget(
                    controller: controller.webViewController,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer(),
                      ),
                      Factory<TapGestureRecognizer>(
                        () => TapGestureRecognizer(),
                      ),
                      Factory<LongPressGestureRecognizer>(
                        () => LongPressGestureRecognizer(),
                      ),
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<CommonWebViewController>(tag: widget.url);
    super.dispose();
  }
}

class CommonWebViewController extends GetxController {
  final RxBool isLoading = true.obs;
  late WebViewController webViewController;
  String? url;
  String? bookingId;

  Future<void> initializeWebview() async {
    if (url == null) {
      Get.back();
      return;
    }

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => debugPrint("Loading: $progress%"),
          onPageStarted: (String url) => isLoading.value = true,
          onPageFinished: (String url) async {
            await Future.delayed(const Duration(milliseconds: 500));
            isLoading.value = false;
            _injectMobileOptimizations();
          },
          onUrlChange: (UrlChange urlChange) {
            debugPrint("URL changed: ${urlChange.url}");

            if (urlChange.url != null) {
              final newUrl = urlChange.url!;
              Uri uri = Uri.parse(newUrl);

              // ===> 1. SUCCESS: Detect session_id in the URL
              if (uri.queryParameters.containsKey('session_id')) {
                String sessionId = uri.queryParameters['session_id']!;
                debugPrint("✅ Session ID found: $sessionId");

                Get.back(); // Close the WebView Modal immediately
                _verifyPaymentAndShowDetails(sessionId); // Trigger API Call
              }
              // ===> 2. CANCEL/FAIL
              else if (newUrl.toLowerCase().contains('cancel') ||
                  newUrl.toLowerCase().contains('fail')) {
                debugPrint("❌ Payment Cancelled or Failed.");
                Get.back();
                Get.snackbar(
                  'Cancelled',
                  'Payment was cancelled',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            }
          },
        ),
      );

    await webViewController.loadRequest(Uri.parse(url!));
  }

  // ===========================================================================
  // API CALL: VERIFY PAYMENT
  // ===========================================================================
  // ===========================================================================
  // API CALL: VERIFY PAYMENT
  // ===========================================================================
  Future<void> _verifyPaymentAndShowDetails(String sessionId) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 1. Get the token manually for NetworkCaller
      final String token = await SecureStorageService().read(AppConstants.accessToken) ?? '';

      // 2. Use NetworkCaller with the FULL DevTunnel AppUrl
      final response = await NetworkCaller().postRequest(
        '${AppUrl.baseUrl}/payment/check/$sessionId',
        headers: {'Authorization': 'Bearer $token'},
        body: {}, // NetworkCaller handles the map to JSON conversion safely!
      );

      Get.back(); // Close Loading Dialog

      // 3. Check for success using NetworkCaller's properties
      if (response.isSuccess && response.jsonResponse?['data'] != null) {
        final rideData = response.jsonResponse!['data'];

        // Show the First Popup (Success)
        _showSuccessDialog(rideData);
      } else {
        final errorMsg = response.jsonResponse?['message'] ?? 'Failed to load ride details.';
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed(AppRoutes.allBottomBar);
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ===========================================================================
  // FIRST POPUP: SUCCESS DIALOG
  // ===========================================================================
  void _showSuccessDialog(Map<String, dynamic> rideData) {
    String bId = rideData['_id'] ?? bookingId ?? '';
    String displayId = bId.length > 8
        ? "${bId.substring(0, 4)}..${bId.substring(bId.length - 4)}"
        : bId;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF45C4D9), Color(0xFF8B5CF6)],
                  ),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Ride Booked Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Thanks for your Booking and we will send you a confirmation shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Booking ID: ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    displayId,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: bId));
                      Get.snackbar(
                        'Copied',
                        'Booking ID copied',
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: const Icon(
                      Icons.copy,
                      size: 16,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close Success Dialog
                    _showRideDetailsDialog(rideData); // OPEN SECOND DIALOG
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF45C4D9), Color(0xFFB565D8)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        'View Your Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ===========================================================================
  // SECOND POPUP: DETAILED RIDE RECEIPT DIALOG
  // ===========================================================================
  void _showRideDetailsDialog(Map<String, dynamic> rideData) {
    String bId = rideData['_id'] ?? '';
    String displayId = bId.length > 8
        ? "${bId.substring(0, 4)}..${bId.substring(bId.length - 4)}"
        : bId;

    // Format Date & Time
    DateTime parsedDate =
        DateTime.tryParse(rideData['dateTime'] ?? '')?.toLocal() ??
        DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    String formattedTime = DateFormat('h:mm a').format(parsedDate);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header (Status & ID)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          (rideData['status'] ?? 'Paid')
                              .toString()
                              .capitalizeFirst!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFFB565D8),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          displayId,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: bId));
                            Get.snackbar(
                              'Copied',
                              'Booking ID copied',
                              duration: const Duration(seconds: 2),
                            );
                          },
                          child: const Icon(
                            Icons.copy,
                            size: 16,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Card 1: Locations
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F8FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.play_arrow_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Container(width: 1, height: 24, color: Colors.grey),
                          // Simple dashed line replacement
                          const Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rideData['fromAddress'] ?? 'N/A',
                              style: const TextStyle(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              rideData['toAddress'] ?? 'N/A',
                              style: const TextStyle(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Card 2: Details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F8FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildReceiptRow('Date', formattedDate),
                      const SizedBox(height: 12),
                      _buildReceiptRow('Time', formattedTime),
                      const SizedBox(height: 12),
                      _buildReceiptRow(
                        'Passenger',
                        rideData['passengers'].toString(),
                      ),
                      const SizedBox(height: 12),
                      _buildReceiptRow(
                        'Luggages',
                        (rideData['luggages'] as List?)?.length.toString() ??
                            '0',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Card 3: Pricing
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F8FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildReceiptRow(
                        'Fare',
                        rideData['fare']?.toStringAsFixed(2) ?? '0.00',
                      ),
                      const SizedBox(height: 12),
                      _buildReceiptRow(
                        'Charge',
                        rideData['charge']?.toStringAsFixed(2) ?? '0.00',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: Colors.grey),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Fare',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            rideData['totalFare']?.toStringAsFixed(2) ?? '0.00',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      Get.offAllNamed(
                        AppRoutes.allBottomBar,
                      ); // Go to home / rides list
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF45C4D9), Color(0xFFB565D8)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          'View Your Ride',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Helper widget for receipt rows
  Widget _buildReceiptRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }

  void _injectMobileOptimizations() {
    webViewController.runJavaScript('''
      var meta = document.querySelector('meta[name="viewport"]');
      if (!meta) {
        meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
        document.head.appendChild(meta);
      }
      document.body.style.webkitOverflowScrolling = 'touch';
      document.body.style.overscrollBehavior = 'none';
    ''');
  }
}

// Usage helper functions
void showPaymentWebView(String url) {
  Get.bottomSheet(
    CommonWebViewModal(url: url),
    isScrollControlled: true,
    enableDrag: false,
    // Important: disable drag to prevent conflicts
    isDismissible: false,
    backgroundColor: Colors.transparent,
    persistent: true, // Prevent dismissal on route changes
  );
}

// Alternative: Use modal route for better stability
void showPaymentWebViewRoute(String url) {
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (context) => CommonWebViewModal(url: url),
  );
}

// Alternative: Full screen modal (most stable)
void showPaymentWebViewFullScreen(String url) {
  Get.to(
    () => CommonWebViewScaffoldModal(url: url),
    fullscreenDialog: true,
    transition: Transition.downToUp,
    duration: const Duration(milliseconds: 300),
  );
}

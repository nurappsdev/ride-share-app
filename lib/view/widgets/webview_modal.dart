import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 import 'package:webview_flutter/webview_flutter.dart';

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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),

              ],
            ),
          ),
          const Divider(height: 1),
          // WebView content
          Expanded(
            child: Container(
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
  State<CommonWebViewScaffoldModal> createState() => _CommonWebViewScaffoldModalState();
}

class _CommonWebViewScaffoldModalState extends State<CommonWebViewScaffoldModal> {
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
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.15,
        ),
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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

  // Initialize the WebView
  Future<void> initializeWebview() async {
    if (url == null) {
      Get.back();
      return;
    }

    // Create controller with proper settings
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(true)
    // ..setUserAgent(
    //     'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
    // )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint("Loading: $progress%");
          },
          onPageStarted: (String url) {
            debugPrint("Page started: $url");
            isLoading.value = true;
          },
          onPageFinished: (String url) async {
            debugPrint("Page finished: $url");
            // Add delay to ensure page is fully rendered
            await Future.delayed(const Duration(milliseconds: 500));
            isLoading.value = false;

            // Inject JavaScript to improve mobile experience
            _injectMobileOptimizations();
          },
          onHttpError: (HttpResponseError error) {
            debugPrint("HTTP Error: ${error.request} ${error.response}");
            isLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Resource Error: ${error.description}");
            isLoading.value = false;
          },
          onUrlChange: (UrlChange urlChange) {
            debugPrint("URL changed: ${urlChange.url}");

            // Check if payment is complete or cancelled
            if (urlChange.url != null) {
              // Add your success/cancel URL patterns here
              if (urlChange.url!.contains('success') ||
                  urlChange.url!.contains('cancel') ||
                  !urlChange.url!.startsWith("https://checkout.stripe.com")) {
                // Get.back(); // Close modal
                // Get.offAll(() => const MainBottomNavScreen());
              }
            }
          },
        ),
      );

    // Load the URL
    await webViewController.loadRequest(Uri.parse(url!));
  }

  void _injectMobileOptimizations() {
    webViewController.runJavaScript('''
      // Ensure viewport is mobile-friendly
      var meta = document.querySelector('meta[name="viewport"]');
      if (!meta) {
        meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
        document.head.appendChild(meta);
      }
      
      // Fix iOS bounce scrolling
      document.body.style.webkitOverflowScrolling = 'touch';
      document.body.style.overscrollBehavior = 'none';
      
      // Ensure inputs are clickable
      var inputs = document.querySelectorAll('input, textarea, select, button, a');
      inputs.forEach(function(el) {
        el.style.cursor = 'pointer';
      });
      
      // Fix touch events
      document.addEventListener('touchstart', function() {}, {passive: true});
      
      // Ensure form inputs work properly
      document.addEventListener('focusin', function(e) {
        if (e.target.matches('input, textarea, select')) {
          setTimeout(() => {
            e.target.scrollIntoView({behavior: 'smooth', block: 'center'});
          }, 300);
        }
      });
    ''');
  }

  @override
  void onClose() {
    // Cleanup
    super.onClose();
  }
}

// Usage helper functions
void showPaymentWebView(String url) {
  Get.bottomSheet(
    CommonWebViewModal(url: url),
    isScrollControlled: true,
    enableDrag: false, // Important: disable drag to prevent conflicts
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
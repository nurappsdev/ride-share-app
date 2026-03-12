import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/privacy_policy_controller.dart';
import 'package:split_ride/utils/app_colors.dart';

class PrivacyPolicyAllScreen extends StatelessWidget {
  const PrivacyPolicyAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller (will fetch data based on arguments)
    final PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Obx(() => Text(
          controller.title.value,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Outfit',
          ),
        )),
        centerTitle: true,
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value && controller.contentHtml.value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary3rdColor,
            ),
          );
        }

        // Error state with empty content
        if (controller.errorMessage.value.isNotEmpty && 
            controller.contentHtml.value.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Failed to load content',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    fontFamily: 'Outfit',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                    fontFamily: 'Outfit',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchContent(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary3rdColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Success state - show content
        return RefreshIndicator(
          onRefresh: () => controller.refreshContent(),
          color: AppColors.primary3rdColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: HtmlWidget(
              controller.contentHtml.value,
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 14.sp,
                fontFamily: 'Outfit',
                height: 1.6,
              ),
              customStylesBuilder: (element) {
                if (element.localName == 'h1') {
                  return {'font-size': '24sp', 'font-weight': '700', 'margin-bottom': '16px'};
                } else if (element.localName == 'h2') {
                  return {'font-size': '20sp', 'font-weight': '600', 'margin-bottom': '12px'};
                } else if (element.localName == 'h3') {
                  return {'font-size': '16sp', 'font-weight': '600', 'margin-bottom': '8px'};
                } else if (element.localName == 'p') {
                  return {'margin-bottom': '12px'};
                } else if (element.localName == 'ul' || element.localName == 'ol') {
                  return {'margin-bottom': '12px', 'padding-left': '20px'};
                } else if (element.localName == 'li') {
                  return {'margin-bottom': '6px'};
                } else if (element.localName == 'a') {
                  return {'color': '#6B7FEC', 'text-decoration': 'none'};
                }
                return null;
              },
              customWidgetBuilder: (element) {
                // Handle links
                if (element.localName == 'a') {
                  final href = element.attributes['href'];
                  if (href != null) {
                    return GestureDetector(
                      onTap: () {
                        // Open URL in browser or handle internally
                        print('Link tapped: $href');
                      },
                      child: Text(
                        element.text,
                        style: const TextStyle(
                          color: AppColors.primary3rdColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  }
                }
                return null;
              },
            ),
          ),
        );
      }),
    );
  }
}

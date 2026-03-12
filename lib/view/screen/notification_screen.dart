import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:split_ride/controllers/notification_controller.dart';
import 'package:split_ride/model/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            fontFamily: 'Outfit',
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Loading state (first load)
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6B7FEC),
            ),
          );
        }

        // Empty state
        if (!controller.isLoading.value && controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No Notifications',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    fontFamily: 'Outfit',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'You don\'t have any notifications yet',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
          );
        }

        // Notification list with pull-to-refresh and infinite scroll
        return RefreshIndicator(
          onRefresh: () => controller.refreshNotifications(),
          color: const Color(0xFF6B7FEC),
          child: ListView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.zero,
            itemCount: controller.notifications.length + 1,
            itemBuilder: (context, index) {
              // Show loading indicator at bottom when loading more
              if (index == controller.notifications.length) {
                if (controller.isLoadingMore.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF6B7FEC),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }

              final notification = controller.notifications[index];
              return _NotificationTile(notification: notification);
            },
          ),
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isPayment = notification.type.toLowerCase() == 'payment';

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isPayment
                      ? const Icon(
                    Icons.attach_money_rounded,
                    color: Color(0xFF5B5BD6),
                    size: 22,
                  )
                      : const Icon(
                    Icons.directions_car_outlined,
                    color: Color(0xFF5B5BD6),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.2,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B6B6B),
                        height: 1.4,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          notification.formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFAAAAAA),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          notification.formattedTime,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFAAAAAA),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Outfit',
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
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFF0F0F0),
        ),
      ],
    );
  }
}

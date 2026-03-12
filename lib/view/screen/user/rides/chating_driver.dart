import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Import your controller and widgets
import '../../../../controllers/message/message_controller.dart';
import '../../../widgets/widgets.dart';
import '../../../../helpers/app_url.dart';

class ChatDriverScreen extends StatelessWidget {
  const ChatDriverScreen({Key? key}) : super(key: key);

  // Formats the image URL for the chat bubble
  String _getImageUrl(String path) {
    if (path.startsWith('/data/user') || path.startsWith('file://')) {
      return path; // Local optimistic UI file
    }

    // IMPORTANT: Assuming AppUrl.baseUrl is 'http://domain.com/api/v1'
    // We remove the '/api/v1' to point to the base domain where '/uploads' lives.
    String baseDomain = AppUrl.baseUrl.replaceAll('/api/v1', '');
    return "$baseDomain/uploads/$path";
  }

  @override
  Widget build(BuildContext context) {
    final String driverName = Get.arguments?['driverName'] ?? 'Unknown Driver';
    final String driverEmail = Get.arguments?['driverEmail'] ?? '--';
    final String driverPhone = Get.arguments?['driverPhone'] ?? '--';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<ChatDriverController>(
            init: ChatDriverController(),
            builder: (controller) {
              return Column(
                children: [
                  // ================= HEADER =================
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 10.h,
                      bottom: 16.h,
                      left: 20.w,
                      right: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.keyboard_arrow_down, size: 28.sp),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomText(
                            text: driverName,
                            fontsize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: ClipOval(
                            child: Icon(
                              Icons.person,
                              size: 24.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ================= CONTACT INFO BAR =================
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email_outlined, size: 14.sp, color: const Color(0xFF7C3AED)),
                        SizedBox(width: 6.w),
                        CustomText(
                          text: driverEmail,
                          fontsize: 12,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF7C3AED),
                        ),
                        SizedBox(width: 16.w),
                        Icon(Icons.phone, size: 14.sp, color: const Color(0xFF7C3AED)),
                        SizedBox(width: 6.w),
                        CustomText(
                          text: driverPhone,
                          fontsize: 12,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF7C3AED),
                        ),
                      ],
                    ),
                  ),

                  // ================= MESSAGES LIST =================
                  Expanded(
                    child: controller.isInitialLoading
                        ? const Center(child: CircularProgressIndicator())
                        : controller.messages.isEmpty
                        ? Center(
                      child: CustomText(
                        text: "Say hi to $driverName!",
                        fontsize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                        : ListView.builder(
                      controller: controller.scrollController,
                      reverse: true, // Key for messenger-style bottom alignment
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      itemCount: controller.messages.length + (controller.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.messages.length) {
                          return Padding(
                            padding: EdgeInsets.all(8.h),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        }

                        final message = controller.messages[index];
                        final bool isSent = message.senderId != controller.otherUserId;

                        return _buildMessageBubble(message, isSent);
                      },
                    ),
                  ),

                  // ================= INPUT AREA WITH IMAGE PREVIEW =================
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10.r,
                          offset: Offset(0, -2.h),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- IMAGE PREVIEW UI ---
                        if (controller.selectedImage != null)
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 12.h, left: 16.w),
                                height: 80.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  image: DecorationImage(
                                    image: FileImage(controller.selectedImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -10,
                                right: -10,
                                child: IconButton(
                                  icon: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close, color: Colors.white, size: 14.sp),
                                  ),
                                  onPressed: controller.clearSelectedImage,
                                ),
                              ),
                            ],
                          ),

                        // --- TEXT INPUT ROW ---
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: controller.messageController,
                                        focusNode: controller.focusNode,
                                        textInputAction: TextInputAction.send,
                                        onSubmitted: (_) => controller.onTapSendMessageBtn(),
                                        decoration: InputDecoration(
                                          hintText: 'Chat with your driver',
                                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: controller.pickImage,
                                      child: Icon(Icons.image_outlined, size: 22.sp, color: const Color(0xFF7C3AED)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),

                            // --- DYNAMIC SEND/CALL BUTTON ---
                            GestureDetector(
                              onTap: () async {
                                if (controller.showSendButton) {
                                  controller.onTapSendMessageBtn();
                                } else {
                                  if (driverPhone.isNotEmpty && driverPhone != '--') {
                                    final Uri launchUri = Uri(scheme: 'tel', path: driverPhone);
                                    if (await canLaunchUrl(launchUri)) {
                                      await launchUrl(launchUri);
                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: 56.w,
                                height: 56.h,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFF45C4D9), Color(0xFF6B7FEC), Color(0xFFB565D8)],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  controller.showSendButton ? Icons.send : Icons.phone,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }

  // ===========================================================================
  // MESSAGE BUBBLE BUILDER
  // ===========================================================================
  Widget _buildMessageBubble(dynamic message, bool isSent) {
    bool hasAttachment = message.attachments != null && message.attachments.isNotEmpty;
    String? attachmentPath = hasAttachment ? message.attachments[0] : null;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // IMAGE WIDGET
          if (hasAttachment && attachmentPath != null)
            Container(
              margin: EdgeInsets.only(bottom: 6.h),
              constraints: BoxConstraints(maxWidth: 220.w, maxHeight: 220.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: _getImageUrl(attachmentPath).startsWith('/data')
                  ? Image.file(File(attachmentPath), fit: BoxFit.cover)
                  : Image.network(
                _getImageUrl(attachmentPath),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 150.w,
                    height: 150.h,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 150.w,
                    height: 150.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey[500]),
                  );
                },
              ),
            ),

          // TEXT WIDGET
          if (message.content != null && message.content.isNotEmpty)
            Row(
              mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: isSent
                          ? const LinearGradient(colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)])
                          : null,
                      color: isSent ? null : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                        bottomLeft: Radius.circular(isSent ? 20.r : 4.r),
                        bottomRight: Radius.circular(isSent ? 4.r : 20.r),
                      ),
                    ),
                    child: CustomText(
                      text: message.content ?? '',
                      fontsize: 14,
                      fontWeight: FontWeight.normal,
                      color: isSent ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
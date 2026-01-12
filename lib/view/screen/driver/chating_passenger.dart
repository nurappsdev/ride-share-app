



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/widgets.dart';

class ChatingPassenger extends StatefulWidget {
  const ChatingPassenger({Key? key}) : super(key: key);

  @override
  State<ChatingPassenger> createState() => _ChatingPassengerState();
}

class _ChatingPassengerState extends State<ChatingPassenger> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessages> messages = [
    ChatMessages(text: 'Hi Jane Cooper', isSent: true),
    ChatMessages(text: 'How are you? And where are you from?', isSent: true),
    ChatMessages(text: 'I am good. And I\'m from United State', isSent: false),
    ChatMessages(text: 'Ohh, great', isSent: true),
    ChatMessages(text: 'How long do you need to arrive at location', isSent: true),
    ChatMessages(text: 'I need 10 mins', isSent: false),
    ChatMessages(text: 'Ok, no problem. We are waiting', isSent: true),
    ChatMessages(text: 'Yes sure', isSent: false),
  ];



  // Phone number যেটাতে call করতে চান
  final String phoneNumber = "+8801XXXXXXXXX"; // আপনার number দিন

// Call করার function
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
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
                  // Back Button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.keyboard_arrow_down, size: 28.sp),
                      ),
                      SizedBox(width: 10.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Jane Cooper',
                            fontsize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          CustomText(
                            text: 'Booking ID SR1284E6',
                            fontsize: 16,
                            fontWeight: FontWeight.bold,
                            color:  AppColors.primary3rdColor
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),

                  // Driver Name
                  Expanded(
                    child: CustomText(
                      text: '',
                      fontsize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  // Profile Picture
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

            // Contact Info Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined, size: 14.sp, color: Color(0xFF7C3AED)),
                  SizedBox(width: 6.w),
                  CustomText(
                    text: 'janecooper@email.com',
                    fontsize: 12,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C3AED),
                  ),
                  SizedBox(width: 16.w),
                  Icon(Icons.phone, size: 14.sp, color: Color(0xFF7C3AED)),
                  SizedBox(width: 6.w),
                  CustomText(
                    text: '+1 234 567 8901',
                    fontsize: 12,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C3AED),
                  ),
                ],
              ),
            ),

            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Input Area
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
              child: Row(
                children: [
                  // Text Input Field
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Chat with your driver',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14.sp,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                            ),
                          ),

                          Icon(Icons.camera_alt_outlined, size: 22.sp, color: Color(0xFF7C3AED)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  InkWell(
                    onTap:  () async {
                      await makePhoneCall(phoneNumber);
                    },
                    child: Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [  Color(0xFF45C4D9),
                            Color(0xFF6B7FEC),
                            Color(0xFFB565D8),],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF3B82F6).withOpacity(0.3),
                            blurRadius: 12.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: Icon(Icons.phone, color: Colors.white, size: 24.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessages message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (message.isSent)
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(4.r),
                  ),
                ),
                child: CustomText(
                  text: message.text,
                  fontsize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            )
          else
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(4.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: CustomText(
                  text: message.text,
                  fontsize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,


                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessages {
  final String text;
  final bool isSent;

  ChatMessages({required this.text, required this.isSent});
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.close, color: Colors.black),
//           onPressed: () {Get.back();},
//         ),
//         title: Text(
//           'Notifications',
//           style: TextStyle(
//             fontFamily: 'Outfit',
//             color: Colors.black,
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_outlined, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16.r),
//         children: [
//           NotificationCard(
//             icon: Icons.person_outline,
//             title: 'Account Signup Successfully',
//             message: 'Your account has been successful. You can use this application.',
//             date: '05 Jan 2023',
//             time: '10:00 AM',
//             iconColor: const Color(0xFF7C6FDC),
//           ),
//           SizedBox(height: 12.h),
//           NotificationCard(
//             icon: Icons.lock_outline,
//             title: 'Password Updated',
//             message: 'Your password is updated. You have got a new password.',
//             date: '05 Jan 2023',
//             time: '10:00 AM',
//             iconColor: const Color(0xFF7C6FDC),
//           ),
//           SizedBox(height: 12.h),
//           NotificationCard(
//             icon: Icons.verified_user_outlined,
//             title: 'Security Updates',
//             message: 'Customers must have a current Technical Support Entitlement in order to be...',
//             date: '05 Jan 2023',
//             time: '10:00 AM',
//             iconColor: const Color(0xFF7C6FDC),
//           ),
//           SizedBox(height: 12.h),
//           NotificationCard(
//             icon: Icons.directions_car_outlined,
//             title: 'Your Ride is done',
//             message: 'Congratulation your Ride is successful',
//             date: '05 Jan 2023',
//             time: '10:00 AM',
//             iconColor: const Color(0xFF7C6FDC),
//           ),
//           SizedBox(height: 12.h),
//           NotificationCard(
//             icon: Icons.person_outline,
//             title: 'Account Signin Successfully',
//             message: 'Your account has been successful. You can use this application.',
//             date: '05 Jan 2023',
//             time: '10:00 AM',
//             iconColor: const Color(0xFF7C6FDC),
//           ),
//           SizedBox(height: 12.h),
//           NotificationCard(
//             icon: Icons.lock_outline,
//             title: 'Password Updated',
//             message: 'Your password is updated. You have got a new password.',
//             date: '05 Jan 2023',
//             time: '10:00 AM',
//             iconColor: const Color(0xFF7C6FDC),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NotificationCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String message;
//   final String date;
//   final String time;
//   final Color iconColor;
//
//   const NotificationCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.message,
//     required this.date,
//     required this.time,
//     required this.iconColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.r),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEDE7FF),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(10.r),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(30.r),
//             ),
//             child: Icon(
//               icon,
//               color: iconColor,
//               size: 24.r,
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontFamily: 'Outfit',
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   message,
//                   style: TextStyle(
//                     fontFamily: 'Outfit',
//                     fontSize: 13.sp,
//                     color: Colors.black54,
//                     height: 1.4,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   '$date  $time',
//                   style: TextStyle(
//                     fontFamily: 'Outfit',
//                     fontSize: 12.sp,
//                     color: Colors.black45,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
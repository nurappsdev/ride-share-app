// import 'dart:async';
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:healthcarewilson/view/widgets/call_invitation.dart';
//
// import '../helpers/prefs_helper.dart';
// import '../helpers/toast_message_helper.dart';
// import '../routes/app_routes.dart';
// import '../services/api_client.dart';
// import '../services/api_constants.dart';
// import '../services/socket_services.dart';
// import '../utils/app_constant.dart';
// import 'chat_controller.dart';
//
// class AuthController extends GetxController {
//   ///************************************************************************///
//   RxBool isSelected = true.obs;
//   RxBool signUpLoading = false.obs;
//   final ChatController chatController = Get.find<ChatController>();
//
//
//   ///===============Sing up ================<>
//   handleSignUp({required String name, email, password}) async {
//     signUpLoading(true);
//
//     var role = await PrefsHelper.getString(AppConstants.role);
//
//     var body = {
//       "name": name,
//       "email": "$email",
//       "role": role,
//       "password": "$password",
//       "confirmPassword": "$password",
//     };
//
//     var response = await ApiClient.postData(
//       ApiConstants.signUpEndPoint,
//       jsonEncode(body),
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Get.toNamed(
//         AppRoutes.verifyScreen,
//         arguments: {'screenType': 'register'},
//       );
//       PrefsHelper.setString(
//         AppConstants.bearerToken,
//         response.body['data']["verificationToken"],
//       );
//       ToastMessageHelper.successMessageShowToster(
//         "Account create successful.\n \nNow you have a one time code your email",
//       );
//       signUpLoading(false);
//     } else {
//       signUpLoading(false);
//       ToastMessageHelper.errorMessageShowToster("${response.body["message"]}");
//     }
//   }
//
//   ///************************************************************************///
//
//   ///===============Verify Email================<>
//   RxBool verfyLoading = false.obs;
//
//   verfyEmail(String otpCode, {String screenType = ''}) async {
//     verfyLoading(true);
//     String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $bearerToken',
//     };
//     var body = {"otp": otpCode};
//
//     var response = await ApiClient.postData(
//       ApiConstants.verifyEmailEndPoint,
//       jsonEncode(body),
//       headers: headers,
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       if (screenType == 'forgot') {
//         Get.toNamed(AppRoutes.resetPassScreen);
//       } else {
//         Get.offAllNamed(AppRoutes.signInScreen);
//       }
//       verfyLoading(false);
//     } else if (response.statusCode == 1) {
//       verfyLoading(false);
//       // ToastMessageHelper.showToastMessage("Server error! \n Please try later");
//     } else {
//       ToastMessageHelper.errorMessageShowToster("${response.body["message"]}");
//       verfyLoading(false);
//     }
//   }
//
//   ///************************************************************************///
//   ///===============Log in================<>
//   RxBool logInLoading = false.obs;
//   var step = 0;
//   var status = "";
//   handleLogIn(String email, String password) async {
//     logInLoading.value = true;
//     var headers = {'Content-Type': 'application/json'};
//     var body = {"email": email, "password": password};
//     var response = await ApiClient.postData(
//       ApiConstants.signInEndPoint,
//       jsonEncode(body),
//       headers: headers,
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       var data = response.body['data'];
//
//       PrefsHelper.setString(AppConstants.role, data["user"]['role']);
//       PrefsHelper.setString(
//         AppConstants.bearerToken,
//         response.body["data"]['tokens']["accessToken"],
//       );
//       PrefsHelper.setString(AppConstants.email, email);
//       PrefsHelper.setString(AppConstants.name, data["user"]['name']);
//       PrefsHelper.setString(AppConstants.image, data["user"]['profileImage']);
//       PrefsHelper.setString(AppConstants.number, data["user"]['phone']);
//       PrefsHelper.setString(AppConstants.userId, data["user"]['_id']);
//       PrefsHelper.setBool(AppConstants.isLogged, true);
//       initializeCallInvitation(
//         id: email,
//         name: data["user"]['name'],
//         image: data['user']["profileImage"],
//       );
//
//       step = data["user"]['step'];
//       status = data["user"]['approvalStatus'];
//       PrefsHelper.setInt(AppConstants.step, step.toInt());
//       PrefsHelper.setString(AppConstants.status, status);
//
//       print("step----------$step------\nstatus:$status");
//
//       var role = data["user"]['role'];
//       print("=============role ==============? $role");
//
//       if (role == "patient") {
//         if (step == 1) {
//           Get.offAllNamed(AppRoutes.patientRegScreen);
//         } else {
//           Get.toNamed(AppRoutes.patientBottomNavBar, preventDuplicates: false);
//         }
//       } else if (role == "doctor") {
//         if (step == 1) {
//           Get.toNamed(AppRoutes.doctorRegistrationScreen);
//         } else if (status == "pending" || status == "rejected") {
//           Get.toNamed(AppRoutes.doctorReviewScreen, preventDuplicates: false);
//         } else if (step == 2) {
//           Get.toNamed(AppRoutes.submitScreen, preventDuplicates: false);
//         } else {
//           Get.toNamed(AppRoutes.allBottomBarScreen, preventDuplicates: false);
//         }
//
//         //Get.toNamed(AppRoutes.allBottomBarScreen);
//       } else if (role == "nurse") {
//         if (step == 1) {
//           Get.offAllNamed(AppRoutes.nurseRegScreen);
//         } else if (status == "pending" || status == "rejected") {
//           Get.toNamed(AppRoutes.nurseReviewScreen, preventDuplicates: false);
//         } else if (step == 2) {
//           Get.toNamed(AppRoutes.nurseSubmitScreen, preventDuplicates: false);
//         } else if (step == 3) {
//           Get.toNamed(AppRoutes.nurseServiceScreen, preventDuplicates: false);
//         } else {
//           Get.toNamed(AppRoutes.nurseBottomNavBar, preventDuplicates: false);
//         }
//       } else if (role == "pharmacy") {
//         if (step == 1) {
//           Get.offAllNamed(AppRoutes.pharmacyRegScreen);
//         } else if (status == "pending" || status == "rejected") {
//           Get.toNamed(AppRoutes.pharmacyReviewScreen, preventDuplicates: false);
//         } else {
//           Get.toNamed(
//             AppRoutes.pharmacyBottombarScreen,
//             preventDuplicates: false,
//           );
//         }
//       }
//       ToastMessageHelper.successMessageShowToster('Your are logged in');
//
//       logInLoading(false);
//
//       await PrefsHelper.setString(
//         AppConstants.image,
//         data['user']["profileImage"],
//       );
//       await PrefsHelper.setString(
//         AppConstants.address,
//         data['user']["address"].toString(),
//       );
//       PrefsHelper.setString(
//         AppConstants.dateOfBirth,
//         data["user"]['dateOfBirth'],
//       );
//
//       SocketServices socketServices = SocketServices();
//
//       socketServices.init(userId: data["user"]['_id'], fcmToken: "nai");
//       chatController.unReadMessage();
//     } else {
//       ///******** When user do not able to verify their account thay have to verify there account then they can go to the app********
//       if (response.body["message"] == "Please verify your account") {
//         ToastMessageHelper.successMessageShowToster(
//           "your account create is successful but you don't verify your email. \n \n Please verify your account",
//         );
//       }
//       ///******** if user as a employee go to the otp verify screen or more information screen************///
//       else if (response.body["message"] == "Please complete your profile") {
//       } else if (response.body["message"] ==
//           "Your account is currently being verified by the admin. Thank you for your patience!") {
//       } else if (response.body["message"] == "Incorrect password") {
//         ToastMessageHelper.errorMessageShowToster(response.body["message"]);
//       }
//       logInLoading(false);
//       ToastMessageHelper.errorMessageShowToster(response.body['message']);
//     }
//   }
//
//   ///************************************************************************///
//
//   ///===============Forgot Password================<>
//   RxBool forgotLoading = false.obs;
//
//   handleForgot(String email) async {
//     forgotLoading(true);
//     var body = {"email": email};
//
//     var response = await ApiClient.postData(
//       ApiConstants.forgotPasswordPoint,
//       jsonEncode(body),
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Get.toNamed(AppRoutes.verifyScreen, arguments: {'screenType': 'forgot'});
//       PrefsHelper.setString(
//         AppConstants.bearerToken,
//         response.body["data"]["resetPasswordToken"],
//       );
//       forgotLoading(false);
//     } else {
//       ToastMessageHelper.errorMessageShowToster(response.body["message"]);
//       forgotLoading(false);
//     }
//   }
//
//   ///===============Set Password================<>
//   RxBool setPasswordLoading = false.obs;
//
//   resetPassword(String password) async {
//     setPasswordLoading(true);
//     var body = {
//       "password": password.toString().trim(),
//       "confirmPassword": password.toString().trim(),
//     };
//
//     var response = await ApiClient.postData(
//       ApiConstants.setPasswordEndPoint,
//       jsonEncode(body),
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Get.offAllNamed(AppRoutes.signInScreen);
//       ToastMessageHelper.successMessageShowToster('Password Changed');
//       print("======>>> successful");
//       setPasswordLoading(false);
//     } else {
//       setPasswordLoading(false);
//       ToastMessageHelper.errorMessageShowToster(response.body["message"]);
//     }
//   }
//
//   ///===============Resend================<>
//   RxBool resendLoading = false.obs;
//
//   reSendOtp() async {
//     resendLoading(true);
//     var body = {};
//
//     var response = await ApiClient.postData(
//       ApiConstants.resendOtpEndPoint,
//       jsonEncode(body),
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       PrefsHelper.setString(
//         AppConstants.bearerToken,
//         response.body["data"]["verificationToken"],
//       );
//       ToastMessageHelper.successMessageShowToster(
//         'You have got an one time code to your email',
//       );
//       print("======>>> successful");
//       resendLoading(false);
//     } else {
//       resendLoading(false);
//       ToastMessageHelper.errorMessageShowToster("${response.body["message"]}");
//     }
//   }
//
//   ///===============Change Password================<>
//   RxBool changePasswordLoading = false.obs;
//
//   changePassword(String oldPassword, String newPassword) async {
//     changePasswordLoading(true);
//     var body = {
//       "currentPassword": oldPassword,
//       "password": newPassword,
//       "confirmPassword": newPassword,
//     };
//
//     var response = await ApiClient.postData(
//       ApiConstants.changePassword,
//       jsonEncode(body),
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ToastMessageHelper.successMessageShowToster(
//         'Password Changed Successful',
//       );
//       Get.back();
//       print("======>>> successful");
//       changePasswordLoading(false);
//     } else {
//       changePasswordLoading(false);
//       ToastMessageHelper.errorMessageShowToster(response.body['message']);
//     }
//   }
//
//   final RxInt countdown = 60.obs;
//   final RxBool isCountingDown = false.obs;
//
//   void startCountdown() {
//     isCountingDown.value = true;
//     countdown.value = 60;
//     update();
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (countdown.value > 0) {
//         countdown.value--;
//         update();
//       } else {
//         timer.cancel();
//         isCountingDown.value = false;
//         update();
//       }
//     });
//   }
// }

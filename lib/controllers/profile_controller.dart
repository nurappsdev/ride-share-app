// import 'dart:typed_data';
//
// import 'package:get/get.dart';
//
// import '../helpers/prefs_helper.dart';
// import '../helpers/toast_message_helper.dart';
// import '../model/user_response_model.dart';
// import '../services/api_client.dart';
// import '../services/api_constants.dart';
// import '../utils/app_constant.dart';
//
// class ProfileController extends GetxController {
//   RxString name = ''.obs;
//   RxString email = ''.obs;
//   RxString image = ''.obs;
//   RxString role = ''.obs;
//   RxString rating = '0'.obs;
//   RxString phone = ''.obs;
//   RxString address = ''.obs;
//   RxString dateOfBirth = ''.obs;
//
//   Uint8List? images;
//
//   getUserLocalData() async {
//     name.value = await PrefsHelper.getString(AppConstants.name);
//     email.value = await PrefsHelper.getString(AppConstants.email);
//     image.value = await PrefsHelper.getString(AppConstants.image);
//     role.value = await PrefsHelper.getString(AppConstants.role);
//     phone.value = await PrefsHelper.getString(AppConstants.number);
//     address.value = await PrefsHelper.getString(AppConstants.address);
//     dateOfBirth.value = await PrefsHelper.getString(AppConstants.dateOfBirth);
//   }
//
//   // RxBool updateProfileLoading = false.obs;
//   // updateUserProfile({String? name, String? phone, String? dateOfBirth, String? address, String? profileImage})async{
//   //   updateProfileLoading(true);
//   //   var body = {
//   //     "name": "$name",
//   //     "phone": "$phone",
//   //     "dateOfBirth": "$dateOfBirth",
//   //     "address": "$address",
//   //     "profileImage": "$profileImage"
//   //   };
//   //   var response = await ApiClient.patch(ApiConstants.updateProfile, jsonEncode(body));
//   //
//   //   if(response.statusCode == 201 || response.statusCode == 200){
//   //     PrefsHelper.setString(AppConstants.name, name);
//   //     PrefsHelper.setString(AppConstants.number, phone);
//   //     PrefsHelper.setString(AppConstants.dateOfBirth, dateOfBirth);
//   //     PrefsHelper.setString(AppConstants.address, address);
//   //     PrefsHelper.setString(AppConstants.image, profileImage);
//   //
//   //     Get.back();
//   //     updateProfileLoading(false);
//   //
//   //
//   //   }else{
//   //
//   //     updateProfileLoading(false);
//   //   }
//   //
//   // }
//   RxBool isUser = false.obs;
//   Rx<UserResponseModel> getUserResponseModel = UserResponseModel().obs;
//   RxInt step = 1.obs;
//   RxString status = "".obs;
//   RxString jwtExpired = "".obs;
//   getUserData() async {
//     isUser(true);
//     try {
//       var response = await ApiClient.getData(ApiConstants.getUserEndPoint);
//       print("Response Status: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         getUserResponseModel.value = UserResponseModel.fromJson(
//           response.body['data'],
//         );
//         step.value = response.body['data']['step'];
//         status.value = response.body['data']['approvalStatus'];
//       } else {
//         jwtExpired.value = response.body["message"];
//         update();
//         refresh();
//         //ToastMessageHelper.errorMessageShowToster(response.body["message"] ?? "Unexpected error");
//       }
//     } catch (e, stacktrace) {
//       print("Exception: $e");
//       print("Stacktrace: $stacktrace");
//       // ToastMessageHelper.errorMessageShowToster("An error occurred: $e");
//     } finally {
//       isUser(false);
//     }
//   }
//
//   // Method to get step and approvalStatus after data is fetched
//
//   /// --------------update Profile-----------------------
//   RxBool isDoctorUpdateLoading = false.obs;
//
//   Future<void> doctorProfileUpdate({
//     required String? profileImage,
//     required String? name,
//     required List<String> languages,
//     required dynamic instantFee,
//     required dynamic regularFee,
//     required String? clinicAddress,
//     required String? clinicName,
//     required String? experience,
//     required String? phone,
//     required String? countryCode,
//   }) async {
//     isDoctorUpdateLoading(true);
//
//     String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $bearerToken',
//     };
//
//     // Filter out empty strings from the languages list
//     List<String> filteredLanguages = languages
//         .where((language) => language.isNotEmpty)
//         .toList();
//
//     var body = {
//       "name": name,
//       "clinicAddress": clinicAddress ?? '',
//       "clinicName": clinicName ?? '',
//       "experience": experience ?? '',
//       "instantFee": instantFee ?? 0,
//       "regularFee": regularFee ?? 0,
//       "profileImage": profileImage ?? '',
//       "phone": phone ?? '',
//       "languages": filteredLanguages,
//       "countryCode": countryCode ?? '',
//     };
//     // for (int i = 0; i < languages.length; i++) {
//     //   body["languages[$i]"] = languages[i];
//     // }
//     var response = await ApiClient.putData(
//       ApiConstants.doctorUpdateEndPoint,
//       body,
//       headers: headers,
//     );
//
//     print("update=======> ${response.body}");
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ToastMessageHelper.successMessageShowToster(response.body["message"]);
//       getUserData();
//       Get.back();
//       update();
//       isDoctorUpdateLoading(false);
//     } else {
//       isDoctorUpdateLoading(false);
//       ToastMessageHelper.errorMessageShowToster(
//         response.body["message"].toString(),
//       );
//     }
//   }
//
//   /// --------------update Profile-----------------------
//   RxBool isPatientUpdateLoading = false.obs;
//
//   Future<void> patientProfileUpdate({
//     required String? profileImage,
//     required String? name,
//     required List<String> languages,
//     required String? phone,
//     required String? address,
//     required String? countryCode,
//   }) async {
//     isPatientUpdateLoading(true);
//
//     String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $bearerToken',
//     };
//
//     // Filter out empty strings from the languages list
//     List<String> filteredLanguages = languages
//         .where((language) => language.isNotEmpty)
//         .toList();
//
//     var body = {
//       "name": name,
//       "profileImage": profileImage ?? '',
//       "phone": phone ?? '',
//       "address": address ?? '',
//       "languages": filteredLanguages,
//       "countryCode": countryCode ?? '',
//     };
//     // for (int i = 0; i < languages.length; i++) {
//     //   body["languages[$i]"] = languages[i];
//     // }
//     var response = await ApiClient.putData(
//       ApiConstants.doctorUpdateEndPoint,
//       body,
//       headers: headers,
//     );
//
//     print("update=======> ${response.body}");
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ToastMessageHelper.successMessageShowToster(response.body["message"]);
//       getUserData();
//       Get.back();
//       update();
//       isPatientUpdateLoading(false);
//     } else {
//       isPatientUpdateLoading(false);
//       ToastMessageHelper.errorMessageShowToster(
//         response.body["message"].toString(),
//       );
//     }
//   }
//
//   /// --------------update Profile-----------------------
//   RxBool isPharmacyUpdateLoading = false.obs;
//
//   Future<void> pharmacyProfileUpdate({
//     required String? name,
//     required String? profileImage,
//     required String? ownerName,
//     required String? pName,
//     required String? phone,
//     required String? address,
//     required String? countryCode,
//   }) async {
//     isPharmacyUpdateLoading(true);
//
//     String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $bearerToken',
//     };
//
//     var body = {
//       "name": name,
//       "ownerName": ownerName,
//       "pName": pName,
//       "profileImage": profileImage ?? '',
//       "phone": phone ?? '',
//       "address": address ?? '',
//       "countryCode": countryCode ?? '',
//     };
//     // for (int i = 0; i < languages.length; i++) {
//     //   body["languages[$i]"] = languages[i];
//     // }
//     var response = await ApiClient.putData(
//       ApiConstants.doctorUpdateEndPoint,
//       body,
//       headers: headers,
//     );
//
//     print("update=======> ${response.body}");
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ToastMessageHelper.successMessageShowToster(response.body["message"]);
//       getUserData();
//       Get.back();
//       update();
//       isPharmacyUpdateLoading(false);
//     } else {
//       isPharmacyUpdateLoading(false);
//       ToastMessageHelper.errorMessageShowToster(
//         response.body["message"].toString(),
//       );
//     }
//   }
//
//   ///---------------nurse update profile-------------------------
//
//   RxBool isNurseLoading = false.obs;
//
//   Future<void> nurseUpDateProfile({
//     required String? profileImage,
//     required String? name,
//     required String? hospitalName,
//     required String? phone,
//
//     required dynamic instantFee,
//     required List<String> languages,
//     required String? countryCode,
//   }) async {
//     isNurseLoading(true);
//
//     String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $bearerToken',
//     };
//
//     // Filter out empty strings from the languages list
//     List<String> filteredLanguages = languages
//         .where((language) => language.isNotEmpty)
//         .toList();
//
//     var body = {
//       "name": name,
//       "profileImage": profileImage ?? '',
//       "phone": phone ?? '',
//       "hospitalName": hospitalName ?? '',
//       "fee": instantFee ?? 0,
//       "languages": filteredLanguages,
//       "countryCode": countryCode,
//     };
//     print("tokkkkkkkkkeeeeeeeeeennnnnnnnnnn=>$bearerToken");
//
//     var response = await ApiClient.putData("/user/me", body, headers: headers);
//
//     print("update=======> ${response.body}");
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ToastMessageHelper.successMessageShowToster(response.body["message"]);
//       // Get.toNamed(AppRoutes.doctorReviewScreen, preventDuplicates: false);
//       getUserData();
//       Get.back();
//       update();
//       isNurseLoading(false);
//     } else {
//       isNurseLoading(false);
//       ToastMessageHelper.errorMessageShowToster(
//         response.body["message"].toString(),
//       );
//     }
//   }
// }

// import 'package:get/get.dart';
//
// import '../services/api_client.dart';
//
// class PrivacyPolicyController extends GetxController {
//   RxString valueText = "".obs;
//   RxBool privacyPolicyLoading = false.obs;
//
//   getPrivacyPolicyAll({required String url}) async {
//     privacyPolicyLoading(true);
//
//     var response = await ApiClient.getData(url);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       valueText.value = response.body["data"]["value"];
//       privacyPolicyLoading(false);
//     } else {
//       privacyPolicyLoading(false);
//     }
//   }
// }

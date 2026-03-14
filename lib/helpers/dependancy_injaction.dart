import 'package:get/get.dart';
import 'package:split_ride/controllers/auth_controller/sign_in_controller.dart';
import 'package:split_ride/controllers/message/message_controller.dart';
import 'package:split_ride/controllers/passenger_home_controller.dart';
import 'package:split_ride/controllers/review_controller.dart';
import 'package:split_ride/controllers/ride_controllers/ride_details_controller.dart';
import 'package:split_ride/datasource/chat_socket_datasource.dart';

import '../services/socket_services.dart';

class DependencyInjection implements Bindings {
  DependencyInjection();

  @override
  void dependencies() {
    Get.put(SocketClient(), permanent: true);

    Get.put(SignInController());
    Get.put(PassengerHomeController(), permanent: true);
    Get.lazyPut(
      () => ChatSocketDataSource(Get.find<SocketClient>()),
      fenix: true,
    );
    //
    // Get.lazyPut(() => ProfileSetupController(), fenix: true);
    // Get.lazyPut(() => ProfileController(), fenix: true);
    // Get.lazyPut(() => AuthController(), fenix: true);
    // Get.lazyPut(() => NotificationsController(), fenix: true);
    Get.lazyPut(() => RideDetailsController(), fenix: true);
    Get.lazyPut(() => DriverReviewController(), fenix: true);
    Get.lazyPut(() => ChatDriverController(), fenix: true);
  }
}

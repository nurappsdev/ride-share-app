import 'package:get/get.dart';
import 'package:split_ride/controllers/review_controller.dart';
import 'package:split_ride/controllers/ride_controllers/ride_details_controller.dart';

class DependencyInjection implements Bindings {
  DependencyInjection();

  @override
  void dependencies() {
    //
    // Get.lazyPut(() => ProfileSetupController(), fenix: true);
    // Get.lazyPut(() => ProfileController(), fenix: true);
    // Get.lazyPut(() => AuthController(), fenix: true);
    // Get.lazyPut(() => NotificationsController(), fenix: true);
    Get.lazyPut(() => RideDetailsController(), fenix: true);
    Get.lazyPut(() => DriverReviewController(), fenix: true);
  }
}

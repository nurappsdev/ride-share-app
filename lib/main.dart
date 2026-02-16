import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:split_ride/helpers/helpers.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';
import 'package:split_ride/themes/light_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'helpers/dependancy_injaction.dart';
import 'routes/app_routes.dart';
import 'view/screen/spalsh_screen.dart';
import 'view/widgets/widgets.dart';

Future<void> main() async {
  DependencyInjection().dependencies();
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut(() => ConnectivityService());
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // navigatorKey: navigatorKey,
          title: 'Service App',
          home: NoInterNetScreen(child: SplashScreen()),
           getPages: AppRoutes.routes,
          theme: light(),
          themeMode: ThemeMode.light,
          builder: (BuildContext context, Widget? widget) {
            return ToastProvider(child: widget);
          },
        );
      },
      designSize: const Size(393, 852),
    );
  }
}


class NoInterNetScreen extends StatelessWidget {
  final bool? isToast;
  final bool? isAppBar;
  final Widget child;

  const NoInterNetScreen({
    super.key,
    required this.child,
    this.isToast = false,
    this.isAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    return Obx(() {
      final isConnected = connectivityService.isConnected.value;

      return Stack(
        children: [
          child,
          if (!isConnected)
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding:  EdgeInsets.symmetric(horizontal: 50.w),
                  //   child: Image.asset("assets/images/noInternetImage.png"),
                  // ),
                  CustomText(
                    text: "Oops!",
                    fontsize: 30.h,
                    color: Colors.red,
                    top: 10.h,
                    fontWeight: FontWeight.w800,
                    bottom: 10.h,
                  ),
                  CustomText(
                    text:
                        "There was some problem, Check your connection and try again",
                    maxline: 3,
                    left: 30.w,
                    right: 30.w,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}

class ConnectivityService extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;
      print("🔌 Connectivity changed: $result");
      _updateConnectionStatus(result);
    });
  }

  Future<void> _initializeConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    isConnected.value = result != ConnectivityResult.none;
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
    update();
    isConnected.refresh();
  }
}

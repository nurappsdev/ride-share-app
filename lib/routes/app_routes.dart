import 'package:get/get.dart';
import 'package:split_ride/view/screen/driver/complete_profile_screen.dart';
import '../view/screen/screens.dart';

class AppRoutes {
  static const String splashScreen = "/SplashScreen.dart";
  static const String roleScreen = "/roleScreen.dart";
  static const String roleScreen1 = "/roleScreen1.dart";
  static const String signInScreen = "/signInScreen.dart";
  static const String signUpScreen = "/signUpScreen.dart";
  static const String OTPVerifyScreen = "/OTPVerifyScreen.dart";
  static const String allBottomBar = "/allBottomBar";
  static const String splitRideHomeScreen = "/splitRideHomeScreen";
  static const String overViewScreen = "/overViewScreen";
  static const String drawerScreen = "/drawerScreen";
  static const String bookingPaymentScreen = "/bookingPaymentScreen";
  static const String bookingDetailsScreen = "/bookingDetailsScreen";
  static const String myRidesScreen = "/myRidesScreen";
  static const String trackDriversScreen = "/trackDriversScreen";
  static const String driverDetailsScreen = "/driverDetailsScreen";
  static const String driverChatingScreen = "/driverChatingScreen";
  static const String driverReviewScreen = "/driverReviewScreen";
  static const String createReviewScreen = "/createReviewScreen";
  static const String personalInfoScreen = "/personalInfoScreen";
  static const String privacyPolicyAllScreen = "/privacyPolicyAllScreen.dart";
  static const String helpAndSupportScreen = "/helpAndSupportScreen.dart";
  static const String completeProfileScreen = "/completeProfileScreen.dart";
  static const String vehicleDetailsScreen = "/vehicleDetailsScreen.dart";
  static const String driverDocScreen = "/driverDocScreen.dart";
  static const String driverAvailableScreen = "/driverAvailableScreen.dart";
  static const String driverTrackRidesScreen = "/driverTrackRidesScreen.dart";
  static const String passengerDetailsReviewScreen = "/passengerDetailsReviewScreen.dart";
  static const String passengerChatingScreen = "/passengerChatingScreen.dart";
  static const String passengerRideEndScreen = "/passengerRideEndScreen.dart";
  static const String passengerReviewCreateEndScreen = "/passengerReviewCreateEndScreen.dart";
  static const String notificationScreen = "/notificationScreen";
  static const String driverProfileEditScreen = "/driverProfileEditScreen";
  static const String driverPaymentScreen = "/driverPaymentScreen";
  static const String driverMyRideScreen = "/driverMyRideScreen";
  static const String driverMyVehiclesScreen = "/driverMyVehiclesScreen";
  static const String vihicleAddScreen = "/vihicleAddScreen";




  static const String forgotPassScreen = "/forgotPassScreen.dart";
  static const String resetPassScreen = "/resetPassScreen.dart";


  static List<GetPage> get routes => [
    GetPage(name: splashScreen, page: () =>  SplashScreen()),
    GetPage(name: roleScreen, page: () => RoleScreen()),
    GetPage(name: roleScreen1, page: () => RoleScreen1()),
    GetPage(name: signInScreen, page: () => SignInScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: OTPVerifyScreen, page: () => OTPVerificationScreen()),
    GetPage(name: allBottomBar, page: () => AllBottomBar()),
    GetPage(name: splitRideHomeScreen, page: () => SplitRideHomeScreen()),
    GetPage(name: drawerScreen, page: () => CustomDrawer()),
    GetPage(name: bookingPaymentScreen, page: () => PaymentBookingScreen()),
    GetPage(name: bookingDetailsScreen, page: () => BookingDetailsScreen()),
    GetPage(name: myRidesScreen, page: () => MyRidesScreen()),
    GetPage(name: trackDriversScreen, page: () => TrackDriverScreen()),
    GetPage(name: driverDetailsScreen, page: () => DriverDetailsScreen()),
    GetPage(name: driverChatingScreen, page: () => ChatDriverScreen()),
    GetPage(name: driverReviewScreen, page: () => GetReviewScreen()),
    GetPage(name: createReviewScreen, page: () => PassengerReviewSubmit()),
    GetPage(name: personalInfoScreen, page: () => PersonalInfoScreen()),
    GetPage(name: privacyPolicyAllScreen, page: () => PrivacyPolicyAllScreen()),
    GetPage(name: helpAndSupportScreen, page: () => HelpSupportScreen()),
    GetPage(name: completeProfileScreen, page: () => CompleteProfileScreen()),
    GetPage(name: vehicleDetailsScreen, page: () => VihicleDetailsScreen()),
    GetPage(name: driverDocScreen, page: () => DocumentScreen()),
    GetPage(name: driverAvailableScreen, page: () => DriverAvailableRideScreen()),
    GetPage(name: driverTrackRidesScreen, page: () => DriverTrackRidesScreen()),
    GetPage(name: passengerDetailsReviewScreen, page: () => PassengerReviewScreen()),
    GetPage(name: passengerChatingScreen, page: () => ChatingPassenger()),
    GetPage(name: passengerRideEndScreen, page: () => PassengerRideEndScreen()),
    GetPage(name: passengerReviewCreateEndScreen, page: () => PassengerReviewSubmit()),
    GetPage(name: notificationScreen, page: () => NotificationScreen()),
    GetPage(name: driverProfileEditScreen, page: () => DriverProfileEditScreen()),
    GetPage(name: driverPaymentScreen, page: () => MyPaymentScreen()),
    GetPage(name: driverMyRideScreen, page: () => MyRiedsDriverScreen()),
    GetPage(name: driverMyVehiclesScreen, page: () => DriverMyVehiclesScreen()),
    GetPage(name: vihicleAddScreen, page: () => VihicleAddScreen()),
    // GetPage(name: overViewScreen, page: () => OverViewScreen()),

    // GetPage(name: onBoardScreen, page: () => OnboardingScreen()),
    //GetPage(name: signInUpScreen, page: () => SignSignupScreen()),
    // GetPage(name: roleScreen, page: () => RoleScreen()),
    // GetPage(name: providerRoleScreen, page: () => ProviderRoleScreen()),

    // GetPage(name: verifyScreen, page: () => VerifyScreen()),
    // GetPage(name: signInScreen, page: () => SignInScreen()),
    // GetPage(name: forgotPassScreen, page: () => ForgotScreen()),
    // GetPage(name: resetPassScreen, page: () => ResetPasswordScreen()),
    //
  ];

  // static final GoRouter goRouter = GoRouter(
  //     initialLocation: splashScreen,
  //     routes: [
  //       ///===================Splash Screen=================>>>
  //       GoRoute(
  //         path: splashScreen,
  //         name: splashScreen,
  //         builder: (context, state) =>const SplashScreen(),
  //         redirect: (context, state) {
  //           Future.delayed(const Duration(seconds: 3), ()async{
  //             // String role = await PrefsHelper.getString(AppConstants.role);
  //             String token = await PrefsHelper.getString(AppConstants.bearerToken);
  //
  //             if(token.isNotEmpty){
  //               // if(role == "user"){
  //                 AppRoutes.goRouter.replaceNamed(AppRoutes.signInScreen);
  //               // }else{
  //               //   AppRoutes.goRouter.replaceNamed(AppRoutes.managerHomeScreen);
  //               // }
  //             }else{
  //               AppRoutes.goRouter.replaceNamed(AppRoutes.onBoardScreen);
  //             }
  //
  //
  //           });
  //           return null;
  //         },
  //       ),
  //
  // ///=========On Boarding Screen========>>
  //     GoRoute(
  //       path: onBoardScreen,
  //       name: onBoardScreen,
  //       pageBuilder: (context, state) =>
  //        MaterialPage(child: OnboardingScreen()) ,
  //   //builder: (context, state) =>  OnboardingScreen(),
  //   ),
  //
  //   ///=========sign Up Screen========>>
  //
  //   GoRoute(
  //   path: signUpScreen,
  //   name: signUpScreen,
  //   // pageBuilder: (context, state)=>
  //   //     MaterialPage(child: SignUpScreen()) ,
  //   //builder: (context, state) =>  OnboardingScreen(),
  //
  //   ),
  //     ]
  // );
  //
  //
  //   static Page<dynamic> _customTransitionPage(Widget child, GoRouterState state) {
  //     return CustomTransitionPage(
  //       key: state.pageKey,
  //       child: child,
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //         const begin = Offset(1.0, 0.0);
  //         const end = Offset.zero;
  //         const curve = Curves.easeInOut;
  //
  //         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //         var offsetAnimation = animation.drive(tween);
  //
  //         return SlideTransition(position: offsetAnimation, child: child);
  //       },
  //     );
  //   }
  //
}

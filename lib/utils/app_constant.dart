class AppConstants {
  AppConstants._() ;
  ///=======================Prefs Helper data===============================>
  static const String role = "role";
  static String bearerToken = 'token';
  static String resetPasswordToken = 'resetPasswordToken';
  static String email = 'email';
  static String userId = 'userId';
  static String name = 'name';
  static String step = 'step';
  static String status = 'status';
  static String firstname = 'firstName';
  static String lastname = 'lastName';
  static String address = 'address';
  static String isLogged = 'isLogged';
  static String number = 'number';
  static String image = 'image';
  static String dateOfBirth = 'dateOfBrith';

  ///  ============================>  Shahriar  =====================>

  static String googleMapKey = 'AIzaSyAX3YRL9gQ9gCkV5CsTDqUXaWTf6BVFfyA';
  static String verificationToken = 'Verification Token';
  static String accessToken = 'Access Token';
  static String refreshToken = 'Refresh Token';
  static String currentRole = 'Current Role';
  static String providerProfileIsComplete = 'Provider Profile Completion';

  static RegExp emailValidate = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static bool validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{8,}$');
    return regex.hasMatch(value);
  }
}

enum Status { loading, completed, error, internetError }

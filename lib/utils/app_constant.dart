
class AppConstants{

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


  static RegExp emailValidate = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{8,}$');
    return regex.hasMatch(value);
  }



}
enum Status { loading, completed, error, internetError }
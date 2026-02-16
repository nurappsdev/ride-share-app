class AppUrl {
  AppUrl._();

  // static const String baseUrl = 'http://127.0.0.1:8080/api/v1';
  // static const String baseUrl = 'https://6c0hk6c2-8080.inc1.devtunnels.ms/api/v1';
  static const String baseUrl = 'https://6c0hk6c2-8080.inc1.devtunnels.ms';
    static const String imageBaseUrl = '$baseUrl/upload';


  static String registerUser = '$baseUrl/auth/register';
  static String login = '$baseUrl/auth/login';
  static String verifyMail = '$baseUrl/auth/verify-email';
  static String getCarType = '$baseUrl/car-model/all';
  static String driverProfileRegistration = '$baseUrl/provider/complete-profile';
  // static String userPaymentHistoryDetails({required String id}) {
  //   return '${baseUrl}v1/service-bookings/with-costs-summary/$id';
  // }


}

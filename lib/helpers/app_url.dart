class AppUrl {
  AppUrl._();

  // static const String baseUrl = 'http://127.0.0.1:8080/api/v1';
  // static const String baseUrl = 'https://6c0hk6c2-8080.inc1.devtunnels.ms/api/v1';
  static const String baseUrl =
      'https://zbs009tm-8080.asse.devtunnels.ms/api/v1';
  static const String imageUploadUrl = '$baseUrl/upload';
  static const String imageServeUrl = 'https://zbs009tm-8080.asse.devtunnels.ms/uploads';

  static String registerUser = '$baseUrl/auth/register';
  static String login = '$baseUrl/auth/login';
  static String verifyMail = '$baseUrl/auth/verify-email';
  static String getCarType = '$baseUrl/car-model/all';
  static String driverProfileRegistration =
      '$baseUrl/provider/complete-profile';
  static String passengerSavedPlaces = '$baseUrl/user-setting/saved-places';
  static String addPassengerSavedPlaces =
      '$baseUrl/user-setting/add-saved-place';
  static String passengerRemoveSavedPlace =
      '$baseUrl/user-setting/remove-saved-place';
  static String createRide = '$baseUrl/job';

  static String rideUrl(String jobId) => '/job/$jobId';

  static String driveDetailsUrl(String userId) => '/user/single/$userId';

  static String getReviewUrl(String userId) => '/review/$userId';

  /// ===============>
  static String makePayment({required String id}) {
    return '$baseUrl/job/pay/$id';
  }

  static String userProfile = '$baseUrl/user/me';
  static String passengerOngoingRide = '$baseUrl/job/ongoing?limit=100000';

  // static String userPaymentHistoryDetails({required String id}) {
  //   return '${baseUrl}v1/service-bookings/with-costs-summary/$id';
  // }
}

class ApiConstants{


  // static const String baseUrl = "https://api.drop-dr.com/api/v1";
  // static const String imageBaseUrl = "https://api.drop-dr.com/uploads/";
  // static const String socketBaseUrl = "https://api.drop-dr.com";

  static const String baseUrl = "https://health-mamun.sarv.live/api/v1";
  static const String imageBaseUrl = "https://health-mamun.sarv.live/uploads/";
  static const String socketBaseUrl = "https://health-mamun.sarv.live";

/// client key
  ///AIzaSyAxaYzHRBhydkW_TwUGHeRYSUV2iCc_uuk
  static const String mapAPIEndPoint = "AIzaSyAxaYzHRBhydkW_TwUGHeRYSUV2iCc_uuk";
  // from maqmun bro
 //static const String mapAPIEndPoint = "AIzaSyBTNR1NWw7LcTsEJTTogqVZ39tgY--eD5U";

/// amader key
  //static const String mapAPIEndPoint = "AIzaSyA-Iri6x5mzNv45XO3a-Ew3z4nvF4CdYo0";


  static const String signUpEndPoint = "/auth/register";
  static const String signInEndPoint = "/auth/login";
  static const String accountDelete = "/users/delete";
  static const String verifyEmailEndPoint = "/auth/verify-email";
  static const String updateMoreInformationEndPoint = "/employee/update-employee-profile";
  static const String forgotPasswordPoint = "/auth/forgot-password";
  static const String notification = "/notification";
  static const String reviewEndPoint = "/review/";
  static const String history = "/user/get-payment?page=1&limit=300";
  static const String resendOtpEndPoint = "/auth/resend-otp";
  static const String setPasswordEndPoint = "/auth/reset-password";
  static const String changePassword = "/auth/change-password";
  static const String getUserEndPoint = "/user/me";
  static const String uploadImgEndPoint = "/upload";
  static const String doctorProfileSetupEndPoint = "/doctor/complete-profile";
  static const String pharmacyProfileSetupEndPoint = "/pharmacy/complete";
  static const String nurseProfileSetupEndPoint = "/nurse/complete-profile";
  static const String patientProfileSetupEndPoint = "/patient/complete-profile";
  static const String doctorCongraEndPoint = "/doctor/fees";
  static const String doctorUpdateEndPoint = "/user/me";
  static const String addBalance = "/user/add-payment";

  static const String healthTip = "/health-tips";
  static const String doctorForPatient = "/doctor";
  static const String doctorCons = "/doctor-cons";
  static const String nurseCons = "/request";
  static const String medicalHistory = "/prescription/patient/my-prescriptions";
  static const String pharmacy = "/pharmacy";
  static const String patientPharmacy = "/medicine-order/patient/my-orders";
  static const String nurseAppointment = "/request";
  static const String doctorSlot = "/doctor-slot";
  static const String instantCall = "/user/instant-call";
  static const String homeCallNurse = "/user/home-visit";
  static const String nurseSlot = "/nurse/slots";
  static const String nurseSlotPatient = "/nurse/slots/patient";
  static const String nurse = "/nurse";
  static const String doctorConstRequest = "/doctor-cons/request";
  static const String medicineOrder = "/medicine-order";

  static const String nurseAllDataEndPoint = "/request";
  static const String nurseCongraEndPoint = "/nurse/instant-call-fee";
  static const String nurseServiceEndPoint = "/nurse/services";
  static const String nurseServiceDetailsEndPoint = "/request/";
  static const String nurseServiceAcceptEndPoint = "/request/accept/";
  static const String nurseProfileEditEndPoint = "/nurse/edit-profile";
  static const String patientDecline = "/doctor-cons/patient/decline";
  static const String confirmByPatient = "/doctor-cons/confirm";
  static const String completedByPatient = "/doctor-cons/complete";
  static const String completedByPatientNurse = "/request/complete";
  static const String doctorDecline = "/doctor-cons";
  static const String requestNurse = "/request/nurse";
  static const String prescription = "/prescription";

  static const String chatUser = "/message/thread";
  static const String message = "/message";

///--------------pharmacy----------------
  static const String pharmacyAllDataEndPoint = "/medicine-order/pharmacy/my-orders";
  static const String pharmacyMedicineRequestEndPoint = "/medicine-order/";
  static const String pharmacyPrescriptionRequestEndPoint = "/prescription/";


  static const String specializationsEndPoint  = "/dashboard/get-specialization";

}
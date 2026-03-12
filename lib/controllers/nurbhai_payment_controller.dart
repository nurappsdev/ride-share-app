
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:split_ride/routes/app_routes.dart';
import '../helpers/helpers.dart';
import '../services/api_constants.dart';
import '../utils/utils.dart';

class NurBhaiPaymentController {
  // CartController myEntriesController = Get.put(CartController());
  Map<String, dynamic>? paymentIntentData;

  NurBhaiPaymentController() {
    Stripe.publishableKey = PaymentConstants.publishAbleKey;
  }

  Future<PaymentIntent> stripeCheckPaymentIntentTransaction(String piId) async {
    try {
      final paymentIntent = await Stripe.instance.retrievePaymentIntent(piId);
      if (kDebugMode) {
        print("Payment Intent: $paymentIntent");
      }
      return paymentIntent;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching payment intent: $e');
      }
      throw e;
    }
  }

  Future<void> makePayment({required String totalAmount,  BuildContext? context}) async {
    try {
      paymentIntentData = await createPaymentIntent("$totalAmount", "USD");
      if (paymentIntentData != null) {
        String clientSecret = paymentIntentData?['client_secret'] ?? "";

        if (kDebugMode) {
          print("Client Secret: ------------------- ${clientSecret.runtimeType}");
        }

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            billingDetails: const BillingDetails(
                name: '',
                email: 'nur@email.com',
                address: Address(
                    city: 'Dhaka',
                    country: 'Bangladesh',
                    line1: 'Dhaka',
                    line2: 'Dhaka',
                    postalCode: '21214',
                    state: 'Dhaka')),
            googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
            merchantDisplayName: 'Sagor Ahamed',
            paymentIntentClientSecret: clientSecret,
            style: ThemeMode.dark,
          ),
        );
        print("stickersssssssssssssssssss------------> ");
        displayPaymentSheet(amount: totalAmount,context: context);

      }
    } catch (e, s) {
      if (kDebugMode) {
        print('Exception: $e\nStack trace: $s');
      }
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount("$amount"),
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${PaymentConstants.secretKey}', // Use sk_test_... key here
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      if (kDebugMode) {
        print("Payment Intent Response: ${response.body}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print("Error creating payment intent: $e");
      }
      return null;
    }
  }

  String calculateAmount(String amount, ) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  Future<void> displayPaymentSheet({required String amount , BuildContext? context}) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      retrieveTxnId(paymentIntent: paymentIntentData!['id'], amount: amount);

      if (kDebugMode) {
        print('Payment intent: $paymentIntentData');
      }
      showRideBookedDialog(context!);
      SnackBar(
        content: Text("Paid successfully"),
        duration: Duration(seconds: 2), // Duration of the message
      );
      // ToastMessageHelper.successMessageShowToster("Paid successfully");
      paymentIntentData = null;
    } catch (e) {
      if (kDebugMode) {
        print("Error displaying payment sheet: $e");
      }
    }
  }

  Future<void> retrieveTxnId({required String paymentIntent, required String amount}) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/charges?payment_intent=$paymentIntent'),
        headers: {
          "Authorization": "Bearer ${PaymentConstants.secretKey}",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
        var dd = {
          // "stickerIds": stickers,
          "transaction": data['data'][0]['balance_transaction'],
          "amount": amount.toString()
        };
        print("=======================payment data = ${data["data"]}");
        print("======================= body : $dd");
        print(amount.toString());


        final postResponse = await http.post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.paymentEndPoint}'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $bearerToken'
          },
          body: json.encode(dd),
        );

        if (postResponse.statusCode == 200 || postResponse.statusCode == 201) {
          print('Data submitted successfully: ${postResponse.body}');
          // myEntriesController.getCartData();
        } else {
          print('Failed to submit data: ${postResponse.body}');
        }
        if (kDebugMode) {
          ///Need API hit
          print("Transaction Id: ${data['data'][0]['balance_transaction']}");

        }
      }
    } catch (e) {
      throw Exception("Error retrieving transaction ID: $e");
    }
  }

  void showRideBookedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Gradient Check Icon
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF53D8C5),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),

                SizedBox(height: 20.h),

                /// Title
                Text(
                  'Ride Booked Successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),

                SizedBox(height: 8.h),

                /// Booking ID
                RichText(
                  text: TextSpan(
                    text: 'Booking ID: ',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14.sp,
                      color: const Color(0xFF6B6B6B),
                    ),
                    children: [
                      TextSpan(
                        text: 'SR1284E6',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6C4DF6),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                /// Description
                Text(
                  'Thanks for your booking, your ride has been booked successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13.sp,
                    height: 1.4,
                    color: const Color(0xFF9A9A9A),
                  ),
                ),

                SizedBox(height: 24.h),

                /// Gradient Button
                Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF53D8C5),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context);
                    Get.toNamed(AppRoutes.bookingDetailsScreen,preventDuplicates: false);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Text(
                      'View Your Booking',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}




class PaymentConstants{

  static const String publishAbleKey = "pk_test_51OVVcyFiDaJ8bQBjyv4imMqxSbWPo07q81rTzpcw7yUIlXiUBfFThslht2LC8uD5Ec5MuiW1SPyrasy8N6v3MfyJ00d1bz549n";
  static const String secretKey = "sk_test_51OVVcyFiDaJ8bQBjNbxRzrInTwKZ0OX5zQ22QjOwJ5fBJEN4CJx1SkPmwCiDqmvO6UWOYuB5xMvV2SAjszbpCIDk009t0O7BqT";
// }
}
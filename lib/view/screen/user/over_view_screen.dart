import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:split_ride/routes/app_routes.dart';
import 'package:split_ride/view/widgets/address_card.dart';
import '../../../controllers/passenger_home_controller.dart';
import '../screens.dart';

void showRideOverview(BuildContext context) {
  final PassengerHomeController controller =
      Get.find<PassengerHomeController>();

  // Call API to create booking and get price
  controller.bookRide().then((success) {
    if (!success) {
      return; // Error already shown by controller
    }

    // Show overview with calculated data
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overview',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D2D2D),
                              fontFamily: 'Outfit',
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 24.sp,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFFF1F1F1)),

                      AddressCard(
                        fromLocation:
                            controller.calculatedFromAddress.value.isNotEmpty
                            ? controller.calculatedFromAddress.value
                            : controller.fromLocation.value,
                        toLocation:
                            controller.calculatedToAddress.value.isNotEmpty
                            ? controller.calculatedToAddress.value
                            : controller.toLocation.value,
                      ),
                      SizedBox(height: 24.h),

                      // Blue Info Card with Dynamic Data
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF5FF),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            // Total Fare
                            _buildInfoRow(
                              'Booking ID',
                              _formatBookingId('${controller.bookingId.value}'),
                            ),
                            SizedBox(height: 16.h),

                            // Total Fare
                            _buildInfoRow(
                              'Total Fare',
                              '€${controller.calculatedTotalFare.value.toStringAsFixed(2)}',
                              isPrice: true,
                            ),
                            SizedBox(height: 16.h),

                            // Fare Breakdown
                            _buildInfoRow(
                              'Base Fare',
                              '€${controller.calculatedFare.value.toStringAsFixed(2)}',
                            ),
                            SizedBox(height: 16.h),

                            // Service Charge
                            _buildInfoRow(
                              'Service Charge',
                              '€${controller.calculatedCharge.value.toStringAsFixed(2)}',
                            ),
                            SizedBox(height: 16.h),

                            // Distance (use backend distance if available, otherwise use calculated)
                            _buildInfoRow(
                              'Distance',
                              controller.calculatedDistance.value > 0
                                  ? '${controller.calculatedDistance.value.toStringAsFixed(2)} km'
                                  : 'Calculating...',
                            ),
                            SizedBox(height: 16.h),

                            // Car Type
                            _buildInfoRow(
                              'Car Type',
                              '${controller.selectedCarType.value?.name ?? 'N/A'} (${controller.selectedSeats?.value ?? 0} Seater)',
                            ),
                            SizedBox(height: 16.h),

                            // Luggage Info
                            if (controller.selectedLuggageItems.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Luggage Info',
                                    style: TextStyle(
                                      color: const Color(0xFF616161),
                                      fontSize: 15.sp,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: controller.selectedLuggageItems
                                        .map((value) {
                                          return _buildLuggageChip(
                                            value == "duffel_bag"
                                                ? "Duffel Bag"
                                                : value == "sports_bag"
                                                ? "Sports Bag"
                                                : value == "golf_bag"
                                                ? "Golf Bag"
                                                : value.capitalizeFirst ?? '',
                                            const Color(0xFFB3E5FC),
                                          );
                                        })
                                        .toList(),
                                  ),
                                  // Show luggage note if exists
                                  if (controller
                                      .luggageNoteController
                                      .text
                                      .isNotEmpty) ...[
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Note: ${controller.luggageNoteController.text}',
                                      style: TextStyle(
                                        color: const Color(0xFF616161),
                                        fontSize: 13.sp,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 16.h),
                                ],
                              ),

                            // Date & Time
                            _buildInfoRow(
                              'Date & Time',
                              _formatDateTime(
                                controller.selectedDateTime.value,
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Passengers
                            _buildInfoRow(
                              'Passengers',
                              '${controller.passengers.value}',
                            ),
                            SizedBox(height: 16.h),

                            // Ride Type
                            _buildInfoRow(
                              'Ride Type',
                              controller.rideType.value.capitalizeFirst ?? '',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Disclaimer
                      Text(
                        'Disclaimer:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Bookings must be made at least 2 hours in advance. Cancellations made over 24 hours before pickup get a full refund, within 2-24 hours get 50%, and no refund if the driver is on the way or has arrived.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                          height: 1.4,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (value) {},
                            activeColor: Colors.purple,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 15.h),
                              child: Text(
                                'I agree to SplitRide Terms of service',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.only(left: 12.w),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                              height: 1.5.h,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'You may receive SMS notifications from us for security and login purposes and will be used to support your ride experience. Message and data rates may apply. For other purposes also read our ',
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            // Gradient Button
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 20, left: 12, right: 12),
              decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(28.r),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF45C4D9),
                    Color(0xFF6B7FEC),
                    Color(0xFFB565D8),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to payment with booking data
                  Get.toNamed(
                    AppRoutes.bookingPaymentScreen,
                    preventDuplicates: false,
                    arguments: {
                      'bookingId': controller.bookingId.value,
                      'totalFare': controller.calculatedTotalFare.value,
                      'fare': controller.calculatedFare.value,
                      'charge': controller.calculatedCharge.value,
                      'distance': controller.calculatedDistance.value,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Text(
                  'Continue to Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  });
}

// Helper widget for Rows
Widget _buildInfoRow(String label, String value, {bool isPrice = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          color: const Color(0xFF616161),
          fontSize: 15.sp,
          fontFamily: 'Outfit',
        ),
      ),
      Flexible(
        child: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: isPrice ? const Color(0xFF7047EB) : Colors.black,
            fontFamily: 'Outfit',
          ),
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

// Helper widget for Chips
Widget _buildLuggageChip(String label, Color borderColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: borderColor, width: 1.5),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        fontFamily: 'Outfit',
      ),
    ),
  );
}

// Helper: Format BookingId
String _formatBookingId(String? id) {
  if (id == null || id.isEmpty) return 'N/A';

  if (id.length <= 6) return id;
  // If too short, return as it is

  return '${id.substring(0, 3)}....${id.substring(id.length - 3)}';
}

// Helper: Format DateTime
String _formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return 'N/A';

  final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
  return formatter.format(dateTime);
}

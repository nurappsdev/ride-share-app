import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/utils/app_constant.dart';

class LocationAutocompleteWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(double lat, double lng, String address) onLocationSelected;
  final double? biasLatitude;
  final double? biasLongitude;
  final bool readOnly;

  const LocationAutocompleteWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onLocationSelected,
    this.biasLatitude,
    this.biasLongitude,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      boxDecoration: const BoxDecoration(border: Border()),
      textEditingController: controller,
      googleAPIKey: AppConstants.googleMapKey,



      inputDecoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey,
          fontFamily: "Outfit",
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(10.r),
          child: Icon(
            Icons.location_on_outlined,
            color: AppColors.primary3rdColor,
            size: 20.sp,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF7FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34.r),
          borderSide: BorderSide(
            color: AppColors.primary3rdColor,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),

      debounceTime: 600,
      // countries: ["bd"], // Restrict to Bangladesh
      isLatLngRequired: true,

      getPlaceDetailWithLatLng: (Prediction prediction) {
        // This callback gives you the selected place details
        final lat = double.tryParse(prediction.lat ?? '0') ?? 0.0;
        final lng = double.tryParse(prediction.lng ?? '0') ?? 0.0;
        final address = prediction.description ?? '';

        onLocationSelected(lat, lng, address);
      },

      itemClick: (Prediction prediction) {
        controller.text = prediction.description ?? '';
      },

      seperatedBuilder: Divider(
        color: Colors.grey.shade200,
        thickness: 1,
      ),

      // Custom item builder for better styling
      containerHorizontalPadding: 0,
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade100,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary3rdColor,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prediction.structuredFormatting?.mainText ??
                          prediction.description ?? "",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Outfit",
                        color: const Color(0xFF2D3748),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (prediction.structuredFormatting?.secondaryText != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          prediction.structuredFormatting!.secondaryText!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: "Outfit",
                            color: const Color(0xFF6B6B6B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },

      isCrossBtnShown: true,
    );
  }
}
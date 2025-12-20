import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/utils.dart';
import 'widgets.dart';

class CustomButtonCommon extends StatelessWidget {
  final VoidCallback onpress;
  final String title;
  final Color? color;
  final BorderRadius? allBorderRadius;
  final Color? titlecolor;
  final double? height;
  final double? width;
  final double? fontSize;
  final bool loading;
  final bool useGradient;
  final List<Color>? gradientColors;

  const CustomButtonCommon({
    super.key,
    required this.title,
    required this.onpress,
    this.color,
    this.allBorderRadius,
    this.height,
    this.width,
    this.fontSize,
    this.titlecolor,
    this.loading = false,
    this.useGradient = false,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? () {} : onpress,
      child: Container(
        width: width ?? 355.w,
        height: height ?? 60.h,
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          borderRadius: allBorderRadius ?? BorderRadius.circular(30.r),
          color: useGradient ? null : (color ?? AppColors.primaryColor),
          gradient: useGradient
              ? LinearGradient(
            colors: gradientColors ?? [
              const Color(0xFF26C6DA), // Cyan
              const Color(0xFF5B7FE8), // Blue
              const Color(0xFFB259E8), // Purple
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loading
                ? SizedBox(
              height: 20.h,
              width: 20.h,
              child: const CircularProgressIndicator(color: Colors.white),
            )
                : CustomText(
              text: title,
              fontsize: fontSize ?? 20.sp,
              color: titlecolor ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example:
// CustomButtonCommon(
//   title: "Sign Up",
//   onpress: () {},
//   useGradient: true,
// )
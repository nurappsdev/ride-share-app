import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';



class CustomTextButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? padding;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Function onTap;
  final double? radius;
  const CustomTextButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
    this.fontSize,
    this.radius,
    this.textColor,
    this.padding, this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return TextButton(
        onPressed: () {
          onTap();
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.all(padding ?? sizeH * .015),
            backgroundColor: color ?? AppColors.primaryColor,
            //side: const BorderSide(color: Colors.white),
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(side: BorderSide(color: borderColor ?? Colors.transparent),
                borderRadius: BorderRadius.circular(radius ?? sizeH * .05))),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: sizeH * .021,
              fontWeight: FontWeight.w500),
        ));
  }
}

class StyleTextButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final Function onTap;
  final double? radius;
  const StyleTextButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
    this.fontSize,
    this.radius,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return TextButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          text,
          style: TextStyle(
              color: const Color(0xff767676),
              fontSize: sizeH * .018,
              fontWeight: FontWeight.w500),
        ));
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? height;
  final double? padding;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Function onTap;
  final double? radius;

  const CustomButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
    this.fontSize,
    this.radius,
    this.textColor,
    this.padding,
    this.borderColor, this.height,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: height ?? 50.h,
      child: TextButton(
        onPressed: () {
          onTap();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(padding ?? sizeH * .015),
          backgroundColor: color ?? Colors.transparent,
          minimumSize: const Size.fromHeight(50), // safer than fixedSize
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(radius ?? sizeH * .017),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? sizeH * .021,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

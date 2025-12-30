
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Color? borderColor;
  final Color? hinTextColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final List<String>? autofillHints;
  final int? maxLine;
  final double? hinTextSize;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final double? borderRadio;
  final double? validationHeight;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmit;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLine,
    this.validator,
    this.hinTextColor,
    this.borderColor,
    this.isEmail,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscure = '*',
    this.filColor,
    this.hinTextSize,
    this.labelText,
    this.isPassword = false,
    this.readOnly = false,
    this.borderRadio,
    this.onTap,
    this.onFieldSubmit,
    this.onChanged,
    this.validationHeight,
    this.autofillHints,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: widget.onFieldSubmit,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: widget.onChanged,
      autofillHints: widget.autofillHints,
      onTap: widget.onTap,
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscure ?? '*',
      maxLines: widget.maxLine ?? 1,
      validator: widget.validator,
      cursorColor: Colors.black,
      obscureText: widget.isPassword ? obscureText : false,
      style: TextStyle(
        color: Colors.black,
        fontSize: widget.hinTextSize ?? 14,
        fontFamily: "Outfit",
      ),
      decoration: InputDecoration(
        hintMaxLines: 1,
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contentPaddingHorizontal ?? 20,
          vertical: widget.contentPaddingVertical ?? 14,
        ),
        fillColor: widget.filColor ?? Color(0xfff4f4f4),
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: toggle,
          child: Icon(
            obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey,
          ),
        )
            : widget.suffixIcon,
        prefixIconConstraints: const BoxConstraints(minHeight: 20, minWidth: 20),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hinTextColor ?? Colors.grey,
          fontSize: widget.hinTextSize ?? 14,
          fontWeight: FontWeight.w400,
          fontFamily: "Outfit",
        ),
        focusedBorder: _focusedBorder(),
        enabledBorder: _enabledBorder(),
        errorBorder: _errorBorder(),
        focusedErrorBorder: _focusedErrorBorder(),
        border: _focusedBorder(),
        errorMaxLines: 10,
        errorStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: widget.validationHeight,
          fontFamily: "Outfit"
        ),
      ),
    );
  }

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio ?? 30),
      borderSide: BorderSide(
        color: widget.borderColor ?? const Color(0xFF6B7FEC),
        width: 1.5,
      ),
    );
  }

  OutlineInputBorder _enabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio ?? 30),
      borderSide: BorderSide(
        color: widget.borderColor ?? const Color(0xFFE2E8F0),
        width: 0.8,
      ),
    );
  }

  OutlineInputBorder _errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio ?? 30),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 0.8,
      ),
    );
  }

  OutlineInputBorder _focusedErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio ?? 30),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    );
  }
}

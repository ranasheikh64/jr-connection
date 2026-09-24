import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

enum ValidationType { none, email, password, username, phone, required }

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final ValidationType validationType;
  final String? Function(String?)? customValidator;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validationType = ValidationType.none,
    this.customValidator,
    this.inputFormatters,
    this.onChanged,
  });

  // Encapsulated Validation Logic
  String? _validate(String? value) {
    if (customValidator != null) {
      return customValidator!(value);
    }

    if (validationType != ValidationType.none && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }

    if (value != null && value.isNotEmpty) {
      switch (validationType) {
        case ValidationType.email:
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return 'Enter a valid email address';
          }
          break;
        case ValidationType.password:
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          break;
        case ValidationType.username:
          if (value.length < 3) {
            return 'Username must be at least 3 characters';
          }
          break;
        case ValidationType.phone:
          final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
          if (!phoneRegex.hasMatch(value)) {
            return 'Enter a valid phone number';
          }
          break;
        case ValidationType.required:
        case ValidationType.none:
          break;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: _validate,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: AppColors.textPrimary.withOpacity(0.5),
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon, 
                color: AppColors.textPrimary.withOpacity(0.6), 
                size: 20.sp,
              )
            : null,
        suffixIcon: suffixIcon, // Allows passing a custom Widget like the success checkmark
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(isFocused: true),
        errorBorder: _buildBorder(isError: true),
        focusedErrorBorder: _buildBorder(isError: true),
      ),
    );
  }

  OutlineInputBorder _buildBorder({bool isFocused = false, bool isError = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(
        color: isError 
            ? Colors.red 
            : isFocused 
                ? AppColors.primaryGradientStart 
                : AppColors.borderColor,
        width: isFocused ? 1.5 : 1.0,
      ),
    );
  }
}

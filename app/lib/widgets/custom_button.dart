import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

enum ButtonType { primary, secondary }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  
  // For secondary button only (e.g. "Already have a Circle account? ")
  final String? prefixText;
  
  // For primary button only (e.g. Icons.arrow_forward_rounded)
  final IconData? icon;
  
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.prefixText,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.secondary) {
      return _buildSecondaryButton();
    }
    return _buildPrimaryButton();
  }

  Widget _buildPrimaryButton() {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradientEnd.withOpacity(0.35),
            offset: const Offset(0, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9999.r),
          onTap: isLoading ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  height: 20.sp,
                  width: 20.sp,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2.5,
                  ),
                )
              else ...[
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans', // Make sure to add this font in pubspec.yaml
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    color: AppColors.white,
                    letterSpacing: 0.15,
                  ),
                ),
                if (icon != null) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    icon,
                    color: AppColors.white,
                    size: 18.sp,
                  ),
                ]
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return Container(
      width: double.infinity,
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(9999.r),
        border: Border.all(
          color: AppColors.white.withOpacity(0.8),
          width: 1,
        ),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9999.r),
          onTap: isLoading ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  height: 18.sp,
                  width: 18.sp,
                  child: CircularProgressIndicator(
                    color: AppColors.secondaryText,
                    strokeWidth: 2.5,
                  ),
                )
              else ...[
                if (prefixText != null)
                  Text(
                    prefixText!,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                      color: AppColors.secondaryText,
                      letterSpacing: 0.195,
                    ),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    color: AppColors.secondaryText,
                    letterSpacing: 0.195,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.secondaryText.withOpacity(0.4),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

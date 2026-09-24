import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturePills extends StatelessWidget {
  const FeaturePills({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPill(
          icon: Icons.stars_rounded,
          text: 'Curated Circles',
          textColor: const Color(0xFF006194),
        ),
        SizedBox(width: 8.w),
        _buildPill(
          icon: Icons.lock_rounded,
          text: 'Parent Approved',
          textColor: const Color(0xFF00687A),
        ),
      ],
    );
  }

  Widget _buildPill({required IconData icon, required String text, required Color textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(9999.r),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
              color: textColor,
              letterSpacing: 0.44,
            ),
          ),
        ],
      ),
    );
  }
}

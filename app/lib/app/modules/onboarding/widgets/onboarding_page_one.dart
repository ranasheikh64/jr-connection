import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'safe_peer_badge.dart';
import 'feature_pills.dart';

class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            const SafePeerBadge(),
            const Spacer(),
            // App Logo placeholder (replace with actual image from assets later)
            Container(
              height: 112.h,
              width: 112.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Center(
                child: Icon(Icons.hub_rounded, size: 48.sp, color: const Color(0xFF006194)),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Jr. Connection',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w700,
                fontSize: 28.sp,
                color: const Color(0xFF131B2E),
                letterSpacing: -0.7,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Connect. Discover. Communicate.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: const Color(0xFF3F4850),
                letterSpacing: 0.35,
              ),
            ),
            SizedBox(height: 24.h),
            const FeaturePills(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

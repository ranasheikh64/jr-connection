import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            _buildTopBar(),
            const Spacer(),
            // Map/Radar placeholder
            Container(
              height: 250.h,
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF006194).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: Container(
                  height: 180.h,
                  width: 180.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00687A).withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on,
                      color: const Color(0xFF006194),
                      size: 40.sp,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Discover New\nConnections',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w800,
                fontSize: 28.sp,
                color: const Color(0xFF131B2E),
                letterSpacing: -0.7,
                height: 1.2,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Find interesting people around you based on\ndistance, age, gender and passions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: const Color(0xFF3F4850),
              ),
            ),
            SizedBox(height: 20.h),
            _buildSafeSpaceBadge(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 32.sp,
              width: 32.sp,
              decoration: const BoxDecoration(
                color: Color(0xFF006194),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.hub_rounded, color: Colors.white, size: 16.sp),
            ),
            SizedBox(width: 8.w),
            Text(
              'Jr. Connection',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                color: const Color(0xFF006194),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Skip',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: const Color(0xFF006194),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSafeSpaceBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(9999.r),
        border: Border.all(color: const Color(0xFFE2E7FF), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_rounded,
            color: const Color(0xFF00687A),
            size: 12.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            'Parent-Approved Safe Space',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
              color: const Color(0xFF00687A),
              letterSpacing: 0.275,
            ),
          ),
        ],
      ),
    );
  }
}

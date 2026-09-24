import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    this.pageCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: isActive ? 28.w : 8.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999.r),
            gradient: isActive 
                ? const LinearGradient(
                    colors: [Color(0xFF006194), Color(0xFF57DFFE)],
                  )
                : null,
            color: isActive ? null : const Color(0xFFBFC7D2).withOpacity(0.6),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF006194).withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_page_one.dart';
import '../widgets/onboarding_page_two.dart';
import '../widgets/page_indicator.dart';
import '../../../../widgets/custom_button.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F9FF),
              Color(0xFFE0F2FE),
              Color(0xFFBAE6FD),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: const [
                    OnboardingPageOne(),
                    OnboardingPageTwo(),
                    Center(child: Text('Page 3 placeholder')),
                  ],
                ),
              ),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Obx(() {
        return Column(
          children: [
            PageIndicator(currentIndex: controller.currentPage.value),
            SizedBox(height: 24.h),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: controller.currentPage.value == 0
                  ? Column(
                      key: const ValueKey(0),
                      children: [
                        CustomButton(
                          text: 'Get Started',
                          onPressed: () {
                            controller.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: Icons.arrow_forward_rounded,
                        ),
                        SizedBox(height: 16.h),
                        CustomButton(
                          text: 'Sign In',
                          prefixText: 'Already have a Circle account? ',
                          type: ButtonType.secondary,
                          onPressed: () {},
                        ),
                        SizedBox(height: 24.h),
                        _buildPrivacyText(),
                      ],
                    )
                  : Column(
                      key: const ValueKey(1),
                      children: [
                        CustomButton(
                          text: 'Continue',
                          onPressed: () {
                            if (controller.currentPage.value < 2) {
                              controller.pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              // TODO: Go to Home or Login
                            }
                          },
                          icon: Icons.arrow_forward_rounded,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Strict age-verified matching • Encrypted profiles',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: const Color(0xFF707881),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPrivacyText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shield_rounded, color: const Color(0xFF3F4850), size: 14.sp),
        SizedBox(width: 6.w),
        Text(
          'Privacy-First Social Network • End-to-End Encrypted',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
            fontSize: 11.sp,
            color: const Color(0xFF3F4850),
            letterSpacing: 0.44,
          ),
        ),
      ],
    );
  }
}

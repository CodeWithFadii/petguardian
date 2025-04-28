import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/constants/app_colors.dart';

class OnboardingIndicatorWidget extends StatelessWidget {
  final int index;

  const OnboardingIndicatorWidget({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(5, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              height: 12,
              width: i == index ? 40 : 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: i == index ? AppColors.primary : Color(0xffE6E6E6),
              ),
            );
          }),
        ],
      ),
    );
  }
}

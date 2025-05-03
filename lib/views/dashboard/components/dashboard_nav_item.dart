import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/constants/app_colors.dart';
import '../../../resources/widgets/app_text_widget.dart';

class DashboardNavItem extends StatelessWidget {
  const DashboardNavItem({super.key, required this.icon, required this.title, required this.index});

  final String icon, title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dashboardC.selectedIndex = index,
      child: Obx(() {
        return AnimatedAlign(
          alignment: dashboardC.selectedIndex == index ? Alignment.center : Alignment.topCenter,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutBack,
          child: AnimatedOpacity(
            opacity: dashboardC.selectedIndex == index ? 1.0 : 0.7,
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  icon,
                  color: dashboardC.selectedIndex == index ? AppColors.primary : Colors.grey,
                  height: 3.h,
                  width: 5.4.w,
                ),
                SizedBox(height: 1.h),
                AppTextWidget(
                  text: title,
                  fontSize: 14.5,
                  color: dashboardC.selectedIndex == index ? AppColors.primary : Colors.grey,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/constants/app_colors.dart';
import '../../../resources/constants/app_icons.dart';
import '../../../resources/constants/constants.dart';
import 'dashboard_nav_item.dart';

class DashboardNavbar extends StatelessWidget {
  const DashboardNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.3.h),
      margin: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 4.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(64), color: AppColors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 1,
                  child: DashboardNavItem(
                    icon: dashboardC.selectedIndex == 0 ? AppIcons.homeFilled : AppIcons.homeOutlined,
                    title: 'Home',
                    index: 0,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DashboardNavItem(icon: AppIcons.activity, title: 'My Pets', index: 1),
                ),
                Expanded(
                  flex: 1,
                  child: DashboardNavItem(
                    icon:
                        dashboardC.selectedIndex == 2
                            ? AppIcons.notificationFilled
                            : AppIcons.notificationOutline,
                    title: 'Reminders',
                    index: 2,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

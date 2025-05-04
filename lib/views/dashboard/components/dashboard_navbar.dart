import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/constants/app_colors.dart';
import '../../../resources/constants/app_icons.dart';
import 'dashboard_nav_item.dart';

class DashboardNavbar extends StatelessWidget {
  const DashboardNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.3.h),
      margin: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 5.w),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 8,
                child: DashboardNavItem(icon: AppIcons.homeOutlined, title: 'Home', index: 0),
              ),
              Expanded(flex: 8, child: DashboardNavItem(icon: AppIcons.activity, title: 'My Pets', index: 1)),
              Expanded(flex: 8, child: DashboardNavItem(icon: AppIcons.forum, title: 'Forum', index: 2)),
              Expanded(
                flex: 11,
                child: DashboardNavItem(icon: AppIcons.notificationOutline, title: 'Notifications', index: 3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

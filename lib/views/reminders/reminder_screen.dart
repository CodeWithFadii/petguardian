import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/utils.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_icons.dart';
import '../../resources/widgets/app_text_widget.dart';

class ReminderScreen extends StatelessWidget {
  ReminderScreen({super.key});

  // Mock Data (Replace with real data in actual app)
  final List<Map<String, String>> mockNotifications = [
    {
      "title": "New Announcement",
      "body": "We’ve added new features to your app.",
      "createdDate": DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
    },
    {
      "title": "Reminder",
      "body": "Don’t forget to check the latest updates.",
      "createdDate": DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Divider()),
                  AppTextWidget(
                    text: 'Reminders',
                    fontWeight: FontWeight.w500,
                    fontSize: 17.5,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView.builder(
                  itemCount: mockNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = mockNotifications[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(1.2.h),
                            height: 6.h,
                            width: 12.w,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.secondary),
                            child: SvgPicture.asset(AppIcons.announcement, color: AppColors.black),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: AppTextWidget(
                                        text: notification["title"]!,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    AppTextWidget(
                                      text: '12/04/2025',
                                      color: const Color(0xffAAAFB6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                AppTextWidget(
                                  color: const Color(0xff585A5B),
                                  text: notification["body"]!,
                                  fontSize: 15.5,
                                  padding: EdgeInsets.only(right: 5.w),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  height: 1.3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_icons.dart';
import '../../resources/widgets/app_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    text: 'Home',
                    fontWeight: FontWeight.w500,
                    fontSize: 17.5,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 1.6.h),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(8)),
                child: AppTextWidget(
                  text: 'Go Premium — Enjoy an Ad-Free Experience! 👑',
                  height: 1.3,
                  fontSize: 15,
                  fontFamily: headingFont,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

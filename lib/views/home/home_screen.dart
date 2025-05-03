import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:sizer/sizer.dart';

import '../../resources/widgets/app_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 1.6.h, horizontal: 4.w),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(8)),
                child: AppTextWidget(
                  text: 'Go Premium — Enjoy an Ad-Free Experience! 👑',
                  height: 1.3,
                  fontSize: 15,
                  fontFamily: headingFont,
                ),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView.builder(
                  itemCount: homeTextList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: homeNavigateList[index],
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                        margin: EdgeInsets.only(bottom: 2.h), // Add spacing between list items
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.secondary,
                              child: SvgPicture.asset(
                                homeIconsList[index],
                                height: 20,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            AppTextWidget(text: homeTextList[index], fontWeight: FontWeight.w600),
                            Spacer(),
                            AppTextWidget(text: '→', fontFamily: headingFont, fontSize: 20),
                          ],
                        ),
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

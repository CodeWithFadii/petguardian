import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_images.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/utils.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:sizer/sizer.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/widgets/app_text_widget.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 5.w, top: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SizedBox(height: 5.5.h, width: 11.w, child: SvgPicture.asset(AppIcons.backButton)),
                  ),
                  SizedBox(width: 5.w),
                  AppTextWidget(text: 'User Detail', fontWeight: FontWeight.w500, fontSize: 17.5),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Utils().showConfirmDialog(
                        title: "Block User",
                        description:
                            "Are you sure you want to block this user? You won’t see their posts anymore.",
                        onConfirm: () {},
                      );
                    },
                    child: Icon(Icons.report_outlined),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 5.h),
                      CircleAvatar(
                        backgroundColor: AppColors.secondary,
                        radius: 50,
                        child: AppTextWidget(
                          text: 'F',
                          fontFamily: headingFont,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      AppTextWidget(
                        text: 'Fahad Ali',
                        fontFamily: headingFont,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 6.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppTextWidget(
                          text: 'User pets',
                          fontFamily: headingFont,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 2, // Replace with dynamic list count later
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 2.h),
                            padding: EdgeInsets.only(left: 3.w, top: 1.4.h, bottom: 1.4.h),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundImage: AssetImage(index == 0 ? AppImages.dog : AppImages.cat),
                                ),
                                SizedBox(width: 3.w),
                                AppTextWidget(
                                  fontFamily: headingFont,
                                  text: index == 0 ? 'Jackie' : 'Alee',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_images.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/views/my_pets/components/health_chart.dart';
import 'package:sizer/sizer.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/widgets/app_text_widget.dart';
import 'components/feeding_chart.dart';
import 'components/grooming_chart.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 5.w, top: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SizedBox(height: 5.5.h, width: 11.w, child: SvgPicture.asset(AppIcons.backButton)),
                  ),
                  SizedBox(width: 5.w),
                  AppTextWidget(text: 'Jackie', fontWeight: FontWeight.w500, fontSize: 17.5),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),
                      FeedingChart(),
                      SizedBox(height: 4.h),
                      HealthChart(),
                      SizedBox(height: 4.h),
                      GroomingChart(),
                      SizedBox(height: 4.h),
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

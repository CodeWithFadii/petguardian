import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/widgets/app_text_widget.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 12.h, right: 2.w),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(RoutesName.addPetScreen),
          elevation: 0,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Divider()),
                  AppTextWidget(
                    text: 'Activity',
                    fontWeight: FontWeight.w500,
                    fontSize: 17.5,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 2.h),
                    AppTextWidget(text: 'No pets to track activity', fontWeight: FontWeight.w600),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

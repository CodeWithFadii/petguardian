import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/widgets/app_button_widget.dart';
import '../../resources/widgets/app_text_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              SvgPicture.asset(AppImages.onboarding),
              SizedBox(height: 6.h),
              AppTextWidget(
                fontWeight: FontWeight.w600,
                fontSize: 17.5,

                text: 'Choose your preferred registration method and start your journey today!',
                height: 1.5,
              ),
              SizedBox(height: 10.h),
              AppButtonWidget(
                padding: EdgeInsets.symmetric(vertical: 1.65.h),
                leading: Icon(Icons.mail_outline, color: AppColors.white),
                text: 'Continue with Email',
                onTap: () {
                  Get.toNamed(RoutesName.signupScreen);
                },
              ),
              SizedBox(height: 2.h),
              AppButtonWidget(
                padding: EdgeInsets.symmetric(vertical: 1.65.h),
                leading: SvgPicture.asset(AppIcons.google),
                textColor: AppColors.black,
                text: 'Continue with Google',
                color: AppColors.secondary,
                onTap: () {
                  Get.toNamed(RoutesName.dashboard);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

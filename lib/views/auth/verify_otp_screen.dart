import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/constants.dart';
import '../../resources/routes/routes_name.dart';
import '../../resources/widgets/app_button_widget.dart';
import '../../resources/widgets/app_text_widget.dart';
import 'components/terms_and _conditions.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextWidget(
                text: 'Verify Otp',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                fontFamily: headingFont,
              ),
              SizedBox(height: 8.h),
              Center(
                child: Pinput(
                  onTapOutside: (event) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  showCursor: true,
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.primary),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(color: AppColors.white),
                  ),
                  pinAnimationType: PinAnimationType.fade,
                ),
              ),
              SizedBox(height: 2.h),
              AppTextWidget(text: 'Enter the OTP sent to your email to continue.', fontSize: 14, height: 1.3),
              SizedBox(height: 5.h),
              AppButtonWidget(
                text: 'Verify Otp',
                onTap: () {
                  Get.toNamed(RoutesName.dashboard);
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.5.h, top: 2.2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTextWidget(height: 1.2, fontSize: 16, text: 'Didn’t receive code?'),
                    SizedBox(width: 1.w),
                    GestureDetector(
                      child: AppTextWidget(
                        height: 1.2,
                        fontSize: 16,
                        text: 'Resend',
                        color: AppColors.primary,
                      ),
                    ),
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

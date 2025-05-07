import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_validators.dart';
import '../../resources/routes/routes_name.dart';
import '../../resources/widgets/app_button_widget.dart';
import '../../resources/widgets/app_text_widget.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SafeArea(
        child: GlobalLoader(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextWidget(
                    text: 'Sign up',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: headingFont,
                  ),
                  SizedBox(height: 8.h),
                  AppTextField(
                    hintText: 'User Name',
                    suffixIcon: Icon(Icons.person_outline),
                    controller: authC.signUpNameC,
                    validator: (value) {
                      return AppValidators.validateName(value);
                    },
                  ),
                  SizedBox(height: 2.h),
                  AppTextField(
                    hintText: 'Email Address',
                    suffixIcon: Icon(Icons.mail_outline),
                    controller: authC.signUpEmailC,
                    validator: (value) {
                      return AppValidators.validateEmail(value);
                    },
                  ),
                  SizedBox(height: 2.h),
                  AppTextField(
                    hintText: 'Password',
                    obscureText: true,
                    controller: authC.signUpPasswordC,
                    maxLines: 1,
                    validator: (value) {
                      return AppValidators.validatePassword(value);
                    },
                  ),
                  SizedBox(height: 1.5.h),
                  AppTextWidget(
                    fontSize: 13.5,

                    textAlign: TextAlign.left,
                    height: 1.3,
                    text: 'Password must contain at least one letter, one number, and one special character.',
                  ),
                  // TermsAndConditions(),
                  SizedBox(height: 7.h),
                  AppButtonWidget(
                    text: 'Signup',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        authC.checkEmailExist(context: context);
                      }
                    },
                  ),
                  SizedBox(height: 1.5.h),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        height: 1.4,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(RoutesName.loginScreen);
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

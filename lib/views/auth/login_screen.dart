import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/constants/constants.dart';
import '../../resources/routes/routes_name.dart';
import '../../resources/widgets/app_button_widget.dart';
import '../../resources/widgets/app_text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    text: 'Login',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: headingFont,
                  ),
                  SizedBox(height: 8.h),
                  AppTextField(
                    hintText: 'Email Address',
                    suffixIcon: Icon(Icons.mail_outline),
                    controller: authC.emailC,
                  ),
                  SizedBox(height: 2.h),
                  AppTextField(
                    hintText: 'Password',
                    suffixIcon: Icon(Icons.visibility_outlined),
                    obscureText: true,
                    controller: authC.passwordC,
                    maxLines: 1,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {},
                      child: AppTextWidget(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        text: 'Forget Password?',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  SizedBox(height: 7.h),
                  AppButtonWidget(
                    text: 'Login',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        authC.login(context: context);
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
                        const TextSpan(text: 'Doesn’t have an account? '),
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.back();
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

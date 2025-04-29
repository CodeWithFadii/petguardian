import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/routes/routes_name.dart';
import '../../resources/widgets/app_button_widget.dart';
import '../../resources/widgets/app_text_widget.dart';
import 'components/terms_and _conditions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? nameC;
  TextEditingController? emailC;
  TextEditingController? passwordC;

  @override
  void initState() {
    nameC = TextEditingController();
    emailC = TextEditingController();
    passwordC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameC!.dispose();
    emailC!.dispose();
    passwordC!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SafeArea(
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
                  controller: nameC,
                ),
                SizedBox(height: 2.h),
                AppTextField(
                  hintText: 'Email Address',
                  suffixIcon: Icon(Icons.mail_outline),
                  controller: emailC,
                ),
                SizedBox(height: 2.h),
                AppTextField(
                  hintText: 'Password',
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  obscureText: true,
                  controller: passwordC,
                  maxLines: 1,
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
                  onTap: () {
                    // if (formKey.currentState!.validate()) {
                    Get.toNamed(RoutesName.verifyOtpScreen);
                    // }
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
    );
  }
}

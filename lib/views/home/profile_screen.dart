import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:petguardian/resources/widgets/shimmer_cached_image.dart';
import 'package:sizer/sizer.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/constants/app_validators.dart';
import '../../resources/widgets/app_text_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GlobalLoader(
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
                      child: SizedBox(
                        height: 5.5.h,
                        width: 11.w,
                        child: SvgPicture.asset(AppIcons.backButton),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    AppTextWidget(text: 'My Profile', fontWeight: FontWeight.w500, fontSize: 17.5),
                  ],
                ),
                SizedBox(height: 4.h),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      return CircleAvatar(
                        radius: 70,
                        backgroundColor: AppColors.secondary,
                        backgroundImage:
                            settingC.selectedImage != null
                                ? FileImage(settingC.selectedImage!)
                                : NetworkImage(userC.user!.img!),
                        child:
                            userC.user!.img!.isNotEmpty
                                ? SizedBox.shrink()
                                : AppTextWidget(text: 'F', fontFamily: headingFont, fontSize: 20),
                      );
                    }),
                    GestureDetector(
                      onTap: () => settingC.pickImage(),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.camera_alt_outlined, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                AppTextField(
                  hintText: 'User Name',
                  suffixIcon: Icon(Icons.person_outline),
                  controller: settingC.nameC,
                  validator: (value) {
                    return AppValidators.validateName(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppButtonWidget(
        onTap: () => settingC.updateProfile(context: context),
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        text: 'Update Profile',
      ),
    );
  }
}

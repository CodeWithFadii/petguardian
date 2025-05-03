import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:petguardian/resources/widgets/custom_check_box.dart';
import 'package:sizer/sizer.dart';
import '../../../resources/constants/app_colors.dart';
import '../../../resources/constants/app_images.dart';
import '../../my_pets/my_pets_screen.dart';

class MyDogsListWidget extends StatelessWidget {
  const MyDogsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures the column takes only necessary height
          children: [
            SizedBox(height: 1.5.h),
            AppTextWidget(
              text: 'Select Pets',
              fontWeight: FontWeight.w500,
              fontFamily: headingFont,
              fontSize: 17,
            ),
            SizedBox(height: 1.5.h),
            Divider(),
            // Comment list takes available space and scrolls independently
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2, // Adjusted to test with many comments
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  return Row(
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
                      Spacer(),
                      CustomCheckBox(isChecked: true, onChanged: (value) {}),
                    ],
                  );
                },
              ),
            ),
            AppButtonWidget(
              text: 'Save',
              margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

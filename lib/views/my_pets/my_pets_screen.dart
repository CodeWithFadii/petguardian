import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_images.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/widgets/app_text_widget.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

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
                    text: 'My Pets',
                    fontWeight: FontWeight.w500,
                    fontSize: 17.5,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(top: 2.h),
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.4.h),
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
                            text: index == 0 ? 'Jackie' : 'Alee',
                            fontSize: 16.5,
                            fontWeight: FontWeight.w600,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () => Get.toNamed(RoutesName.editPetScreen),
                            child: CircleAvatar(
                              backgroundColor: AppColors.bg,
                              child: Icon(Icons.settings_outlined, color: AppColors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Expanded(
              //   child: AppTextWidget(
              //     height: 1.3,
              //     padding: EdgeInsets.symmetric(horizontal: 10.w),
              //     text: 'No pets here – time to add your first furry friend!',
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

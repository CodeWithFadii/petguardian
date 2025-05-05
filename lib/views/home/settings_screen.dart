import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:petguardian/resources/utils.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_icons.dart';
import '../../resources/widgets/app_text_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SizedBox(height: 5.5.h, width: 11.w, child: SvgPicture.asset(AppIcons.backButton)),
                  ),
                  SizedBox(width: 5.w),
                  AppTextWidget(text: 'Settings', fontWeight: FontWeight.w500, fontSize: 17.5),
                ],
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView.builder(
                  itemCount: settingsTextList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.toNamed(RoutesName.profileScreen);
                            break;
                          case 1:
                            Get.toNamed(RoutesName.blockedUsersScreen);
                            break;
                          case 2:
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Logout'),
                                  content: Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
                                    TextButton(
                                      onPressed: () async {
                                        await FirebaseAuth.instance.signOut();
                                        await GoogleSignIn().signOut();
                                        Utils.showMessage('Logged out successfully', context: context);
                                        Get.offAllNamed(RoutesName.welcomeScreen);
                                      },
                                      child: Text('Logout'),
                                    ),
                                  ],
                                );
                              },
                            );
                            break;
                          case 3:
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Account'),
                                  content: Text(
                                    'This action is permanent. Are you sure you want to delete your account?',
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
                                    TextButton(
                                      onPressed: () async {
                                        Get.back();
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                            break;
                        }
                      },

                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                        margin: EdgeInsets.only(bottom: 2.h), // Add spacing between list items
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.secondary,
                              child: SvgPicture.asset(
                                settingsIconsList[index],
                                height: 20,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            AppTextWidget(text: settingsTextList[index], fontWeight: FontWeight.w600),
                            Spacer(),
                            AppTextWidget(text: '→', fontFamily: headingFont, fontSize: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

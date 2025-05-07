import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/user_model.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_images.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/utils.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:sizer/sizer.dart';
import '../../models/pet_model.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/widgets/app_text_widget.dart';
import '../../resources/widgets/loader.dart';
import '../../resources/widgets/shimmer_cached_image.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userData = Get.arguments?['userData'];
    return Scaffold(
      body: SafeArea(
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
                    child: SizedBox(height: 5.5.h, width: 11.w, child: SvgPicture.asset(AppIcons.backButton)),
                  ),
                  SizedBox(width: 5.w),
                  AppTextWidget(text: 'User Detail', fontWeight: FontWeight.w500, fontSize: 17.5),
                  Spacer(),
                  if (userData.id != uid)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Block User'),
                              content: Text(
                                'Are you sure you want to block this user? You won’t see their posts anymore.',
                              ),
                              actions: [
                                TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    userC.updateBlocks(userId: userData.id!, context: context);
                                    Get.back();
                                  },
                                  child: Text('Block'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(Icons.report_outlined),
                    ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 5.h),
                      userData.img!.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 50,
                              child: ShimmerCachedImage(imageUrl: userData.img!),
                            ),
                          )
                          : CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.secondary,
                            child: AppTextWidget(
                              text: Utils.getInitial(userData.name!),
                              fontFamily: headingFont,
                            ),
                          ),
                      SizedBox(height: 2.h),
                      AppTextWidget(
                        text: userData.name ?? '',
                        fontFamily: headingFont,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 6.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppTextWidget(
                          text: 'User pets',
                          fontFamily: headingFont,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      StreamBuilder<List<PetModel>>(
                        stream: addPetInfoC.userPetsStream(userId: userData.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Loader();
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: AppTextWidget(text: 'Error: ${snapshot.error}', height: 1.3),
                            );
                          }
                          if (!snapshot.hasData) {
                            return Center(child: AppTextWidget(text: 'No pets found.', height: 1.3));
                          }
                          final pets = snapshot.data ?? [];
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: pets.length, // Replace with dynamic list count later
                            itemBuilder: (context, index) {
                              final pet = pets[index];
                              return Container(
                                margin: EdgeInsets.only(top: 2.h),
                                padding: EdgeInsets.only(left: 3.w, top: 1.4.h, bottom: 1.4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.secondary,
                                        radius: 26,
                                        child: ShimmerCachedImage(imageUrl: pet.imageUrl),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    AppTextWidget(
                                      fontFamily: headingFont,
                                      text: pet.name,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

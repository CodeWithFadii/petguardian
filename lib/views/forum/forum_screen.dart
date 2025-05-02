import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../resources/routes/routes_name.dart';
import '../../resources/utils.dart';
import 'components/comment_section.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 12.h, right: 2.w),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(RoutesName.addPostScreen),
          elevation: 0,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            children: [
              AppTextField(
                hintText: 'Search Posts by Tag',
                suffixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              GestureDetector(
                                onTap: () => Get.toNamed(RoutesName.otherUserProfile),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.secondary,
                                      child: AppTextWidget(text: 'F', fontFamily: headingFont),
                                    ),
                                    AppTextWidget(
                                      text: 'Fahad Ali',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      fontFamily: headingFont,
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Utils().showConfirmDialog(
                                    title: "Block User",
                                    description:
                                        "Are you sure you want to block this user? You won’t see their posts anymore.",
                                    onConfirm: () {},
                                  );
                                },
                                child: Icon(Icons.report_outlined),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.bg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(height: 2.h),

                          ReadMoreText(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s ",
                            trimLines: 2,
                            colorClickableText: AppColors.black,
                            trimMode: TrimMode.Line,
                            moreStyle: TextStyle(fontWeight: FontWeight.w600),
                            lessStyle: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Column(
                                spacing: 6,
                                children: [
                                  Icon(Icons.favorite_outline, size: 26),
                                  AppTextWidget(text: '1.5k', fontSize: 14),
                                ],
                              ),
                              SizedBox(width: 5.w),
                              Column(
                                spacing: 6,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        useSafeArea: true,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return CommentsSection();
                                        },
                                      );
                                    },
                                    child: Icon(Icons.comment_outlined, size: 26),
                                  ),
                                  AppTextWidget(text: '320', fontSize: 14),
                                ],
                              ),
                              Spacer(),
                              Icon(Icons.watch_later_outlined),
                              SizedBox(width: 2.w),
                              AppTextWidget(text: '2 hours ago', fontSize: 14),
                            ],
                          ),
                        ],
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

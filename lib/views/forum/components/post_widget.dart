import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/constants/app_images.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/routes/routes_name.dart';
import '../../../resources/utils.dart';
import 'comment_section.dart';

class PostWidget extends StatelessWidget {
  final bool isEdit;
  const PostWidget({super.key, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 20, offset: Offset(0, 20))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Row(
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
                if (isEdit)
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RoutesName.editPostScreen);
                    },
                    child: Icon(Icons.edit_outlined),
                  ),
                if (!isEdit)
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
          ),
          SizedBox(height: 1.5.h),
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.bg,
              image: DecorationImage(image: AssetImage(AppImages.dogPost), fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 1.5.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: ReadMoreText(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s ",
              trimLines: 2,
              colorClickableText: AppColors.black,
              trimMode: TrimMode.Line,
              moreStyle: TextStyle(fontWeight: FontWeight.w600),
              lessStyle: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 1.5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Row(
              children: [
                Column(
                  spacing: 6,
                  children: [
                    SvgPicture.asset(AppIcons.like, height: 32),
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
                      child: SvgPicture.asset(AppIcons.comment, height: 32),
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
          ),
        ],
      ),
    );
  }
}

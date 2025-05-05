import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/post_model.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/constants/app_images.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:petguardian/resources/widgets/like_button.dart';
import 'package:petguardian/resources/widgets/shimmer_cached_image.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/routes/routes_name.dart';
import '../../../resources/utils.dart';
import 'comment_section.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
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
                  onTap: () => Get.toNamed(RoutesName.otherUserProfile, arguments: {'userData': post.owner}),
                  child: Row(
                    spacing: 10,
                    children: [
                      post.owner!.img!.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 20,
                              child: ShimmerCachedImage(imageUrl: post.owner!.img!),
                            ),
                          )
                          : CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.secondary,
                            child: AppTextWidget(
                              text: Utils.getInitial(post.owner!.name!),
                              fontFamily: headingFont,
                            ),
                          ),
                      AppTextWidget(
                        text: post.owner?.name ?? 'null',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFamily: headingFont,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                if (post.ownerId == uid)
                  GestureDetector(
                    onTap: () {
                      forumC.setEditPost(post: post);
                      Get.toNamed(RoutesName.addPostScreen, arguments: {'isEdit': true});
                    },
                    child: Icon(Icons.edit_outlined),
                  ),
                if (post.ownerId != uid)
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
                                  userC.updateBlocks(userId: post.ownerId, context: context);
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
          ),
          SizedBox(height: 1.5.h),
          ShimmerCachedImage(imageUrl: post.imageUrl, height: 220, width: double.infinity),
          SizedBox(height: 1.5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: ReadMoreText(
              post.postDetail,
              trimLines: 2,
              trimCollapsedText: 'Read More',
              trimExpandedText: ' Read Less',
              style: TextStyle(fontSize: 14),
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
                    LikeButton(
                      isLiked: post.likes.contains(uid),
                      onTap: (bool isLiked, AnimationController controller) {
                        controller.reverse().then((value) => controller.forward());
                        if (isLiked) {
                          forumC.unlikePost(post.id!);
                        } else {
                          forumC.likePost(post.id!);
                        }
                      },
                    ),
                    AppTextWidget(text: post.likes.length.toString(), fontSize: 14),
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
                            return CommentsSection(postId: post.id!);
                          },
                        );
                      },
                      child: SvgPicture.asset(AppIcons.comment, height: 26),
                    ),
                    AppTextWidget(text: post.commentsCount.toString(), fontSize: 14),
                  ],
                ),
                Spacer(),
                Icon(Icons.watch_later_outlined),
                SizedBox(width: 2.w),
                AppTextWidget(text: post.createdAt ?? '', fontSize: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

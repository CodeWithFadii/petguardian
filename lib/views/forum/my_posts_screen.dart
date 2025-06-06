import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../models/post_model.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/routes/routes_name.dart';
import '../../resources/utils.dart';
import '../../resources/widgets/loader.dart';
import 'components/comment_section.dart';
import 'components/post_widget.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SizedBox(height: 5.5.h, width: 11.w, child: SvgPicture.asset(AppIcons.backButton)),
                  ),
                  SizedBox(width: 5.w),
                  AppTextWidget(text: 'My Posts', fontWeight: FontWeight.w500, fontSize: 17.5),
                ],
              ),

              SizedBox(height: 2.h),
              Expanded(
                child: StreamBuilder<List<PostModel>>(
                  stream: forumC.myPostsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Loader());
                    }
                    if (snapshot.hasError) {
                      return Center(child: AppTextWidget(text: 'Error: ${snapshot.error}', height: 1.3));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: AppTextWidget(text: 'No posts yet.', height: 1.3));
                    }
                    final posts = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostWidget(post: post);
                      },
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

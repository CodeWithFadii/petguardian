import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/post_model.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../resources/routes/routes_name.dart';
import '../../resources/utils.dart';
import 'components/comment_section.dart';
import 'components/post_widget.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RoutesName.addPostScreen),
        elevation: 0,
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              AppTextField(
                hintText: 'Search Posts by Tag',
                suffixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              Expanded(
                child: StreamBuilder<List<PostModel>>(
                  stream: forumC.postsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Loader());
                    }
                    if (snapshot.hasError) {
                      return Center(child: AppTextWidget(text: 'Error: ${snapshot.error}', height: 1.3));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: AppTextWidget(
                          text: 'No posts yet. Be the first to share your story! 📸',
                          height: 1.3,
                        ),
                      );
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

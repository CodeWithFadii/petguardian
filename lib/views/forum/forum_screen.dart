import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          forumC.setDefault();
          Get.toNamed(RoutesName.addPostScreen);
        },
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
                controller: _searchController,
                hintText: 'Search Posts by Tag',
                onChanged: (value) {
                  forumC.searchTag.value = value.trim();
                },
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            forumC.searchTag.value = '';
                          },
                        )
                        : IconButton(icon: Icon(Icons.search, color: Colors.grey), onPressed: () {}),
              ),
              Expanded(
                child: Obx(
                  () => StreamBuilder<List<PostModel>>(
                    stream: forumC.postsStream(tag: forumC.searchTag.value),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Loader());
                      }
                      if (snapshot.hasError) {
                        return Center(child: AppTextWidget(text: 'Error: ${snapshot.error}', height: 1.3));
                      }
                      final posts = snapshot.data ?? [];
                      if (posts.isEmpty) {
                        return Center(
                          child: AppTextWidget(
                            text:
                                forumC.searchTag.value.isEmpty
                                    ? 'No posts yet. Be the first to share your story! 📸'
                                    : 'No posts found with tag "${forumC.searchTag.value}"',
                            height: 1.3,
                          ),
                        );
                      }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/comment_model.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/utils.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/widgets/app_text_field_widget.dart';
import '../../../resources/widgets/app_text_widget.dart';
import '../../../resources/widgets/shimmer_cached_image.dart';

class CommentsSection extends StatefulWidget {
  final String postId;
  const CommentsSection({super.key, required this.postId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom initially to show the latest comments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

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
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 1.5.h),
            AppTextWidget(
              text: 'Comments',
              fontWeight: FontWeight.w500,
              fontFamily: headingFont,
              fontSize: 17,
            ),
            SizedBox(height: 1.5.h),
            Divider(),
            SizedBox(height: 1.h),
            StreamBuilder<List<CommentModel>>(
              stream: forumC.commentsStream(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Loader());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading comments'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No comments yet'));
                }
                final comments = snapshot.data ?? [];
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return GestureDetector(
                      onLongPress: () {
                        if (comment.userId == uid) {
                          _showDeleteConfirmationDialog(comment.id!);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            comment.user!.img!.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: ShimmerCachedImage(imageUrl: comment.user!.img!),
                                  ),
                                )
                                : CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.secondary,
                                  child: AppTextWidget(
                                    text: Utils.getInitial(comment.user!.name!),
                                    fontFamily: headingFont,
                                  ),
                                ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppTextWidget(
                                        text: comment.user?.name ?? '',
                                        fontWeight: FontWeight.w600,
                                        fontFamily: headingFont,
                                        fontSize: 14.5,
                                      ),
                                      AppTextWidget(text: comment.createdAt ?? '', fontSize: 14),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  AppTextWidget(
                                    textAlign: TextAlign.left,
                                    height: 1.3,
                                    fontSize: 15,
                                    text: comment.commentText,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _commentController,
                      hintText: 'Add comment ...',
                      fillColor: AppColors.bg,
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        forumC.addComment(widget.postId, _commentController.text);
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String commentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Comment'),
          content: const Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                forumC.deleteComment(widget.postId, commentId);
                Get.back();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

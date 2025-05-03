import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../resources/constants/app_colors.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
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
          mainAxisSize: MainAxisSize.min, // Ensures the column takes only necessary height
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
            SizedBox(height: 2.h),
            // Comment list takes available space and scrolls independently
            Flexible(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: 4, // Adjusted to test with many comments
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.secondary,
                          child: AppTextWidget(text: 'F', fontFamily: headingFont),
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
                                    text: 'Fahad Ali',
                                    fontWeight: FontWeight.w600,
                                    fontFamily: headingFont,
                                    fontSize: 14.5,
                                  ),
                                  AppTextWidget(text: '2 hours ago', fontSize: 14),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              AppTextWidget(
                                textAlign: TextAlign.left,
                                height: 1.3,
                                fontSize: 15,
                                text:
                                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Text field pinned at the bottom
            AppTextField(
              hintText: 'Add comment',
              fillColor: AppColors.bg,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
          ],
        ),
      ),
    );
  }
}

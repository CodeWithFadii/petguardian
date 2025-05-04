import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_validators.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:sizer/sizer.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/widgets/app_text_widget.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return GlobalLoader(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 6.w, right: 5.w, top: 3.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: SizedBox(
                          height: 5.5.h,
                          width: 11.w,
                          child: SvgPicture.asset(AppIcons.backButton),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      AppTextWidget(text: 'Add Post Info', fontWeight: FontWeight.w500, fontSize: 17.5),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 3.h),

                          /// Image Picker Section
                          Container(
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: GestureDetector(
                              onTap: forumC.pickImage,
                              child: SizedBox(
                                width: double.infinity,
                                child: Obx(
                                  () =>
                                      forumC.selectedImage == null
                                          ? SizedBox(
                                            height: 220,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add_a_photo_outlined,
                                                  size: 4.h,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(height: 1.h),
                                                Text(
                                                  "Tap to pick image",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          )
                                          : Container(
                                            height: 220,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: FileImage(forumC.selectedImage!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          AppTextField(
                            controller: forumC.postDetailC,
                            hintText: 'Post Detail',
                            maxLines: null,
                            validator: (value) => AppValidators.validateValue(value, 'Post Detail'),
                          ),
                          SizedBox(height: 2.h),

                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  controller: forumC.tagC,
                                  hintText: 'Enter tag',
                                  onFieldSubmitted: (value) {
                                    final tag = value.trim();
                                    if (tag.isNotEmpty) {
                                      forumC.addTag(tag);
                                      forumC.tagC?.clear();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 2.w),
                              IconButton(
                                onPressed: () {
                                  final tag = forumC.tagC?.text.trim();
                                  if (tag!.isNotEmpty) {
                                    forumC.addTag(tag);
                                    forumC.tagC?.clear();
                                  }
                                },
                                icon: Icon(Icons.add_box_outlined, size: 30),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AppTextWidget(
                              textAlign: TextAlign.left,
                              color: Colors.grey,
                              fontSize: 14.5,
                              text: 'Add tags to help others find your post when they search.',
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Obx(
                            () => SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: forumC.tags.length,
                                itemBuilder: (context, index) {
                                  final tag = forumC.tags[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Chip(
                                      label: Text(tag),
                                      deleteIcon: Icon(Icons.close, size: 18),
                                      onDeleted: () => forumC.removeTag(index),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AppButtonWidget(
          onTap: () {
            if (formKey.currentState!.validate()) {
              forumC.uploadPost(context: context);
            }
          },
          margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          text: 'Upload Post',
        ),
      ),
    );
  }
}

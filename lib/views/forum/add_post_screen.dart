import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:sizer/sizer.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/widgets/app_text_widget.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late TextEditingController tagController;

  @override
  void initState() {
    super.initState();
    tagController = TextEditingController();
  }

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 5.w, top: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SizedBox(height: 5.5.h, width: 11.w, child: SvgPicture.asset(AppIcons.backButton)),
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
                      GestureDetector(
                        onTap: forumC.pickImages,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: Obx(
                            () =>
                                forumC.selectedImages.isEmpty
                                    ? Column(
                                      children: [
                                        Icon(Icons.add_a_photo, size: 4.h, color: Colors.grey),
                                        SizedBox(height: 1.h),
                                        Text(
                                          "Tap to pick images (Max 3)",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                    : SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: forumC.selectedImages.length,
                                        itemBuilder: (context, index) {
                                          final file = forumC.selectedImages[index];
                                          return Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 10),
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: FileImage(file),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 10,
                                                top: 0,
                                                child: GestureDetector(
                                                  onTap: () => forumC.removeImage(index),
                                                  child: Container(
                                                    margin: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    padding: EdgeInsets.all(2),
                                                    child: Icon(Icons.close, color: Colors.white, size: 16),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      AppTextField(hintText: 'Post Detail', maxLines: null),
                      SizedBox(height: 2.h),

                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: tagController,
                              hintText: 'Enter tag',
                              onFieldSubmitted: (value) {
                                final tag = value.trim();
                                if (tag.isNotEmpty) {
                                  forumC.addTag(tag);
                                  tagController.clear();
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 2.w),
                          ElevatedButton(
                            onPressed: () {
                              final tag = tagController.text.trim();
                              if (tag.isNotEmpty) {
                                forumC.addTag(tag);
                                tagController.clear();
                              }
                            },
                            child: Text('Add'),
                          ),
                        ],
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
      bottomNavigationBar: AppButtonWidget(
        onTap: () => Get.back(),
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        text: 'Upload Post',
      ),
    );
  }
}

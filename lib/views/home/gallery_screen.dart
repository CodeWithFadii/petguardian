import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:petguardian/resources/widgets/shimmer_cached_image.dart';
// Update with your correct path
import 'package:sizer/sizer.dart';

import '../../models/gallery_image.dart';
import '../../resources/constants/constants.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoader(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => galleryC.pickImages(),
          child: Icon(Icons.add),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    AppTextWidget(text: 'Gallery', fontWeight: FontWeight.w500, fontSize: 17.5),
                  ],
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: Obx(() {
                    if (galleryC.images.isEmpty) {
                      return Center(
                        child: AppTextWidget(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          text: 'No memories yet — start capturing today!',
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      );
                    }
                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2.h,
                      crossAxisSpacing: 2.w,
                      itemCount: galleryC.images.length,
                      itemBuilder: (context, index) {
                        final image = galleryC.images[index];
                        final isLarge = index % 6 == 0 || index % 6 == 5;

                        return GestureDetector(
                          onTap: () => Get.to(() => ImagePreviewScreen(image: image)),
                          child:
                              image.file != null
                                  ? Container(
                                    height: isLarge ? 35.h : 17.h,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(image: FileImage(image.file!)),
                                    ),
                                  )
                                  : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      height: isLarge ? 35.h : 17.h,
                                      child: ShimmerCachedImage(imageUrl: image.url!, fit: BoxFit.contain),
                                    ),
                                  ),
                        );
                      },
                    );
                  }),
                ),
                // Add Save button conditionally
                Obx(() {
                  if (galleryC.images.any((img) => img.file != null)) {
                    return Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: ElevatedButton(onPressed: () => galleryC.saveImages(), child: Text('Save')),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final GalleryImage image;
  const ImagePreviewScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              galleryC.removeImage(image);
              Get.back();
            },
          ),
        ],
      ),
      body: Center(
        child:
            image.file != null
                ? Image.file(image.file!)
                : ShimmerCachedImage(imageUrl: image.url!, fit: BoxFit.contain),
      ),
    );
  }
}

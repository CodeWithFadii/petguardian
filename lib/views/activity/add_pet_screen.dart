import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:sizer/sizer.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/widgets/app_text_widget.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 5.w, top: 3.h),
          child: SingleChildScrollView(
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
                    AppTextWidget(text: 'Add Pet Info', fontWeight: FontWeight.w500, fontSize: 17.5),
                  ],
                ),
                SizedBox(height: 3.h),

                /// Image Picker Section
                GestureDetector(
                  onTap: addPetInfoC.pickImages,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.add_a_photo, size: 6.h, color: Colors.grey),
                        SizedBox(height: 1.h),
                        Text("Tap to pick images", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                Obx(
                  () =>
                      addPetInfoC.selectedImages.isEmpty
                          ? SizedBox()
                          : SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: addPetInfoC.selectedImages.length,
                              itemBuilder: (context, index) {
                                final file = addPetInfoC.selectedImages[index];
                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
                                  ),
                                );
                              },
                            ),
                          ),
                ),
                SizedBox(height: 3.h),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: addPetInfoC.selectedAnimalType.isEmpty ? null : addPetInfoC.selectedAnimalType,
                    decoration: InputDecoration(
                      fillColor: AppColors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: Text(
                      "Select Animal",
                      style: TextStyle(fontSize: 14, fontFamily: bodyFont, fontWeight: FontWeight.w400),
                    ),
                    items:
                        addPetInfoC.animalTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: TextStyle(fontFamily: bodyFont, fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => addPetInfoC.selectAnimalType(val!),
                  ),
                ),
                SizedBox(height: 2.h),

                /// Pet Info Fields
                AppTextField(hintText: 'Pet Name'),
                SizedBox(height: 2.h),
                AppTextField(hintText: 'Breed'),
                SizedBox(height: 2.h),
                AppTextField(hintText: 'Age'),
                SizedBox(height: 2.h),
                AppTextField(hintText: 'Weight'),
                SizedBox(height: 2.h),
                AppTextField(hintText: 'Notes', maxLines: 3),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppButtonWidget(
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        text: 'Save Info',
      ),
    );
  }
}

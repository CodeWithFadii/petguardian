import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/constants/app_validators.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:petguardian/resources/widgets/shimmer_cached_image.dart';
import 'package:sizer/sizer.dart';
import '../../resources/widgets/app_text_widget.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isEdit = Get.arguments?['isEdit'] ?? false;
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
                      AppTextWidget(
                        text: isEdit ? 'Update Pet Info' : 'Add Pet Info',
                        fontWeight: FontWeight.w500,
                        fontSize: 17.5,
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 3.h),

                          /// Image Picker Section
                          GestureDetector(
                            onTap: addPetInfoC.pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: double.infinity,
                              child: Obx(
                                () =>
                                    addPetInfoC.selectedImage == null
                                        ? addPetInfoC.imageUrl.isEmpty
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
                                            : ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: SizedBox(
                                                height: 220,
                                                child: ShimmerCachedImage(imageUrl: addPetInfoC.imageUrl),
                                              ),
                                            )
                                        : Container(
                                          height: 220,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: FileImage(addPetInfoC.selectedImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                              ),
                            ),
                          ),

                          SizedBox(height: 3.h),
                          Obx(
                            () => DropdownButtonFormField<String>(
                              validator: (value) => AppValidators.validateValue(value, 'Animal Type'),
                              value:
                                  addPetInfoC.selectedAnimalType.isEmpty
                                      ? null
                                      : addPetInfoC.selectedAnimalType,
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                errorStyle: TextStyle(color: Colors.red),
                                fillColor: AppColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: Text(
                                "Select Animal",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontFamily: bodyFont,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              items:
                                  addPetInfoC.animalTypes
                                      .map(
                                        (type) => DropdownMenuItem(
                                          value: type,
                                          child: Text(
                                            type,
                                            style: TextStyle(
                                              fontFamily: bodyFont,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) => addPetInfoC.selectAnimalType(val!),
                            ),
                          ),
                          SizedBox(height: 2.h),

                          /// Pet Info Fields
                          AppTextField(
                            hintText: 'Pet Name',
                            controller: addPetInfoC.name,
                            validator: (value) => AppValidators.validateValue(value, 'Pet Name'),
                          ),
                          SizedBox(height: 2.h),
                          AppTextField(hintText: 'Breed', controller: addPetInfoC.breed),
                          SizedBox(height: 2.h),
                          AppTextField(hintText: 'Age', controller: addPetInfoC.age),
                          SizedBox(height: 2.h),
                          AppTextField(hintText: 'Weight (KG)', controller: addPetInfoC.weight),
                          SizedBox(height: 2.h),
                          AppTextField(hintText: 'Notes', controller: addPetInfoC.notes, maxLines: 3),
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
              isEdit
                  ? addPetInfoC.updatePetInfo(context: context)
                  : addPetInfoC.savePetInfo(context: context);
            }
          },
          margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          text: isEdit ? 'Update Info' : 'Save Info',
        ),
      ),
    );
  }
}

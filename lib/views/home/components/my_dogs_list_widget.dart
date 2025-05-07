import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:petguardian/resources/widgets/custom_check_box.dart';
import 'package:sizer/sizer.dart';
import '../../../models/pet_model.dart';
import '../../../resources/constants/app_colors.dart';
import '../../../resources/constants/app_images.dart';
import '../../my_pets/my_pets_screen.dart';
import '../../../controllers/add_pet_info_controller.dart';

// MyDogsListWidget
class MyDogsListWidget extends StatelessWidget {
  final RxList<String> selectedPetIds = <String>[].obs;
  final addPetInfoC = Get.find<AddPetInfoController>();

  MyDogsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 1.5.h),
            AppTextWidget(
              text: 'Select Pets',
              fontWeight: FontWeight.w500,
              fontFamily: headingFont,
              fontSize: 17,
            ),
            SizedBox(height: 1.5.h),
            Divider(),
            Flexible(
              child: StreamBuilder<List<PetModel>>(
                stream: addPetInfoC.petsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: AppTextWidget(text: 'Error: ${snapshot.error}'),
                    );
                  }
                  final pets = snapshot.data ?? [];
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 2.h,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: pets.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      return Obx(
                        () => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundImage: NetworkImage(
                                  pet.imageUrl,
                                ), // Assuming PetModel has imageUrl
                              ),
                              SizedBox(width: 3.w),
                              AppTextWidget(
                                fontFamily: headingFont,
                                text: pet.name,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              Spacer(),
                              CustomCheckBox(
                                isChecked: selectedPetIds.contains(pet.id),
                                onChanged: (value) {
                                  if (value) {
                                    selectedPetIds.add(pet.id!);
                                  } else {
                                    selectedPetIds.remove(pet.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            AppButtonWidget(
              text: 'Save',
              margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              onTap: () {
                Get.back(result: selectedPetIds.toList());
              },
            ),
          ],
        ),
      ),
    );
  }
}

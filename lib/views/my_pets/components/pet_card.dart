import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:info_popup/info_popup.dart';
import 'package:petguardian/models/pet_model.dart';
import 'package:petguardian/resources/constants/app_images.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:petguardian/resources/widgets/shimmer_cached_image.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/widgets/app_text_widget.dart';

class PetCard extends StatelessWidget {
  const PetCard({super.key, required this.pet});
  final PetModel pet;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (pet.notes.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: InfoPopupWidget(
                    contentTitle: pet.notes,
                    child: Icon(Icons.info_outline, color: Colors.black),
                  ),
                ),
              Spacer(),
              Align(
                alignment: Alignment.topRight,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, size: 20),
                  onSelected: (String result) {
                    if (result == 'Edit') {
                      addPetInfoC.setEditPet(pet);
                      Get.toNamed(RoutesName.addPetScreen, arguments: {'isEdit': true});
                    } else if (result == 'Delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Pet'),
                            content: Text('Are you sure you want to delete this pet?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  addPetInfoC.deletePet(context: context, docId: pet.id!);
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem<String>(value: 'Edit', child: Text('Edit')),
                        PopupMenuItem<String>(value: 'Delete', child: Text('Delete')),
                      ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Get.toNamed(RoutesName.petDetailScreen, arguments: {'pet': pet}),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: ShimmerCachedImage(imageUrl: pet.imageUrl, height: 90, width: 90),
            ),
          ),
          SizedBox(height: 1.h),
          AppTextWidget(text: pet.name, fontFamily: headingFont, fontSize: 15, fontWeight: FontWeight.w600),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}

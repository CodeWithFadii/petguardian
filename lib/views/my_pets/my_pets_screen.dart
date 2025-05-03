import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_images.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/widgets/app_text_widget.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 12.h, right: 2.w),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(RoutesName.addPetScreen),
          elevation: 2,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.add, size: 28),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: 3, // Replace with dynamic list count later
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.h,
                    crossAxisSpacing: 2.w,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    return PetCard(index: index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  const PetCard({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final petName = index == 0 ? 'Jackie' : 'Alee';
    final petImage = index == 0 ? AppImages.dog : AppImages.cat;
    return GestureDetector(
      onTap: () => Get.toNamed(RoutesName.petDetailScreen),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 20),
                onSelected: (String result) {
                  if (result == 'Edit') {
                    Get.toNamed(RoutesName.editPetScreen);
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
                                // Perform delete logic
                                Navigator.of(context).pop();
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
            CircleAvatar(radius: 44, backgroundImage: AssetImage(petImage)),
            SizedBox(height: 1.h),
            AppTextWidget(text: petName, fontFamily: headingFont, fontSize: 15, fontWeight: FontWeight.w600),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}

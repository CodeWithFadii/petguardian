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
          elevation: 0,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return MyPetWidget(index: index);
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

class MyPetWidget extends StatelessWidget {
  const MyPetWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      padding: EdgeInsets.only(left: 3.w, top: 1.4.h, bottom: 1.4.h),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(radius: 26, backgroundImage: AssetImage(index == 0 ? AppImages.dog : AppImages.cat)),
          SizedBox(width: 3.w),
          AppTextWidget(
            fontFamily: headingFont,
            text: index == 0 ? 'Jackie' : 'Alee',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          Spacer(),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.black),
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
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            // Perform delete operation here
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'Edit', child: Text('Edit')),
                  const PopupMenuItem<String>(value: 'Delete', child: Text('Delete')),
                ],
          ),
        ],
      ),
    );
  }
}

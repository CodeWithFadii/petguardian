import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/pet_model.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:sizer/sizer.dart';

import '../../resources/constants/app_colors.dart';
import 'components/pet_card.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoader(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addPetInfoC.setDefault();
            Get.toNamed(RoutesName.addPetScreen);
          },
          elevation: 2,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.add, size: 28),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<PetModel>>(
                    stream: addPetInfoC.petsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Loader();
                      }
                      if (snapshot.hasError) {
                        return Center(child: AppTextWidget(text: 'Error: ${snapshot.error}', height: 1.3));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: AppTextWidget(
                            text: 'No pets found. Time to make some furry memories! 🐾',
                            height: 1.3,
                          ),
                        );
                      }
                      final pets = snapshot.data ?? [];
                      return GridView.builder(
                        itemCount: pets.length, // Replace with dynamic list count later
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 1.h,
                          crossAxisSpacing: 2.w,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (context, index) {
                          final pet = pets[index];
                          return PetCard(pet: pet);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

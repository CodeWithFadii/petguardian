import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:petguardian/resources/widgets/app_text_field_widget.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../../resources/constants/constants.dart'; // Assuming this exists

class FeedingScreen extends StatelessWidget {
  const FeedingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todayDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Reminder Section
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
                    AppTextWidget(text: 'Feeding - $todayDate', fontWeight: FontWeight.w500, fontSize: 17.5),
                  ],
                ),
                SizedBox(height: 4.h),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(text: 'Set Reminder', fontSize: 16.5, fontWeight: FontWeight.w600),
                      SizedBox(height: 1.h),
                      SwitchListTile(
                        value: feedingC.reminderEnabled.value,
                        onChanged: (val) => feedingC.reminderEnabled.value = val,
                        title: Text(feedingC.reminderEnabled.value ? 'Disable Reminder' : 'Enable Reminder'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                /// Feeding Schedule
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(text: 'Feeding Schedule', fontSize: 16.5, fontWeight: FontWeight.w600),
                      SizedBox(height: 2.h),
                      ...feedingC.feedingTimes.asMap().entries.map((entry) {
                        int index = entry.key;
                        TimeOfDay time = entry.value;
                        bool isDone = feedingC.todayStatus[index];
                        return Row(
                          children: [
                            AppTextWidget(text: time.format(context)),
                            IconButton(
                              icon: Icon(Icons.edit, size: 16),
                              onPressed: () async {
                                final newTime = await showTimePicker(context: context, initialTime: time);
                                if (newTime != null) {
                                  feedingC.feedingTimes[index] = newTime;
                                }
                              },
                            ),
                            Spacer(),
                            Checkbox(value: isDone, onChanged: (val) => feedingC.todayStatus[index] = val!),
                            IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () => feedingC.removeFeedingTime(index),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () async {
                          final newTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (newTime != null) {
                            feedingC.addFeedingTime(newTime);
                          }
                        },
                        child: Row(
                          children: [
                            AppTextWidget(text: 'Add Schedule', fontWeight: FontWeight.w600),
                            SizedBox(width: 2.w),
                            Icon(Icons.add_box_outlined),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                /// Food Info
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(text: 'Food Info', fontSize: 16.5, fontWeight: FontWeight.w600),
                      SizedBox(height: 2.h),
                      DropdownButtonFormField<String>(
                        value: feedingC.selectedFoodType.isEmpty ? null : feedingC.selectedFoodType.value,
                        decoration: InputDecoration(
                          fillColor: AppColors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        hint: Text(
                          "Select Food Type",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: bodyFont,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        items:
                            feedingC.foodTypes
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
                        onChanged: (val) => feedingC.selectedFoodType.value = val!,
                      ),
                      SizedBox(height: 2.h),
                      AppTextField(
                        hintText: 'Quantity (grams)',
                        keyboardType: TextInputType.number,
                        onChanged: (val) => feedingC.quantity.value = val,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                /// Notes Section
                AppTextWidget(text: 'Notes', fontSize: 16.5, fontWeight: FontWeight.w600),
                SizedBox(height: 2.h),
                AppTextField(
                  hintText: 'E.g., Didn’t eat much today...',
                  maxLines: 3,
                  onChanged: (val) => feedingC.notes.value = val,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

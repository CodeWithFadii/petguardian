import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:intl/intl.dart';

import '../../controllers/health_controller.dart';
import '../../resources/constants/constants.dart'; // Assuming this exists

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
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
                    AppTextWidget(text: 'Health', fontWeight: FontWeight.w500, fontSize: 17.5),
                  ],
                ),
                SizedBox(height: 4.h),

                /// Reminder Section
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(text: 'Set Reminder', fontSize: 16.5, fontWeight: FontWeight.w600),
                      SwitchListTile(
                        value: healthC.reminderEnabled.value,
                        onChanged: (val) => healthC.reminderEnabled.value = val,
                        title: Text(healthC.reminderEnabled.value ? 'Disable Reminder' : 'Enable Reminder'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                /// Health Schedule
                AppTextWidget(text: 'Health Schedule', fontSize: 16.5, fontWeight: FontWeight.w600),
                SizedBox(height: 2.h),
                Obx(
                  () => Column(
                    children:
                        healthC.activities.asMap().entries.map((entry) {
                          int index = entry.key;
                          HealthActivity activity = entry.value;
                          final info = getDueDateInfo(activity);
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [AppTextWidget(text: activity.name.value)],
                                ),
                              ),

                              IconButton(
                                icon: Icon(Icons.edit, size: 16),
                                onPressed: () => showAddEditDialog(context, activity),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => healthC.removeActivity(index),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () => showAddEditDialog(context),
                  child: Row(
                    children: [
                      AppTextWidget(text: 'Add Activity', fontWeight: FontWeight.w600),
                      SizedBox(width: 2.w),
                      Icon(Icons.add_box_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> getDueDateInfo(HealthActivity activity) {
    final lastDone = activity.lastDone?.value;
    if (lastDone == null) {
      return {'text': 'Not done yet', 'isOverdue': false};
    }
    final dueDate = lastDone.add(Duration(days: activity.frequencyDays.value));
    final now = DateTime.now();
    if (dueDate.isBefore(now)) {
      return {'text': 'Overdue: ${DateFormat('MMM d').format(dueDate)}', 'isOverdue': true};
    } else {
      return {'text': 'Next: ${DateFormat('MMM d').format(dueDate)}', 'isOverdue': false};
    }
  }

  void showAddEditDialog(BuildContext context, [HealthActivity? activity]) {
    final isEditing = activity != null;
    final nameController = TextEditingController(text: isEditing ? activity!.name.value : '');
    final frequencyController = TextEditingController(
      text: isEditing ? activity!.frequencyDays.value.toString() : '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isEditing ? 'Edit Activity' : 'Add Activity'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Activity Name'),
                ),
                TextField(
                  controller: frequencyController,
                  decoration: InputDecoration(labelText: 'Frequency (days)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
              TextButton(
                onPressed: () {
                  final name = nameController.text;
                  final frequency = int.tryParse(frequencyController.text);
                  if (name.isNotEmpty && frequency != null && frequency > 0) {
                    if (isEditing) {
                      activity!.name.value = name;
                      activity!.frequencyDays.value = frequency;
                    } else {
                      healthC.addActivity(name, frequency);
                    }
                    Navigator.pop(context);
                  } else {
                    Get.snackbar('Error', 'Please enter valid name and frequency');
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
    );
  }
}

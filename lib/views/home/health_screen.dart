import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:petguardian/views/home/components/my_dogs_list_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:intl/intl.dart';

import '../../controllers/health_controller.dart';
import '../../resources/constants/constants.dart';

class HealthScreen extends StatelessWidget {
  final HealthController healthC = Get.find<HealthController>();

  HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todayDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Reminder Section
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SizedBox(height: 5.5.h, width: 11.w, child: SvgPicture.asset(AppIcons.backButton)),
                  ),
                  SizedBox(width: 5.w),
                  AppTextWidget(text: 'Health - $todayDate', fontWeight: FontWeight.w500, fontSize: 17.5),
                ],
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget(
                      text: 'Set Reminder',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: headingFont,
                    ),
                    SizedBox(height: 3.h),
                    SwitchListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      tileColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      value: healthC.reminderEnabled.value,
                      onChanged: (val) => healthC.toggleReminder(val),
                      title: Text(healthC.reminderEnabled.value ? 'Disable Reminder' : 'Enable Reminder'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              /// Health Schedule
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget(
                      text: 'Health Schedule',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: headingFont,
                    ),
                    SizedBox(height: 3.h),
                    if (healthC.isLoading.value)
                      Center(child: Padding(padding: EdgeInsets.only(top: 5.h, bottom: 2.h), child: Loader()))
                    else if (healthC.healthSchedules.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.h, bottom: 2.h),
                          child: AppTextWidget(
                            height: 1.3,
                            text: 'No health schedules yet.\nAdd one to get started!',
                            fontSize: 16,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ...healthC.healthSchedules.asMap().entries.map((entry) {
                        int index = entry.key;
                        var schedule = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            tileColor: Colors.white,
                            contentPadding: EdgeInsets.only(left: 4.w),
                            leading: AppTextWidget(text: schedule.time.format(context)),
                            trailing: PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: AppColors.black),
                              onSelected: (String result) async {
                                switch (result) {
                                  case 'Mark Complete':
                                    _showPetSelector(context, index);
                                    break;
                                  case 'Edit':
                                    _showEditTimeDialog(context, index);
                                    break;
                                  case 'Delete':
                                    final shouldDelete = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text('Delete Schedule'),
                                            content: Text(
                                              'Are you sure you want to delete this health schedule?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (shouldDelete == true) {
                                      healthC.removeHealthTime(index);
                                    }
                                    break;
                                }
                              },
                              itemBuilder:
                                  (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'Mark Complete',
                                      child: Text('Mark Complete'),
                                    ),
                                    const PopupMenuItem<String>(value: 'Edit', child: Text('Edit')),
                                    const PopupMenuItem<String>(value: 'Delete', child: Text('Delete')),
                                  ],
                            ),
                          ),
                        );
                      }),
                    SizedBox(height: 2.h),
                    GestureDetector(
                      onTap: () async {
                        final newTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (newTime != null) {
                          healthC.addHealthTime(newTime);
                        }
                      },
                      child: Row(
                        children: [
                          AppTextWidget(
                            text: 'Add Schedule',
                            fontWeight: FontWeight.w600,
                            fontFamily: headingFont,
                            fontSize: 15,
                          ),
                          SizedBox(width: 2.w),
                          Icon(Icons.add_box_outlined),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPetSelector(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MyDogsListWidget(),
    ).then((selectedPetIds) {
      if (selectedPetIds != null && selectedPetIds.isNotEmpty) {
        healthC.markHealthComplete(index, selectedPetIds);
      }
    });
  }

  void _showEditTimeDialog(BuildContext context, int index) {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
      if (time != null) {
        healthC.updateHealthTime(index, time);
      }
    });
  }
}

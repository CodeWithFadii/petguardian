import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:petguardian/views/home/components/my_dogs_list_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../resources/constants/constants.dart';
import '../../resources/routes/routes_name.dart'; // Assuming this exists

class FeedingScreen extends StatelessWidget {
  const FeedingScreen({super.key});

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
                  AppTextWidget(text: 'Feeding - $todayDate', fontWeight: FontWeight.w500, fontSize: 17.5),
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
                      value: feedingC.reminderEnabled.value,
                      onChanged: (val) => feedingC.toggleReminder(val),
                      title: Text(feedingC.reminderEnabled.value ? 'Disable Reminder' : 'Enable Reminder'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              /// Feeding Schedule
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget(
                      text: 'Feeding Schedule',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: headingFont,
                    ),
                    SizedBox(height: 3.h),
                    if (feedingC.isLoading.value)
                      Center(child: Padding(padding: EdgeInsets.only(top: 5.h, bottom: 2.h), child: Loader()))
                    else if (feedingC.feedingSchedules.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.h, bottom: 2.h),
                          child: AppTextWidget(
                            height: 1.3,
                            text: 'No feeding schedules yet.\nAdd one to get started!',
                            fontSize: 16,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ...feedingC.feedingSchedules.asMap().entries.map((entry) {
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
                                    final selectedPetIds = await showModalBottomSheet<List<String>>(
                                      context: context,
                                      useSafeArea: true,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return MyDogsListWidget();
                                      },
                                    );
                                    if (selectedPetIds != null && selectedPetIds.isNotEmpty) {
                                      await feedingC.markFeedingComplete(index, selectedPetIds);
                                    }
                                  case 'Edit':
                                    final newTime = await showTimePicker(
                                      context: context,
                                      initialTime: schedule.time,
                                    );
                                    if (newTime != null) {
                                      feedingC.updateFeedingTime(index, newTime);
                                    }
                                  case 'Delete':
                                    final shouldDelete = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text('Delete Schedule'),
                                            content: Text(
                                              'Are you sure you want to delete this feeding schedule?',
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
                                      feedingC.removeFeedingTime(index);
                                    }
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
                          feedingC.addFeedingTime(newTime);
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
}

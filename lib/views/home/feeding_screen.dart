import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
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
                      onChanged: (val) => feedingC.reminderEnabled.value = val,
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
                    ...feedingC.feedingTimes.asMap().entries.map((entry) {
                      int index = entry.key;
                      TimeOfDay time = entry.value;
                      bool isDone = feedingC.todayStatus[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          tileColor: Colors.white,
                          contentPadding: EdgeInsets.only(left: 4.w),
                          leading: AppTextWidget(
                            text: time.format(context),
                            textDecoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert, color: AppColors.black),
                            onSelected: (String result) async {
                              switch (result) {
                                case 'Mark Complete':
                                  showModalBottomSheet(
                                    context: context,
                                    useSafeArea: true,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return MyDogsListWidget();
                                    },
                                  );
                                case 'Mark UnComplete':
                                  feedingC.todayStatus[index] = false;
                                case 'Edit':
                                  final newTime = await showTimePicker(context: context, initialTime: time);
                                  if (newTime != null) {
                                    feedingC.feedingTimes[index] = newTime;
                                  }
                                case 'Delete':
                                  feedingC.removeFeedingTime(index);
                              }
                            },
                            itemBuilder:
                                (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: feedingC.todayStatus[index] ? 'Mark UnComplete' : 'Mark Complete',
                                    child: Text(
                                      feedingC.todayStatus[index] ? 'Mark UnComplete' : 'Mark Complete',
                                    ),
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
              Spacer(),
              AppButtonWidget(text: 'Save'),
            ],
          ),
        ),
      ),
    );
  }
}

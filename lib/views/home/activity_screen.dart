import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../controllers/activity_controller.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/constants/constants.dart';
import '../../resources/widgets/app_text_widget.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

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
                    AppTextWidget(text: 'Activity - $todayDate', fontWeight: FontWeight.w500, fontSize: 17.5),
                  ],
                ),
                SizedBox(height: 4.h),

                /// Reminder Section
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
                        value: activityC.reminderEnabled.value,
                        onChanged: (val) => activityC.reminderEnabled.value = val,
                        title: Text(activityC.reminderEnabled.value ? 'Disable Reminder' : 'Enable Reminder'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                /// Activities List
                AppTextWidget(
                  text: 'Activity Schedule',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: headingFont,
                ),
                SizedBox(height: 3.h),
                Obx(
                  () => Column(
                    children:
                        activityC.activities.asMap().entries.map((entry) {
                          int index = entry.key;
                          Activity activity = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              color: Colors.white,
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.only(left: 4.w),
                                childrenPadding: EdgeInsets.only(left: 8.w),
                                title: Row(
                                  children: [
                                    AppTextWidget(text: activity.name, fontSize: 16),
                                    Spacer(),
                                    PopupMenuButton<String>(
                                      onSelected: (String result) {
                                        switch (result) {
                                          case 'Edit':
                                            showAddEditDialog(context, activity, index);
                                            break;
                                          case 'Delete':
                                            activityC.removeActivity(index);
                                            break;
                                        }
                                      },
                                      itemBuilder:
                                          (BuildContext context) => <PopupMenuEntry<String>>[
                                            const PopupMenuItem<String>(value: 'Edit', child: Text('Edit')),
                                            const PopupMenuItem<String>(
                                              value: 'Delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                    ),
                                  ],
                                ),
                                children:
                                    activity.times.asMap().entries.map((timeEntry) {
                                      int timeIndex = timeEntry.key;
                                      TimeOfDay time = timeEntry.value;
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 1.h),
                                        child: Row(
                                          children: [
                                            AppTextWidget(text: time.format(context)),
                                            Spacer(),
                                            Obx(
                                              () => Checkbox(
                                                value: activity.todayStatus[timeIndex],
                                                onChanged: (val) => activity.todayStatus[timeIndex] = val!,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () => showAddEditDialog(context),
                  child: Row(
                    children: [
                      AppTextWidget(
                        text: 'Add Activity',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: headingFont,
                      ),
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

  Future<void> showAddEditDialog(BuildContext context, [Activity? activity, int? index]) async {
    final isEditing = activity != null;
    final nameController = TextEditingController(text: isEditing ? activity!.name : '');
    final times = isEditing ? activity!.times.toList() : <TimeOfDay>[];

    await showDialog(
      context: context,
      builder:
          (context) => AddEditActivityDialog(
            nameController: nameController,
            times: times,
            onSave: (name, times) {
              if (isEditing) {
                Get.find<ActivityController>().editActivity(index!, name, times);
              } else {
                Get.find<ActivityController>().addActivity(name, times);
              }
            },
          ),
    );
  }
}

class AddEditActivityDialog extends StatefulWidget {
  final TextEditingController nameController;
  final List<TimeOfDay> times;
  final Function(String, List<TimeOfDay>) onSave;

  const AddEditActivityDialog({
    super.key,
    required this.nameController,
    required this.times,
    required this.onSave,
  });

  @override
  _AddEditActivityDialogState createState() => _AddEditActivityDialogState();
}

class _AddEditActivityDialogState extends State<AddEditActivityDialog> {
  late List<TimeOfDay> _times;

  @override
  void initState() {
    super.initState();
    _times = widget.times;
  }

  void _addTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        _times.add(time);
      });
    }
  }

  void _removeTime(int index) {
    setState(() {
      _times.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.nameController.text.isEmpty ? 'Add Activity' : 'Edit Activity'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.nameController,
              decoration: InputDecoration(labelText: 'Activity Name'),
            ),
            SizedBox(height: 2.h),
            ..._times.asMap().entries.map((entry) {
              int index = entry.key;
              TimeOfDay time = entry.value;
              return Row(
                children: [
                  Text(time.format(context)),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeTime(index),
                  ),
                ],
              );
            }).toList(),
            TextButton(onPressed: _addTime, child: Text('Add Time')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(
          onPressed: () {
            final name = widget.nameController.text;
            if (name.isNotEmpty && _times.isNotEmpty) {
              widget.onSave(name, _times);
              Navigator.pop(context);
            } else {
              Get.snackbar('Error', 'Please enter a name and at least one time');
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

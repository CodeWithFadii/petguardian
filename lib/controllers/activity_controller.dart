import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  final RxList<Activity> activities = <Activity>[].obs;
  final RxBool reminderEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Default activities for demonstration
    activities.add(Activity('Walk', [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 18, minute: 0)]));
    activities.add(Activity('Playtime', [TimeOfDay(hour: 10, minute: 0)]));
  }

  void addActivity(String name, List<TimeOfDay> times) {
    activities.add(Activity(name, times));
  }

  void removeActivity(int index) {
    activities.removeAt(index);
  }

  void editActivity(int index, String newName, List<TimeOfDay> newTimes) {
    activities[index] = Activity(newName, newTimes);
  }
}

class Activity {
  final String name;
  final List<TimeOfDay> times;
  final RxList<bool> todayStatus;

  Activity(this.name, List<TimeOfDay> times)
    : times = times..sort(),
      todayStatus = RxList<bool>.filled(times.length, false);
}

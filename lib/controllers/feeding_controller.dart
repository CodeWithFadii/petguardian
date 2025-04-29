import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedingController extends GetxController {
  final RxList<TimeOfDay> feedingTimes = <TimeOfDay>[].obs;
  final RxList<bool> todayStatus = <bool>[].obs;
  final RxBool reminderEnabled = false.obs;
  final RxString selectedFoodType = ''.obs;
  final RxString quantity = ''.obs;
  final RxString notes = ''.obs;
  final List<String> foodTypes = ['Dry Food', 'Wet Food', 'Homemade'];

  @override
  void onInit() {
    super.onInit();
    // Initialize with default feeding times
    addFeedingTime(TimeOfDay(hour: 8, minute: 0));
    addFeedingTime(TimeOfDay(hour: 13, minute: 0));
    addFeedingTime(TimeOfDay(hour: 19, minute: 0));
  }

  void addFeedingTime(TimeOfDay time) {
    feedingTimes.add(time);
    todayStatus.add(false);
  }

  void removeFeedingTime(int index) {
    if (feedingTimes.length > 1) {
      // Prevent removing all
      feedingTimes.removeAt(index);
      todayStatus.removeAt(index);
    }
  }
}

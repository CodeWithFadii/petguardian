import 'package:get/get.dart';

class GroomingController extends GetxController {
  final RxList<GroomingActivity> activities = <GroomingActivity>[].obs;
  final RxBool reminderEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    activities.add(GroomingActivity('Bathing', 14));
    activities.add(GroomingActivity('Brushing', 7));
    activities.add(GroomingActivity('Nail Trimming', 30));
  }

  void addActivity(String name, int frequency) {
    activities.add(GroomingActivity(name, frequency));
  }

  void markAsDone(int index) {
    activities[index].lastDone?.value = DateTime.now();
  }

  void removeActivity(int index) {
    activities.removeAt(index);
  }
}

class GroomingActivity {
  final RxString name;
  final RxInt frequencyDays;
  final Rx<DateTime>? lastDone;

  GroomingActivity(String name, int frequencyDays, {DateTime? lastDone})
    : name = name.obs,
      frequencyDays = frequencyDays.obs,
      lastDone = lastDone?.obs;
}

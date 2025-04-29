import 'package:get/get.dart';

class HealthController extends GetxController {
  final RxList<HealthActivity> activities = <HealthActivity>[].obs;
  final RxBool reminderEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    activities.add(HealthActivity('Vet Visit', 180)); // Every 6 months
    activities.add(HealthActivity('Vaccination', 365)); // Yearly
    activities.add(HealthActivity('Medication', 7)); // Weekly
  }

  void addActivity(String name, int frequency) {
    activities.add(HealthActivity(name, frequency));
  }

  void markAsDone(int index) {
    activities[index].lastDone?.value = DateTime.now();
  }

  void removeActivity(int index) {
    activities.removeAt(index);
  }
}

class HealthActivity {
  final RxString name;
  final RxInt frequencyDays;
  final Rx<DateTime>? lastDone;

  HealthActivity(String name, int frequencyDays, {DateTime? lastDone})
    : name = name.obs,
      frequencyDays = frequencyDays.obs,
      lastDone = lastDone?.obs;
}

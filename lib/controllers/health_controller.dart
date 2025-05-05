import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/health_schedule_model.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/services/notification_service.dart';

class HealthController extends GetxController {
  final RxList<HealthScheduleModel> healthSchedules =
      <HealthScheduleModel>[].obs;
  final RxBool reminderEnabled = false.obs;
  final RxBool isLoading = false.obs;
  final notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    fetchHealthSchedules();
    fetchReminderStatus();
  }

  Future<void> fetchReminderStatus() async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      reminderEnabled.value = doc.data()?['healthReminderEnabled'] ?? false;
    } catch (e) {
      print('Error fetching reminder status: $e');
    }
  }

  Future<void> fetchHealthSchedules() async {
    try {
      isLoading.value = true;
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('health_schedules')
              .orderBy('createdAt', descending: true)
              .get();

      healthSchedules.value =
          snapshot.docs
              .map((doc) => HealthScheduleModel.fromFirestore(doc))
              .toList();
    } catch (e) {
      print('Error fetching health schedules: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHealthTime(TimeOfDay time) async {
    try {
      isLoading.value = true;
      final schedule = HealthScheduleModel(time: time);
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('health_schedules')
          .add(schedule.toFirestore());

      if (reminderEnabled.value) {
        final now = DateTime.now();
        var scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        // If the time has already passed today, schedule for tomorrow
        if (scheduledTime.isBefore(now)) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }

        await notificationService.scheduleNotification(
          id: docRef.id.hashCode,
          title: 'Health Check Reminder',
          body: 'Time for your pets\' health check!',
          scheduledTime: scheduledTime,
        );
      }

      healthSchedules.add(schedule);
    } catch (e) {
      print('Error adding health time: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeHealthTime(int index) async {
    if (healthSchedules.length > 1) {
      try {
        isLoading.value = true;
        final schedule = healthSchedules[index];
        if (schedule.id != null) {
          // Cancel the notification if it exists
          await notificationService.cancelNotification(schedule.id.hashCode);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('health_schedules')
              .doc(schedule.id)
              .delete();
        }
        healthSchedules.removeAt(index);
      } catch (e) {
        print('Error removing health time: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateHealthTime(int index, TimeOfDay newTime) async {
    try {
      isLoading.value = true;
      final schedule = healthSchedules[index];
      if (schedule.id != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('health_schedules')
            .doc(schedule.id)
            .update({'hour': newTime.hour, 'minute': newTime.minute});

        if (reminderEnabled.value) {
          // Cancel existing notification
          await notificationService.cancelNotification(schedule.id.hashCode);

          // Schedule new notification with updated time
          final now = DateTime.now();
          var scheduledTime = DateTime(
            now.year,
            now.month,
            now.day,
            newTime.hour,
            newTime.minute,
          );

          // If the time has already passed today, schedule for tomorrow
          if (scheduledTime.isBefore(now)) {
            scheduledTime = scheduledTime.add(const Duration(days: 1));
          }

          await notificationService.scheduleNotification(
            id: schedule.id.hashCode,
            title: 'Health Check Reminder',
            body: 'Time for your pets\' health check!',
            scheduledTime: scheduledTime,
          );
        }
      }

      healthSchedules[index] = HealthScheduleModel(
        id: schedule.id,
        time: newTime,
        isEnabled: schedule.isEnabled,
        completedPetIds: schedule.completedPetIds,
        isCompleted: schedule.isCompleted,
      );
    } catch (e) {
      print('Error updating health time: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markHealthComplete(int index, List<String> petIds) async {
    try {
      isLoading.value = true;
      final schedule = healthSchedules[index];
      if (schedule.id != null) {
        // First update the health schedule with completed pets
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('health_schedules')
            .doc(schedule.id)
            .update({'completedPetIds': petIds, 'isCompleted': true});

        // Then record completion in each pet's health history
        final batch = FirebaseFirestore.instance.batch();
        for (final petId in petIds) {
          // Check if a health record already exists for this pet and schedule
          final existingRecords =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('pets')
                  .doc(petId)
                  .collection('health_history')
                  .where('scheduleId', isEqualTo: schedule.id)
                  .get();

          if (existingRecords.docs.isEmpty) {
            // Only create a new record if one doesn't exist
            final healthHistoryRef =
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('pets')
                    .doc(petId)
                    .collection('health_history')
                    .doc();

            batch.set(healthHistoryRef, {
              'scheduleId': schedule.id,
              'time': '${schedule.time.hour}:${schedule.time.minute}',
              'completedAt': FieldValue.serverTimestamp(),
            });
          }
        }

        // Commit all the history records
        await batch.commit();

        // Update local state
        healthSchedules[index] = schedule.copyWith(
          completedPetIds: petIds,
          isCompleted: true,
        );

        // Refresh the schedules to ensure UI is up to date
        await fetchHealthSchedules();
      }
    } catch (e) {
      print('Error marking health complete: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markHealthIncomplete(int index) async {
    try {
      final schedule = healthSchedules[index];
      if (schedule.id != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('health_schedules')
            .doc(schedule.id)
            .update({'completedPetIds': [], 'isCompleted': false});

        healthSchedules[index] = schedule.copyWith(
          completedPetIds: [],
          isCompleted: false,
        );
      }
    } catch (e) {
      print('Error marking health incomplete: $e');
    }
  }

  Future<void> toggleReminder(bool value) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'healthReminderEnabled': value,
      });
      reminderEnabled.value = value;

      if (value) {
        // Schedule notifications for all health check times
        for (var schedule in healthSchedules) {
          if (schedule.id != null) {
            final now = DateTime.now();
            var scheduledTime = DateTime(
              now.year,
              now.month,
              now.day,
              schedule.time.hour,
              schedule.time.minute,
            );

            // If the time has already passed today, schedule for tomorrow
            if (scheduledTime.isBefore(now)) {
              scheduledTime = scheduledTime.add(const Duration(days: 1));
            }

            await notificationService.scheduleNotification(
              id: schedule.id.hashCode,
              title: 'Health Check Reminder',
              body: 'Time for your pets\' health check!',
              scheduledTime: scheduledTime,
            );
          }
        }
      } else {
        // Cancel only the health check notifications for this user's schedules
        for (var schedule in healthSchedules) {
          if (schedule.id != null) {
            await notificationService.cancelNotification(schedule.id.hashCode);
          }
        }
      }
    } catch (e) {
      print('Error toggling reminder: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

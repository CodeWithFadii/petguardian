import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/grooming_schedule_model.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/services/notification_service.dart';

class GroomingController extends GetxController {
  final RxList<GroomingScheduleModel> groomingSchedules =
      <GroomingScheduleModel>[].obs;
  final RxBool reminderEnabled = false.obs;
  final RxBool isLoading = false.obs;
  final notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    fetchGroomingSchedules();
    fetchReminderStatus();
  }

  Future<void> fetchReminderStatus() async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      reminderEnabled.value = doc.data()?['groomingReminderEnabled'] ?? false;
    } catch (e) {
      print('Error fetching reminder status: $e');
    }
  }

  Future<void> fetchGroomingSchedules() async {
    try {
      isLoading.value = true;
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('grooming_schedules')
              .orderBy('createdAt', descending: true)
              .get();

      groomingSchedules.value =
          snapshot.docs
              .map((doc) => GroomingScheduleModel.fromFirestore(doc))
              .toList();
    } catch (e) {
      print('Error fetching grooming schedules: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addGroomingTime(TimeOfDay time) async {
    try {
      isLoading.value = true;
      final schedule = GroomingScheduleModel(time: time);
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('grooming_schedules')
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
          title: 'Grooming Time Reminder',
          body: 'Time to groom your pets!',
          scheduledTime: scheduledTime,
        );
      }

      groomingSchedules.add(schedule);
    } catch (e) {
      print('Error adding grooming time: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeGroomingTime(int index) async {
    if (groomingSchedules.length > 1) {
      try {
        isLoading.value = true;
        final schedule = groomingSchedules[index];
        if (schedule.id != null) {
          // Cancel the notification if it exists
          await notificationService.cancelNotification(schedule.id.hashCode);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('grooming_schedules')
              .doc(schedule.id)
              .delete();
        }
        groomingSchedules.removeAt(index);
      } catch (e) {
        print('Error removing grooming time: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateGroomingTime(int index, TimeOfDay newTime) async {
    try {
      isLoading.value = true;
      final schedule = groomingSchedules[index];
      if (schedule.id != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('grooming_schedules')
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
            title: 'Grooming Time Reminder',
            body: 'Time to groom your pets!',
            scheduledTime: scheduledTime,
          );
        }
      }

      groomingSchedules[index] = GroomingScheduleModel(
        id: schedule.id,
        time: newTime,
        isEnabled: schedule.isEnabled,
        completedPetIds: schedule.completedPetIds,
        isCompleted: schedule.isCompleted,
      );
    } catch (e) {
      print('Error updating grooming time: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markGroomingComplete(int index, List<String> petIds) async {
    try {
      isLoading.value = true;
      final schedule = groomingSchedules[index];
      if (schedule.id != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('grooming_schedules')
            .doc(schedule.id)
            .update({'completedPetIds': petIds, 'isCompleted': true});

        final batch = FirebaseFirestore.instance.batch();
        for (final petId in petIds) {
          final existingRecords =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('pets')
                  .doc(petId)
                  .collection('grooming_history')
                  .where('scheduleId', isEqualTo: schedule.id)
                  .get();

          if (existingRecords.docs.isEmpty) {
            final groomingHistoryRef =
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('pets')
                    .doc(petId)
                    .collection('grooming_history')
                    .doc();

            batch.set(groomingHistoryRef, {
              'scheduleId': schedule.id,
              'time': '${schedule.time.hour}:${schedule.time.minute}',
              'completedAt': FieldValue.serverTimestamp(),
            });
          }
        }
        await batch.commit();

        groomingSchedules[index] = schedule.copyWith(
          completedPetIds: petIds,
          isCompleted: true,
        );

        await fetchGroomingSchedules();
      }
    } catch (e) {
      print('Error marking grooming complete: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markGroomingIncomplete(int index) async {
    try {
      final schedule = groomingSchedules[index];
      if (schedule.id != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('grooming_schedules')
            .doc(schedule.id)
            .update({'completedPetIds': [], 'isCompleted': false});

        groomingSchedules[index] = schedule.copyWith(
          completedPetIds: [],
          isCompleted: false,
        );
      }
    } catch (e) {
      print('Error marking grooming incomplete: $e');
    }
  }

  Future<void> toggleReminder(bool value) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'groomingReminderEnabled': value,
      });
      reminderEnabled.value = value;

      if (value) {
        // Schedule notifications for all grooming times
        for (var schedule in groomingSchedules) {
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
              title: 'Grooming Time Reminder',
              body: 'Time to groom your pets!',
              scheduledTime: scheduledTime,
            );
          }
        }
      } else {
        // Cancel only the grooming notifications for this user's schedules
        for (var schedule in groomingSchedules) {
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

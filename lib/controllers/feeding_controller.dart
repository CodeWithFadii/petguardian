import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/feeding_schedule_model.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/services/notification_service.dart';

class FeedingController extends GetxController {
  final RxList<FeedingScheduleModel> feedingSchedules =
      <FeedingScheduleModel>[].obs;
  final RxBool reminderEnabled = false.obs;
  final RxBool isLoading = false.obs;
  final notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    fetchFeedingSchedules();
    fetchReminderStatus();
  }

  Future<void> fetchReminderStatus() async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      reminderEnabled.value = doc.data()?['feedingReminderEnabled'] ?? false;
    } catch (e) {
      print('Error fetching reminder status: $e');
    }
  }

  Future<void> fetchFeedingSchedules() async {
    try {
      isLoading.value = true;
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('feeding_schedules')
              .orderBy('createdAt', descending: true)
              .get();

      feedingSchedules.value =
          snapshot.docs
              .map((doc) => FeedingScheduleModel.fromFirestore(doc))
              .toList();
    } catch (e) {
      print('Error fetching feeding schedules: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFeedingTime(TimeOfDay time) async {
    try {
      isLoading.value = true;
      final schedule = FeedingScheduleModel(time: time);
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('feeding_schedules')
          .add(schedule.toFirestore());

      // Schedule notification if reminders are enabled
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
          title: 'Feeding Time Reminder',
          body: 'Time to feed your pets!',
          scheduledTime: scheduledTime,
        );
      }

      feedingSchedules.add(schedule);
    } catch (e) {
      print('Error adding feeding time: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFeedingTime(int index) async {
    if (feedingSchedules.length > 1) {
      try {
        isLoading.value = true;
        final schedule = feedingSchedules[index];
        if (schedule.id != null) {
          // Cancel the notification if it exists
          await notificationService.cancelNotification(schedule.id.hashCode);

          // Delete from Firebase
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('feeding_schedules')
              .doc(schedule.id)
              .delete();
        }
        feedingSchedules.removeAt(index);
      } catch (e) {
        print('Error removing feeding time: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateFeedingTime(int index, TimeOfDay newTime) async {
    try {
      isLoading.value = true;
      final schedule = feedingSchedules[index];
      if (schedule.id != null) {
        // Update in Firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('feeding_schedules')
            .doc(schedule.id)
            .update({'hour': newTime.hour, 'minute': newTime.minute});

        // Update notification if reminders are enabled
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
            title: 'Feeding Time Reminder',
            body: 'Time to feed your pets!',
            scheduledTime: scheduledTime,
          );
        }
      }

      // Update local state
      feedingSchedules[index] = FeedingScheduleModel(
        id: schedule.id,
        time: newTime,
        isEnabled: schedule.isEnabled,
        completedPetIds: schedule.completedPetIds,
        isCompleted: schedule.isCompleted,
      );
    } catch (e) {
      print('Error updating feeding time: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markFeedingComplete(int index, List<String> petIds) async {
    try {
      isLoading.value = true;
      final schedule = feedingSchedules[index];
      if (schedule.id != null) {
        // Update the feeding schedule
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('feeding_schedules')
            .doc(schedule.id)
            .update({'completedPetIds': petIds, 'isCompleted': true});

        // Record completion in pets' feeding history
        final batch = FirebaseFirestore.instance.batch();
        for (final petId in petIds) {
          // Check if a feeding record already exists for this pet and schedule
          final existingRecords =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('pets')
                  .doc(petId)
                  .collection('feeding_history')
                  .where('scheduleId', isEqualTo: schedule.id)
                  .get();

          if (existingRecords.docs.isEmpty) {
            // Only create a new record if one doesn't exist
            final feedingHistoryRef =
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('pets')
                    .doc(petId)
                    .collection('feeding_history')
                    .doc();

            batch.set(feedingHistoryRef, {
              'scheduleId': schedule.id,
              'time': '${schedule.time.hour}:${schedule.time.minute}',
              'completedAt': FieldValue.serverTimestamp(),
            });
          }
        }
        await batch.commit();

        // Update local state
        feedingSchedules[index] = schedule.copyWith(
          completedPetIds: petIds,
          isCompleted: true,
        );
      }
    } catch (e) {
      print('Error marking feeding complete: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markFeedingIncomplete(int index) async {
    try {
      final schedule = feedingSchedules[index];
      if (schedule.id != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('feeding_schedules')
            .doc(schedule.id)
            .update({'completedPetIds': [], 'isCompleted': false});

        feedingSchedules[index] = schedule.copyWith(
          completedPetIds: [],
          isCompleted: false,
        );
      }
    } catch (e) {
      print('Error marking feeding incomplete: $e');
    }
  }

  Future<void> toggleReminder(bool value) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'feedingReminderEnabled': value,
      });
      reminderEnabled.value = value;

      // Handle notifications based on reminder toggle
      if (value) {
        // Schedule notifications for all feeding times
        for (var schedule in feedingSchedules) {
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
              title: 'Feeding Time Reminder',
              body: 'Time to feed your pets!',
              scheduledTime: scheduledTime,
            );
          }
        }
      } else {
        // Cancel only the feeding notifications for this user's schedules
        for (var schedule in feedingSchedules) {
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

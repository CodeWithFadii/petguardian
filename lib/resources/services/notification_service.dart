import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (!status.isGranted) {
      print('Notification permission denied. Notifications may not appear.');
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    bool useExact = true;

    // Check and request exact alarm permission for Android 12+
    final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
    if (!exactAlarmStatus.isGranted) {
      final result = await Permission.scheduleExactAlarm.request();
      if (!result.isGranted) {
        print(
          'Exact alarm permission denied. Falling back to inexact scheduling.',
        );
        useExact = false;
      }
    }

    try {
      // Convert to TZDateTime and set it to repeat daily
      final scheduledTZ = tz.TZDateTime.from(scheduledTime, tz.local);

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTZ,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'pet_guardian_channel',
            'Scheduled Notifications',
            channelDescription: 'This channel is for scheduled notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode:
            useExact
                ? AndroidScheduleMode.exactAllowWhileIdle
                : AndroidScheduleMode.inexact,
        matchDateTimeComponents:
            DateTimeComponents.time, // This makes it repeat daily
      );
      print('Daily notification scheduled with ID: $id, exact: $useExact');
    } on PlatformException catch (e) {
      print('Error scheduling notification: $e');
      if (e.code == 'exact_alarms_not_permitted' && useExact) {
        print('Retrying with inexact scheduling.');
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'pet_guardian_channel',
              'Scheduled Notifications',
              channelDescription: 'This channel is for scheduled notifications',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: false,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexact,
          matchDateTimeComponents:
              DateTimeComponents.time, // This makes it repeat daily
        );
        print('Daily notification scheduled with ID: $id (inexact)');
      } else {
        rethrow;
      }
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    print('Notification with ID: $id cancelled');
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('All notifications cancelled');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    print('Pending notifications count: ${pending.length}');
    return pending;
  }

  Future<int> getRandomNotificationId() async {
    return Random().nextInt(99999); // Avoids id collisions
  }

  Future<void> scheduleBlockedUserNotification({
    required String userId,
    required String userName,
  }) async {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      9,
      0,
    ); // Schedule for 9 AM

    await scheduleNotification(
      id: userId.hashCode,
      title: 'Blocked User Reminder',
      body:
          'You have blocked $userName. You won\'t see their posts or comments.',
      scheduledTime: scheduledTime,
    );
  }

  Future<void> cancelBlockedUserNotification(String userId) async {
    await cancelNotification(userId.hashCode);
  }

  Future<void> cancelAllBlockedUserNotifications() async {
    await cancelAllNotifications();
  }
}

Future<void> setupTimeZone() async {
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
}

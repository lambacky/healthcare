import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('logo');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {});
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            priority: Priority.high, importance: Importance.max));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {required int id,
      String? title,
      String? body,
      String? payLoad,
      required TimeOfDay scheduleTime}) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleDaily(scheduleTime),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime scheduleDaily(TimeOfDay scheduleTime) {
    final now = DateTime.now();
    final scheduleDate = DateTime(
        now.year, now.month, now.day, scheduleTime.hour, scheduleTime.minute);
    final tzScheduleDate = tz.TZDateTime.from(scheduleDate, tz.local);
    return (scheduleDate.compareTo(now) < 0)
        ? tzScheduleDate.add(const Duration(days: 1))
        : tzScheduleDate;
  }
}

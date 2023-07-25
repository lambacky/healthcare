import 'dart:math';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/models/medication_reminder.dart';
import 'package:healthcare/models/medication_type.dart';
import 'package:healthcare/services/firebase_service.dart';

import '../services/notification_service.dart';

class MedicationReminderViewModel extends ChangeNotifier {
  List<MedicationReminder> _reminders = [];
  List<MedicationReminder> get reminders => _reminders;
  late MedicationReminder _reminder;
  late MedicationReminder _currentReminder;
  late int _currentIndex;
  MedicationReminder get reminder => _reminder;
  MedicationReminder get currentReminder => _currentReminder;
  late bool _isEnabled;
  bool get isEnabled => _isEnabled;

  void getReminders(Map<String, dynamic>? data) async {
    _reminders.clear();
    if (data != null &&
        data.containsKey('medicine') &&
        data['medicine'].length > 0) {
      List<dynamic> reminders = data['medicine'];
      _reminders =
          reminders.map((item) => MedicationReminder.fromJson(item)).toList();
      bool isPending = await NotificationService().checkPendingNotications();
      if (!isPending) {
        for (var reminder in _reminders) {
          for (int i = 0; i < reminder.schedule.length; i++) {
            await NotificationService().scheduleNotification(
                id: reminder.notificationIds[i],
                scheduleTime: reminder.schedule[i],
                title: "Medication",
                body:
                    'Take ${reminder.doses} ${reminder.medicationType.unit} of ${reminder.name}');
          }
        }
      }
    }
    notifyListeners();
  }

  Future<bool> deleteReminder(int index) async {
    try {
      for (var id in _reminders[index].notificationIds) {
        await NotificationService().cancelNotification(id);
      }
      _reminders.removeAt(index);
      await updateData();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateData() async {
    List<dynamic> reminders = _reminders.map((item) => item.toJson()).toList();
    await FireBaseService().updateData({'medicine': reminders});
  }

  Future<bool> updateReminder() async {
    try {
      List<int> notificationIds = [];
      for (var scheduleTime in _reminder.schedule) {
        int id = Random().nextInt(10000);
        notificationIds.add(id);
        await NotificationService().scheduleNotification(
            id: id,
            scheduleTime: scheduleTime,
            title: "Medication",
            body:
                'Take ${_reminder.doses} ${_reminder.medicationType.unit} of ${_reminder.name}');
      }
      _reminder.updateNotificationIds(notificationIds);
      if (_currentReminder.notificationIds.isNotEmpty) {
        for (var id in _currentReminder.notificationIds) {
          await NotificationService().cancelNotification(id);
        }
      }
      if (_currentIndex < _reminders.length) {
        _reminders[_currentIndex] = _reminder;
      } else {
        _reminders.add(_reminder);
      }
      await updateData();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void getReminder(int index) {
    if (index == _reminders.length) {
      _reminder = MedicationReminder(
          name: '',
          doses: '',
          times: '',
          medicationType: Constants.medicationTypes[0].clone(),
          schedule: [],
          notificationIds: []);
    } else {
      _reminder = reminders[index].clone();
    }
    _currentReminder = _reminder.clone();
    _reminder = reminder;
    _currentIndex = index;
    _isEnabled = false;
    notifyListeners();
  }

  void checkValid() {
    _isEnabled = _reminder.name.isNotEmpty &&
        _reminder.doses.isNotEmpty &&
        _reminder.times.isNotEmpty &&
        _reminder.schedule.isNotEmpty &&
        _reminder != _currentReminder;
    notifyListeners();
  }

  void updateName(String name) {
    _reminder.updateName(name);
    checkValid();
  }

  void updateDoses(String doses) {
    _reminder.updateDoses(doses);
    checkValid();
  }

  void updateTimes(String times) {
    _reminder.updateTimes(times);
    checkValid();
  }

  void updateType(MedicationType type) {
    _reminder.updateType(type);
    checkValid();
  }

  void deleteScheduleTime(TimeOfDay scheduleTime) {
    _reminder.deleteScheduleTime(scheduleTime);
    checkValid();
  }

  void addScheduleTime(DateTime dateTime, TimeOfDay? scheduleTime) {
    _reminder.addScheduleTime(dateTime, scheduleTime);
    checkValid();
  }
}

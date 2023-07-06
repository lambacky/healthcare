import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late bool _isEnabled;
  bool get isEnabled => _isEnabled;

  void getReminders(Map<String, dynamic>? data) {
    if (data != null &&
        data.containsKey('medicine') &&
        data['medicine'].length > 0) {
      List<dynamic> reminders = data['medicine'];
      for (var item in reminders) {
        _reminders.add(MedicationReminder.fromJson(item));
      }
    }
    notifyListeners();
  }

  Future<void> deleteReminder(int index) async {
    try {
      await FireBaseService().updateData({
        'medicine': FieldValue.arrayRemove([_reminders[index].toJson()])
      });
      for (var id in _reminders[index].notificationIds) {
        await NotificationService().cancelNotification(id);
      }
      _reminders.removeAt(index);
      notifyListeners();
    } catch (e) {}
  }

  Future<void> updateReminder() async {
    try {
      _reminder.notificationIds = [];
      for (var scheduleTime in _reminder.schedule) {
        int id = Random().nextInt(10000);
        _reminder.notificationIds.add(id);
        await NotificationService()
            .scheduleNotification(id: id, scheduleTime: scheduleTime);
      }
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

      List<dynamic> reminders = [];
      for (var reminder in _reminders) {
        reminders.add(reminder.toJson());
      }
      await FireBaseService().updateData({'medicine': reminders});
      notifyListeners();
    } catch (e) {
      print(e);
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

  void checkButtonState() {
    _isEnabled = _reminder.name.isNotEmpty &&
        _reminder.doses.isNotEmpty &&
        _reminder.times.isNotEmpty &&
        _reminder.schedule.isNotEmpty &&
        _reminder != _currentReminder;
    notifyListeners();
  }

  void updateName(String name) {
    _reminder.name = name;
    checkButtonState();
  }

  void updateDoses(String doses) {
    _reminder.doses = doses;
    checkButtonState();
  }

  void updateTimes(String times) {
    _reminder.times = times;
    checkButtonState();
  }

  void updateType(MedicationType type) {
    _reminder.medicationType = type;
    checkButtonState();
  }

  void deleteScheduleTime(TimeOfDay scheduleTime) {
    _reminder.schedule.remove(scheduleTime);
    checkButtonState();
  }

  void addScheduleTime(DateTime dateTime, TimeOfDay? scheduleTime) {
    TimeOfDay newScheduleTime = TimeOfDay.fromDateTime(dateTime);
    if (scheduleTime != null && scheduleTime != newScheduleTime) {
      _reminder.schedule.remove(scheduleTime);
    }
    int insertIndex = _reminder.schedule.length;
    for (int i = 0; i < _reminder.schedule.length; i++) {
      int compare =
          _reminder.schedule[i].toString().compareTo(scheduleTime.toString());
      if (compare == 0) {
        return;
      } else if (compare > 0) {
        insertIndex = i;
        break;
      }
    }
    _reminder.schedule.insert(insertIndex, newScheduleTime);
    checkButtonState();
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/medication_type.dart';

class MedicationReminder extends Equatable {
  String name;
  String doses;
  String times;
  MedicationType medicationType;
  List<TimeOfDay> schedule;
  List<int> notificationIds;
  MedicationReminder({
    required this.name,
    required this.doses,
    required this.times,
    required this.medicationType,
    required this.schedule,
    required this.notificationIds,
  });

  factory MedicationReminder.fromJson(Map<String, dynamic> json) {
    List<TimeOfDay> schedule = [];
    json['schedule'].forEach((timeString) {
      List<String> timeParts = timeString.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      schedule.add(TimeOfDay(hour: hour, minute: minute));
    });
    List<int> ids = [];
    json['notificationIds'].forEach((value) {
      int id = int.parse(value.toString());
      ids.add(id);
    });
    return MedicationReminder(
        name: json['name'],
        doses: json['doses'],
        times: json['times'],
        medicationType: MedicationType.fromString(json['medicationType']),
        schedule: schedule,
        notificationIds: ids);
  }

  Map<String, dynamic> toJson() {
    List<String> timeSchedule = [];
    for (var time in schedule) {
      timeSchedule.add(time.toString().split('(')[1].split(')')[0]);
    }
    return {
      'name': name,
      'doses': doses,
      'times': times,
      'medicationType': medicationType.name,
      'schedule': timeSchedule,
      'notificationIds': notificationIds
    };
  }

  MedicationReminder clone() {
    return MedicationReminder(
        name: name,
        doses: doses,
        times: times,
        medicationType: medicationType,
        schedule: List.from(schedule),
        notificationIds: List.from(notificationIds));
  }

  @override
  List<Object?> get props =>
      [name, doses, times, medicationType, schedule, notificationIds];

  void updateName(String medicationName) {
    name = medicationName;
  }

  void updateDoses(String medicationDoses) {
    doses = medicationDoses;
  }

  void updateTimes(String medicationTimes) {
    times = medicationTimes;
  }

  void updateType(MedicationType type) {
    medicationType = type;
  }

  void deleteScheduleTime(TimeOfDay scheduleTime) {
    schedule.remove(scheduleTime);
  }

  void addScheduleTime(DateTime dateTime, TimeOfDay? scheduleTime) {
    TimeOfDay newScheduleTime = TimeOfDay.fromDateTime(dateTime);
    if (scheduleTime != null && scheduleTime != newScheduleTime) {
      schedule.remove(scheduleTime);
    }
    int insertIndex = schedule.length;
    for (int i = 0; i < schedule.length; i++) {
      int compare = schedule[i].toString().compareTo(scheduleTime.toString());
      if (compare == 0) {
        return;
      } else if (compare > 0) {
        insertIndex = i;
        break;
      }
    }
    schedule.insert(insertIndex, newScheduleTime);
  }

  void updateNotificationIds(List<int> ids) {
    notificationIds = ids;
  }
}

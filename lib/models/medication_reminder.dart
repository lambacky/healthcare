import 'package:flutter/material.dart';
import 'package:healthcare/models/medication_type.dart';

class MedicationReminder {
  String name;
  String doses;
  String times;
  MedicationType medicationType;
  List<TimeOfDay> schedule;
  MedicationReminder({
    required this.name,
    required this.doses,
    required this.times,
    required this.medicationType,
    required this.schedule,
  });

  factory MedicationReminder.fromJson(Map<String, dynamic> json) {
    List<TimeOfDay> schedule = [];
    json['schedule'].forEach((timeString) {
      List<String> timeParts = timeString.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      schedule.add(TimeOfDay(hour: hour, minute: minute));
    });
    return MedicationReminder(
        name: json['name'],
        doses: json['doses'],
        times: json['times'],
        medicationType: MedicationType.fromJson(json['medicationType']),
        schedule: schedule);
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
      'medicationType': medicationType.toJson(),
      'schedule': timeSchedule
    };
  }
}

import 'package:equatable/equatable.dart';

class RunningTarget extends Equatable {
  double targetDistance;
  double achievedDistance;
  DateTime startDate;
  DateTime endDate;
  String status;
  RunningTarget(
      {required this.targetDistance,
      required this.achievedDistance,
      required this.startDate,
      required this.endDate,
      required this.status});
  factory RunningTarget.fromJson(Map<String, dynamic> json) {
    return RunningTarget(
        startDate: json['startDate'].toDate(),
        endDate: json['endDate'].toDate(),
        targetDistance: json['targetDistance'].toDouble(),
        achievedDistance: json['achievedDistance'].toDouble(),
        status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {
      "startDate": startDate,
      "endDate": endDate,
      "targetDistance": targetDistance,
      "achievedDistance": achievedDistance,
      "status": status
    };
  }

  RunningTarget clone() {
    return RunningTarget(
        targetDistance: targetDistance,
        achievedDistance: achievedDistance,
        startDate: startDate,
        endDate: endDate,
        status: status);
  }

  @override
  List<Object?> get props =>
      [targetDistance, achievedDistance, startDate, endDate, status];

  void updateDistance(String distance) {
    targetDistance =
        (distance.isEmpty || distance == '.') ? 0 : double.parse(distance);
  }

  void updateDate(DateTime dateTime, String type) {
    if (type == 'start') {
      startDate =
          DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
      if (startDate.compareTo(endDate) > 0) {
        endDate = DateTime(
            startDate.year, startDate.month, startDate.day, 23, 59, 59);
      }
    } else {
      endDate =
          DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
    }
  }

  bool checkDistance(double distance) {
    if (status == 'progress') {
      achievedDistance += distance;
      if (achievedDistance > targetDistance) {
        status = 'finished';
      }
      return true;
    }
    return false;
  }

  bool checkDueDate() {
    if (status == 'progress') {
      if (DateTime.now().compareTo(endDate) > 0) {
        status = 'finished';
        return true;
      }
    }
    return false;
  }
}

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
}

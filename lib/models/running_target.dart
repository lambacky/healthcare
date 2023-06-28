class RunningTarget {
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
}

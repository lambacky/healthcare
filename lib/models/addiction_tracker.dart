class AddictionTracker {
  String type;
  DateTime startDate;

  AddictionTracker({required this.type, required this.startDate});

  factory AddictionTracker.fromJson(Map<String, dynamic> json) {
    return AddictionTracker(
        type: json['type'], startDate: json['startDate'].toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'startDate': startDate,
    };
  }
}

import 'package:equatable/equatable.dart';

class AddictionTracker extends Equatable {
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

  AddictionTracker clone() {
    return AddictionTracker(type: type, startDate: startDate);
  }

  @override
  List<Object?> get props => [type, startDate];
}

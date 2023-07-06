class PhysicalStatus {
  int height;
  int weight;
  double bmi;
  String status;
  PhysicalStatus(
      {required this.height,
      required this.weight,
      required this.bmi,
      required this.status});

  factory PhysicalStatus.fromJson(Map<String, dynamic> json) {
    return PhysicalStatus(
      height: json['height'],
      weight: json['weight'],
      bmi: json['bmi'].toDouble(),
      status: json['status'],
    );
  }

  // send data to server
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'status': status,
    };
  }
}

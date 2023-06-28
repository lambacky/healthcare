class PhysicalStatus {
  int height;
  int weigth;
  double bmi;
  String status;
  PhysicalStatus(
      {required this.height,
      required this.weigth,
      required this.bmi,
      required this.status});

  factory PhysicalStatus.fromJson(Map<String, dynamic> json) {
    return PhysicalStatus(
      height: json['height'],
      weigth: json['weigth'],
      bmi: json['bmi'].toDouble(),
      status: json['status'],
    );
  }

  // send data to server
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weigth': weigth,
      'bmi': bmi,
      'status': status,
    };
  }
}

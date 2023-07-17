class Meal {
  final int id;
  final String imageType;
  final String title;

  Meal({required this.id, required this.imageType, required this.title});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
        id: json['id'], imageType: json['imageType'], title: json['title']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageType': imageType,
    };
  }
}

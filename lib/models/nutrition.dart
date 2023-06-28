class Nutrition {
  final double calories;
  final double carbs;
  final double fat;
  final double protein;

  Nutrition(
      {required this.calories,
      required this.carbs,
      required this.fat,
      required this.protein});

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
        calories: json['calories'],
        carbs: json['carbohydrates'],
        fat: json['fat'],
        protein: json['protein']);
  }
}

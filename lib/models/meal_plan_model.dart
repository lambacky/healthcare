import 'meal_model.dart';

class MealPlan {
  final List<Meal> meals;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;

  MealPlan({
    required this.meals,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    List<Meal> meals = [];
    json['meals'].forEach((meal) => meals.add(Meal.fromJson(meal)));
    return MealPlan(
      meals: meals,
      calories: json['nutrients']['calories'],
      carbs: json['nutrients']['carbohydrates'],
      fat: json['nutrients']['fat'],
      protein: json['nutrients']['protein'],
    );
  }
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> mealList = [];
    for (var meal in meals) {
      mealList.add(meal.toJson());
    }
    return {
      "meals": mealList,
      "nutrients": {
        "calories": calories,
        "carbohydrates": carbs,
        "fat": fat,
        "protein": protein
      }
    };
  }
}

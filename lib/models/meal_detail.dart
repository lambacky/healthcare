import 'ingredients.dart';

class MealDetail {
  final String title;
  final String image;
  final int servings;
  final int readyInMinutes;
  final List<Ingredient> ingredients;

  MealDetail(
      {required this.title,
      required this.image,
      required this.servings,
      required this.readyInMinutes,
      required this.ingredients});

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];
    json['extendedIngredients'].forEach(
        (ingredient) => ingredients.add(Ingredient.fromJson(ingredient)));
    return MealDetail(
        title: json['title'],
        image: json['image'],
        servings: json['servings'],
        readyInMinutes: json['readyInMinutes'],
        ingredients: ingredients);
  }
}

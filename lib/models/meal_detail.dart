import 'ingredients_model.dart';

class MealDetail {
  final String title;
  final String image;
  final int servings;
  final int readyInMinutes;
  final List<Ingredient> ingredients;
  // final List<Nutrition> nutritions;

  MealDetail(
      {required this.title,
      required this.image,
      required this.servings,
      required this.readyInMinutes,
      required this.ingredients
      //,required this.nutritions
      });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];
    // List<Nutrition> nutritions = [];
    json['extendedIngredients'].forEach(
        (ingredient) => ingredients.add(Ingredient.fromJson(ingredient)));
    // json['nutrition']['nutrients']
    //     .forEach((nutrient) => nutritions.add(Nutrition.fromJson(nutrient)));
    return MealDetail(
        title: json['title'],
        image: json['image'],
        servings: json['servings'],
        readyInMinutes: json['readyInMinutes'],
        ingredients: ingredients
        // ,nutritions: nutritions
        );
  }
}

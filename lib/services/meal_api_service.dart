import 'dart:convert';
import 'dart:io';
import 'package:healthcare/models/meal_detail.dart';
import '../models/recipe_steps.dart';
import '../models/meal_plan.dart';
import 'package:http/http.dart' as http;

class MealApiService {
  final String _baseUrl = 'api.spoonacular.com';
  static const String _apiKey = '5f2ccb50ed524b99a148b252acfe8704';

  // Generate Meal Plan
  Future<MealPlan> generateMealPlan(
      {required int targetCalories, required String diet}) async {
    if (diet == 'None') diet = '';
    Map<String, String> parameters = {
      'timeFrame': 'day',
      'targetCalories': targetCalories.toString(),
      'diet': diet,
      'apiKey': _apiKey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/mealplanner/generate',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      var response = await http.get(uri, headers: headers);
      Map<String, dynamic> data = json.decode(response.body);
      MealPlan mealPlan = MealPlan.fromJson(data);
      return mealPlan;
    } catch (err) {
      throw err.toString();
    }
  }

  Future<MealDetail> getMealInformation(String id) async {
    Map<String, String> parameters = {
      'apiKey': _apiKey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/recipes/$id/information',
      parameters,
    );
    try {
      var response = await http.get(uri);
      var data = jsonDecode(response.body);
      MealDetail mealDetail = MealDetail.fromJson(data);
      return mealDetail;
    } catch (err) {
      throw err.toString();
    }
  }

  Future<List<RecipeStepsModel>> fetchRecipeSteps(String id) async {
    Map<String, String> parameters = {
      'apiKey': _apiKey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/recipes/$id/analyzedInstructions',
      parameters,
    );

    try {
      var response = await http.get(uri);
      var data = jsonDecode(response.body)[0]['steps'] as List;
      List<RecipeStepsModel> recipeSteps =
          data.map((tagJson) => RecipeStepsModel.fromJson(tagJson)).toList();
      return recipeSteps;
    } catch (err) {
      throw err.toString();
    }
  }
}

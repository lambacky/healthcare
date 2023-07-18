import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/meal_detail.dart';
import 'package:healthcare/models/meal_plan.dart';
import 'package:healthcare/models/recipe_steps.dart';

import '../services/firebase_service.dart';
import '../services/meal_api_service.dart';

class MealPlanViewModel extends ChangeNotifier {
  MealPlan? _mealPlan;
  MealPlan? get mealPlan => _mealPlan;
  bool _isSaved = false;
  bool get isSaved => _isSaved;
  late double _targetCalories;
  late String _diet;
  MealDetail? _mealDetail;
  MealDetail? get mealDetail => _mealDetail;
  List<RecipeStepsModel>? _recipeSteps;
  List<RecipeStepsModel>? get recipeSteps => _recipeSteps;
  bool _loading = false;
  bool get loading => _loading;

  void getMealPlan(Map<String, dynamic>? data) {
    if (data != null &&
        data.containsKey('mealPlan') &&
        data['mealPlan'] != null) {
      _mealPlan = MealPlan.fromJson(data['mealPlan']);
      _isSaved = true;
    }
    notifyListeners();
  }

  void setMealPlanInfo(double targetCalories, String diet) {
    _targetCalories = targetCalories;
    _diet = diet;
  }

  Future<void> fetchMealPlan() async {
    _loading = true;
    try {
      if (!_isSaved) {
        _mealPlan = await MealApiService().generateMealPlan(
          targetCalories: _targetCalories.toInt(),
          diet: _diet,
        );
      }
    } catch (e) {
      print("error network connection");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchMealInfo(int id) async {
    _loading = true;
    try {
      _mealDetail = await MealApiService().getMealInformation(id.toString());
      _recipeSteps = await MealApiService().fetchRecipeSteps(id.toString());
    } catch (e) {
      print("error network connection");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> saveMealPlan() async {
    try {
      await FireBaseService().updateData({'mealPlan': mealPlan!.toJson()});
      _isSaved = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeMealPlan() async {
    try {
      await FireBaseService().updateData({'mealPlan': FieldValue.delete()});
      _mealPlan = null;
      _isSaved = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

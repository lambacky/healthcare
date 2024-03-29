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
  double _targetCalories = 2250;
  double get targetCalories => _targetCalories;
  String _diet = 'None';
  String get diet => _diet;
  MealDetail? _mealDetail;
  MealDetail? get mealDetail => _mealDetail;
  List<RecipeStepsModel>? _recipeSteps;
  List<RecipeStepsModel>? get recipeSteps => _recipeSteps;
  bool _loading = false;
  bool get loading => _loading;

  void getMealPlan(Map<String, dynamic>? data) {
    _isSaved = false;
    _mealPlan = null;
    if (data != null &&
        data.containsKey('mealPlan') &&
        data['mealPlan'] != null) {
      _mealPlan = MealPlan.fromJson(data['mealPlan']);
      _isSaved = true;
    }
    notifyListeners();
  }

  // void setMealPlanInfo(double targetCalories, String diet) {
  //   _targetCalories = targetCalories;
  //   _diet = diet;
  // }

  void setTargetCalories(double targetCalories) {
    _targetCalories = targetCalories;
    notifyListeners();
  }

  void setDiet(String diet) {
    _diet = diet;
    notifyListeners();
  }

  Future<void> fetchMealPlan() async {
    _loading = true;
    if (!_isSaved) {
      _mealPlan = await MealApiService().generateMealPlan(
        targetCalories: _targetCalories.toInt(),
        diet: _diet,
      );
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchMealInfo(int id) async {
    _loading = true;
    _mealDetail = await MealApiService().getMealInformation(id.toString());
    _recipeSteps = await MealApiService().fetchRecipeSteps(id.toString());
    _loading = false;
    notifyListeners();
  }

  Future<bool> saveMealPlan() async {
    try {
      await FireBaseService().updateData({'mealPlan': mealPlan!.toJson()});
      _isSaved = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeMealPlan() async {
    try {
      await FireBaseService().updateData({'mealPlan': FieldValue.delete()});
      _mealPlan = null;
      _isSaved = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}

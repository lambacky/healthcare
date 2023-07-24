import 'package:flutter/material.dart';
import 'package:healthcare/views/meal/meal_plan_screen.dart';
import 'package:healthcare/view-models/meal_plan_view_model.dart';
import 'package:provider/provider.dart';
import 'meal_list_screen.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MealPlanViewModel>(
          builder: (context, mealPlanViewModel, child) {
        if (mealPlanViewModel.isSaved) {
          return const MealListScreen();
        }
        return const MealPlanScreen();
      }),
    );
  }
}

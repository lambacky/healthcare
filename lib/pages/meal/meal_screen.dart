import 'package:flutter/material.dart';
import 'package:healthcare/pages/meal/meal_plan_screen.dart';
import 'package:provider/provider.dart';

import '../../models/meal_plan_model.dart';
import '../../providers/user_firestore.dart';
import 'meal_list_screen.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({Key? key}) : super(key: key);

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserFireStore>(builder: (context, userFireStore, child) {
        if (userFireStore.userData.isNotEmpty) {
          if (userFireStore.userData.containsKey("mealPlan") &&
              userFireStore.userData['mealPlan'] != null) {
            MealPlan mealPlan =
                MealPlan.fromJson(userFireStore.userData['mealPlan']);
            return MealListScreen(mealPlan: mealPlan);
          }
        }
        return const MealPlanScreen();
      }),
    );
  }
}

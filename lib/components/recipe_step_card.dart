import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view-models/meal_plan_view_model.dart';

class RecipeCard extends StatelessWidget {
  final int index;
  const RecipeCard({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final recipeStep = context.read<MealPlanViewModel>().recipeSteps![index];
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ListTile(
          leading: Text(recipeStep.number.toString()),
          title: Text(
            recipeStep.step,
            textAlign: TextAlign.justify,
          ),
        ),
      ]),
    );
  }
}

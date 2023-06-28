import 'package:flutter/material.dart';
import 'recipe_step_card.dart';
import '/models/recipe_steps.dart';

class RecipeSteps extends StatelessWidget {
  final List<RecipeStepsModel> recipeSteps;

  const RecipeSteps({Key? key, required this.recipeSteps}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Steps",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              //  physics: NeverScrollableScrollPhysics(),
              itemCount: recipeSteps.length,
              itemBuilder: (context, index) => RecipeCard(
                  recipeStep: recipeSteps[index].step,
                  recipeStepNumber: recipeSteps[index].number),
            ),
          )
        ],
      ),
    );
  }
}

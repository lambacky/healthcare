import 'package:flutter/material.dart';

import '../../components/ingredient_card.dart';
import '../../models/meal_detail.dart';
import '/components/backdrop.dart';

class MealDetailScreen extends StatefulWidget {
  final MealDetail mealDetail;

  const MealDetailScreen({Key? key, required this.mealDetail})
      : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Detail'),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
              height: size.height * 1.5,
              width: size.width * 1.5,
              child: Column(children: [
                Backdrop(
                  size: size,
                  image: widget.mealDetail.image,
                  serves: widget.mealDetail.servings.toString(),
                  minutes: widget.mealDetail.readyInMinutes.toString(),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.mealDetail.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ingredients",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 105,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.mealDetail.ingredients.length,
                            itemBuilder: (context, index) => IngredientCard(
                                ingredient:
                                    widget.mealDetail.ingredients[index]),
                          ),
                        )
                      ],
                    ))
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Ingredients",
                //     style: Theme.of(context).textTheme.headlineSmall,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // SizedBox(
                //   height: 105,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: widget.mealDetail.ingredients.length,
                //     itemBuilder: (context, index) => IngredientCard(
                //         ingredient: widget.mealDetail.ingredients[index]),
                //   ),
                // )
                // Expanded(child: RecipeSteps(recipeSteps: widget.recipeSteps)),
              ]))),
    );
  }
}

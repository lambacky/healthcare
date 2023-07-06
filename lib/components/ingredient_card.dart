import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view-models/meal_plan_view_model.dart';

class IngredientCard extends StatelessWidget {
  final int index;

  const IngredientCard({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ingredient =
        context.read<MealPlanViewModel>().mealDetail!.ingredients[index];
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 80,
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
              imageUrl:
                  'https://spoonacular.com/cdn/ingredients_100x100/${ingredient.image}',
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(image: imageProvider),
                  ),
                );
              }),
          const SizedBox(height: 10 / 2),
          Text(
            ingredient.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
          ),
          const SizedBox(height: 10 / 4),
          Text(
            ingredient.amount,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

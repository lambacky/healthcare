import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/models/ingredients_model.dart';

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientCard({Key? key, required this.ingredient}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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

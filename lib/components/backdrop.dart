import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../view-models/meal_plan_view_model.dart';

class Backdrop extends StatelessWidget {
  const Backdrop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealDetail = context.read<MealPlanViewModel>().mealDetail!;
    return CachedNetworkImage(
        imageUrl: mealDetail.image,
        imageBuilder: (context, imageProvider) {
          return Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                color: Colors.black12,
                backgroundBlendMode: BlendMode.darken,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Container(
                margin: const EdgeInsets.only(top: 190),
                height: 50,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 8, right: 5),
                      child: Text(
                        'Preparation Time: ${mealDetail.readyInMinutes} min',
                        style: const TextStyle(
                          backgroundColor: Colors.black12,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 8, left: 5),
                      child: Text(
                        'Served for: ${mealDetail.servings}',
                        style: const TextStyle(
                          backgroundColor: Colors.black12,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}

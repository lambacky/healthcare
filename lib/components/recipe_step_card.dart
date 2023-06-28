//import 'dart:math';

import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {
  // var _expanded = false;
  final String recipeStep;
  final int recipeStepNumber;
  const RecipeCard(
      {Key? key, required this.recipeStep, required this.recipeStepNumber})
      : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  // var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: <Widget>[
        ListTile(
          leading: Text(widget.recipeStepNumber.toString()),
          title: Text(
            widget.recipeStep,
            textAlign: TextAlign.justify,
          ),
        ),
      ]),
    );
  }
}

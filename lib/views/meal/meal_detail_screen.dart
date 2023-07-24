import 'package:flutter/material.dart';
import 'package:healthcare/view-models/meal_plan_view_model.dart';
import 'package:provider/provider.dart';
import '../../components/ingredient_card.dart';
import '../../components/recipe_step_card.dart';
import '/components/backdrop.dart';

class MealDetailScreen extends StatelessWidget {
  final int id;
  const MealDetailScreen({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    context.read<MealPlanViewModel>().fetchMealInfo(id);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recipe Detail'),
          centerTitle: true,
        ),
        body: Consumer<MealPlanViewModel>(
            builder: (context, mealPlanViewModel, child) {
          if (mealPlanViewModel.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (mealPlanViewModel.mealDetail == null) {
              return Center(
                  child: Text(
                'Data loading failed. Please check your network',
                style: TextStyle(color: Colors.black.withOpacity(0.3)),
              ));
            }
            return SingleChildScrollView(
                child: Column(children: [
              const Backdrop(),
              const SizedBox(height: 10),
              Text(
                mealPlanViewModel.mealDetail!.title,
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
                          itemCount:
                              mealPlanViewModel.mealDetail!.ingredients.length,
                          itemBuilder: (context, index) =>
                              IngredientCard(index: index),
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Recipe Instructions",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      //  physics: NeverScrollableScrollPhysics(),
                      itemCount: mealPlanViewModel.recipeSteps!.length,
                      itemBuilder: (context, index) => RecipeCard(index: index),
                    )
                  ],
                ),
              )
            ]));
          }
        })

        // mealPlanViewModel.loading
        //     ? const Center(child: CircularProgressIndicator())
        //     : mealPlanViewModel.mealDetail == null
        //         ? Center(
        //             child: Text(
        //             'Data loading failed. Please check your network',
        //             style: TextStyle(color: Colors.black.withOpacity(0.3)),
        //           ))
        //         : SingleChildScrollView(
        //             child: Column(children: [
        //             const Backdrop(),
        //             const SizedBox(height: 10),
        //             Text(
        //               mealPlanViewModel.mealDetail!.title,
        //               textAlign: TextAlign.center,
        //               style: Theme.of(context).textTheme.headlineSmall,
        //             ),
        //             const SizedBox(height: 10),
        //             Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: 10),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       "Ingredients",
        //                       style: Theme.of(context).textTheme.headlineSmall,
        //                     ),
        //                     const SizedBox(height: 20),
        //                     SizedBox(
        //                       height: 105,
        //                       child: ListView.builder(
        //                         scrollDirection: Axis.horizontal,
        //                         itemCount: mealPlanViewModel
        //                             .mealDetail!.ingredients.length,
        //                         itemBuilder: (context, index) =>
        //                             IngredientCard(index: index),
        //                       ),
        //                     )
        //                   ],
        //                 )),
        //             Padding(
        //               padding: const EdgeInsets.all(10),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: <Widget>[
        //                   Text(
        //                     "Recipe Instructions",
        //                     style: Theme.of(context).textTheme.headlineSmall,
        //                   ),
        //                   const SizedBox(height: 10),
        //                   ListView.builder(
        //                     shrinkWrap: true,
        //                     primary: false,
        //                     //  physics: NeverScrollableScrollPhysics(),
        //                     itemCount: mealPlanViewModel.recipeSteps!.length,
        //                     itemBuilder: (context, index) =>
        //                         RecipeCard(index: index),
        //                   )
        //                 ],
        //               ),
        //             )
        //           ])),
        );
  }
}

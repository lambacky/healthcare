import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/submit_button.dart';
import '../../constants/constants.dart';
import '../../view-models/meal_plan_view_model.dart';
import 'meal_list_screen.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  void _searchMealPlan(BuildContext context) async {
    await context.read<MealPlanViewModel>().fetchMealPlan();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MealListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealPlanViewModel = context.watch<MealPlanViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Meal Planner"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Generate 3 daily meals based on your calories target and diet",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Your Meal Plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 25),
                      children: [
                        TextSpan(
                          text: mealPlanViewModel.targetCalories
                              .truncate()
                              .toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' cal',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    min: 300,
                    max: 3000,
                    value: mealPlanViewModel.targetCalories,
                    thumbColor: Colors.red,
                    onChanged: (value) {
                      mealPlanViewModel.setTargetCalories(value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: DropdownButtonFormField(
                      items: Constants.diets.map((String priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(
                            priority,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Diet',
                        labelStyle: TextStyle(fontSize: 18.0),
                      ),
                      onChanged: (value) {
                        mealPlanViewModel.setDiet(value.toString());
                      },
                      value: mealPlanViewModel.diet,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            SubmitButton(
                text: 'Search',
                onPressed: () {
                  _searchMealPlan(context);
                }),
          ],
        ),
      ),
    );
  }
}

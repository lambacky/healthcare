import 'package:flutter/material.dart';
import 'package:healthcare/views/meal/meal_detail_screen.dart';
import 'package:healthcare/services/meal_api_service.dart';
import 'package:healthcare/view-models/meal_plan_view_model.dart';
import 'package:provider/provider.dart';
import '../../components/submit_button.dart';
import '../../models/meal_detail.dart';
import '../../models/recipe_steps.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MealListScreen extends StatefulWidget {
  const MealListScreen({Key? key}) : super(key: key);

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  @override
  void initState() {
    super.initState();
  }

  _buildTotalNutrientsCard() {
    final mealPlan = context.read<MealPlanViewModel>().mealPlan;
    return Container(
      height: 140.0,
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Total Nutrients',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Calories: ${mealPlan!.calories.toString()}cal',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Fat: ${mealPlan.fat.toString()} g',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Protein: ${mealPlan.protein.toString()} g',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Carbs: ${mealPlan.carbs.toString()} g',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                Center(child: Text('Please wait for the recipes to be loaded')),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildMealCard(int index) {
    final meal = context.read<MealPlanViewModel>().mealPlan!.meals[index];
    String mealType = _mealType(index);
    return GestureDetector(
      onTap: () async {
        var navigator = Navigator.of(context);
        _showMyDialog();
        await context.read<MealPlanViewModel>().fetchMealInfo(meal.id);
        navigator.pop();
        navigator.push(
          MaterialPageRoute(
            builder: (_) => const MealDetailScreen(),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CachedNetworkImage(
              imageUrl:
                  'https://spoonacular.com/recipeImages/${meal.id}-556x370.${meal.imageType}',
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 220.0,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                );
              }),
          Container(
            margin: const EdgeInsets.all(60.0),
            padding: const EdgeInsets.all(10.0),
            color: Colors.black45,
            child: Column(
              children: <Widget>[
                Text(
                  mealType,
                  style: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  meal.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _mealType(int index) {
    switch (index) {
      case 0:
        return 'Breakfast';
      case 1:
        return 'Lunch';
      case 2:
        return 'Dinner';
      default:
        return 'Breakfast';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealPlanViewModel = context.watch<MealPlanViewModel>();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Meal Plan"),
          leading: BackButton(onPressed: () {
            if (mealPlanViewModel.isSaved) {
              Navigator.popUntil(context, (route) => route.isFirst);
            } else {
              Navigator.pop(context);
            }
          }),
        ),
        body: mealPlanViewModel.mealPlan == null
            ? Center(
                child: Text(
                'Data loading failed. Please check your network',
                style: TextStyle(color: Colors.black.withOpacity(0.3)),
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  mealPlanViewModel.fetchMealPlan();
                },
                child: ListView.builder(
                  itemCount: 2 + mealPlanViewModel.mealPlan!.meals.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                        child: SubmitButton(
                            text: mealPlanViewModel.isSaved
                                ? 'Change the diet'
                                : 'Save the plan',
                            onPressed: mealPlanViewModel.isSaved
                                ? () {
                                    mealPlanViewModel.changeMealPlan();
                                  }
                                : () {
                                    mealPlanViewModel.saveMealPlan();
                                  }),
                      );
                    }
                    if (index == 1) {
                      return _buildTotalNutrientsCard();
                    }
                    return _buildMealCard(index - 2);
                  },
                )));
  }
}

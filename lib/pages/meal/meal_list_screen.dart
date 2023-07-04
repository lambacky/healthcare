import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/pages/meal/meal_detail_screen.dart';
import 'package:healthcare/pages/meal/meal_plan_screen.dart';
import 'package:healthcare/services/meal_api_service.dart';
import 'package:provider/provider.dart';
import '../../models/meal_detail.dart';
import '../../models/recipe_steps.dart';
import '../../providers/user_firestore.dart';
import '/models/meal_model.dart';
import '/models/meal_plan_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MealListScreen extends StatefulWidget {
  final int? targetCalories;
  final String? diet;
  final MealPlan? mealPlan;

  const MealListScreen(
      {Key? key, this.targetCalories, this.diet, this.mealPlan})
      : super(key: key);

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  MealPlan? mealPlan;
  bool _isMealPlanSaved = false;
  @override
  void initState() {
    super.initState();
    if (widget.mealPlan != null) {
      setState(() {
        mealPlan = widget.mealPlan;
        _isMealPlanSaved = true;
      });
    } else {
      fetchData();
    }
  }

  void fetchData() {
    if (!_isMealPlanSaved) {
      MealApiService()
          .generateMealPlan(
        targetCalories: widget.targetCalories!,
        diet: widget.diet!,
      )
          .then((value) {
        setState(() {
          mealPlan = value;
        });
      });
    }
  }

  _saveMealPlan() {
    context.read<UserFireStore>().updateData({'mealPlan': mealPlan!.toJson()});
    setState(() {
      _isMealPlanSaved = true;
    });
  }

  _changeDiet() async {
    context.read<UserFireStore>().updateData({'mealPlan': FieldValue.delete()});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MealPlanScreen(),
        ));
  }

  _buildTotalNutrientsCard(MealPlan mealPlan) {
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
                'Calories: ${mealPlan.calories.toString()}cal',
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

  _buildMealCard(Meal meal, int index) {
    String mealType = _mealType(index);
    return GestureDetector(
      onTap: () async {
        var navigator = Navigator.of(context);
        _showMyDialog();

        MealDetail mealDetail =
            await MealApiService().getMealInformation(meal.id.toString());
        List<RecipeStepsModel> recipeSteps =
            await MealApiService().fetchRecipeSteps(meal.id.toString());
        navigator.pop();
        navigator.push(
          MaterialPageRoute(
            builder: (_) => MealDetailScreen(
                mealDetail: mealDetail, recipeSteps: recipeSteps),
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Meal Plan"),
          leading: BackButton(onPressed: () {
            if (_isMealPlanSaved && widget.mealPlan == null) {
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
          }),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              fetchData();
            },
            child: mealPlan == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: 2 + mealPlan!.meals.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              fixedSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed:
                                _isMealPlanSaved ? _changeDiet : _saveMealPlan,
                            child: Text(
                              _isMealPlanSaved
                                  ? 'Change the diet'
                                  : 'Save the plan',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }
                      if (index == 1) {
                        return _buildTotalNutrientsCard(mealPlan!);
                      }
                      Meal meal = mealPlan!.meals[index - 2];
                      return _buildMealCard(meal, index - 2);
                    },
                  )));
  }
}

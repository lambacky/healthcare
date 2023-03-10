import 'package:flutter/material.dart';
import 'dart:math';
import '../../components/height_weight.dart';
import 'score_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({Key? key}) : super(key: key);

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  int _height = 170;
  int _weight = 60;
  bool _isFinished = false;
  double _bmiScore = 0;

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("BMI Calculator"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              HeightWeight(
                onChange: (height) {
                  _height = height;
                },
                title: 'Height',
                unit: 'cm',
                initValue: 170,
                minValue: 100,
                maxValue: 250,
              ),
              const SizedBox(
                height: 30,
              ),
              HeightWeight(
                onChange: (weight) {
                  _weight = weight;
                },
                title: 'Weight',
                unit: 'kg',
                initValue: 60,
                minValue: 10,
                maxValue: 200,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: SwipeableButtonView(
                  isFinished: _isFinished,
                  onFinish: () async {
                    await Navigator.push(
                        context,
                        PageTransition(
                            child: ScoreScreen(bmiScore: _bmiScore),
                            type: PageTransitionType.fade));

                    setState(() {
                      _isFinished = false;
                    });
                  },
                  onWaitingProcess: () {
                    //Calculate BMI here
                    calculateBmi();

                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        _isFinished = true;
                      });
                    });
                  },
                  activeColor: Colors.red,
                  buttonWidget: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                  ),
                  buttonText: "CALCULATE",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

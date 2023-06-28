import 'package:flutter/material.dart';
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: SwipeableButtonView(
                  isFinished: _isFinished,
                  onFinish: () async {
                    await Navigator.push(
                        context,
                        PageTransition(
                            child:
                                ScoreScreen(height: _height, weight: _weight),
                            type: PageTransitionType.fade));

                    setState(() {
                      _isFinished = false;
                    });
                  },
                  onWaitingProcess: () {
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
              ),
              const SizedBox(height: 30),
              const Text(
                "Note: BMI is not suitable for athletes, children, elderly individuals, and pregnant women",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

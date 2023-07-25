import 'package:flutter/material.dart';
import 'package:healthcare/components/submit_button.dart';
import 'package:healthcare/view-models/physical_status_view_model.dart';
import 'package:provider/provider.dart';
import '../../components/height_weight.dart';
import 'score_screen.dart';

class BMIScreen extends StatelessWidget {
  const BMIScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int height = 170;
    int weight = 60;
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
                onChange: (value) {
                  height = value;
                },
                title: 'Height',
                unit: 'cm',
                initValue: 170,
                minValue: 100,
                maxValue: 250,
              ),
              HeightWeight(
                onChange: (value) {
                  weight = value;
                },
                title: 'Weight',
                unit: 'kg',
                initValue: 60,
                minValue: 10,
                maxValue: 200,
              ),
              const SizedBox(height: 20),
              SubmitButton(
                  text: 'CALCULATE',
                  onPressed: () {
                    context
                        .read<PhysicStatViewModel>()
                        .setPhysicStat(height, weight);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScoreScreen()),
                    );
                  }),
              const Spacer(),
              const Text(
                "Note: BMI is not suitable for athletes, children, elderly individuals, and pregnant women",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}

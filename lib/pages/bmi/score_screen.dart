import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ScoreScreen extends StatelessWidget {
  final double bmiScore;

  String? bmiStatus;

  String? bmiInterpretation;

  Color? bmiStatusColor;

  ScoreScreen({Key? key, required this.bmiScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setBmiInterpretation();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("BMI Score"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your Score",
                style: TextStyle(fontSize: 30, color: Colors.blue),
              ),
              const SizedBox(
                height: 50,
              ),
              SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                      showLabels: false,
                      showAxisLine: false,
                      showTicks: false,
                      minimum: 0,
                      maximum: 40,
                      ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0,
                            endValue: 18.5,
                            color: Colors.red,
                            sizeUnit: GaugeSizeUnit.factor,
                            startWidth: 0.4,
                            endWidth: 0.4),
                        GaugeRange(
                          startValue: 18.5,
                          endValue: 24.9,
                          color: Colors.green,
                          startWidth: 0.4,
                          endWidth: 0.4,
                          sizeUnit: GaugeSizeUnit.factor,
                        ),
                        GaugeRange(
                          startValue: 24.9,
                          endValue: 29.9,
                          color: Colors.orange,
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.4,
                          endWidth: 0.4,
                        ),
                        GaugeRange(
                          startValue: 29.9,
                          endValue: 40,
                          color: Colors.pink,
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.4,
                          endWidth: 0.4,
                        ),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                            value: bmiScore,
                            lengthUnit: GaugeSizeUnit.logicalPixel,
                            needleLength: 140,
                            enableAnimation: true)
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            angle: 90,
                            positionFactor: 0.4,
                            widget: Text(
                              bmiScore.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ))
                      ])
                ],
              ),
              Text(
                bmiStatus!,
                style: TextStyle(fontSize: 30, color: bmiStatusColor!),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                bmiInterpretation!,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setBmiInterpretation() {
    if (bmiScore > 30) {
      bmiStatus = "OBESE";
      bmiInterpretation = "Please work to reduce obesity";
      bmiStatusColor = Colors.pink;
    } else if (bmiScore >= 25) {
      bmiStatus = "OVERWEIGHT";
      bmiInterpretation = "Do regular exercise & reduce the weight";
      bmiStatusColor = Colors.orange;
    } else if (bmiScore >= 18.5) {
      bmiStatus = "NORMAL";
      bmiInterpretation = "You are fit, keep maintaining your health";
      bmiStatusColor = Colors.green;
    } else if (bmiScore < 18.5) {
      bmiStatus = "UNDERWEIGHT";
      bmiInterpretation = "Please work to increase your weight";
      bmiStatusColor = Colors.red;
    }
  }
}

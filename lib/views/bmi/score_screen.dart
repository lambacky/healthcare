import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare/view-models/physical_status_view_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final physicStatViewModel = context.read<PhysicStatViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("BMI Score"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                            value: physicStatViewModel.physicStat!.bmi,
                            lengthUnit: GaugeSizeUnit.logicalPixel,
                            needleLength: 140,
                            enableAnimation: true)
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            angle: 90,
                            positionFactor: 0.4,
                            widget: Text(
                              physicStatViewModel.physicStat!.bmi
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ))
                      ])
                ],
              ),
              Text(
                physicStatViewModel.physicStat!.status,
                style: TextStyle(
                    fontSize: 30, color: physicStatViewModel.bmiStatusColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                physicStatViewModel.bmiInterpretation,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  physicStatViewModel.updatePhysicStat();
                  bool success = await physicStatViewModel.updatePhysicStat();
                  if (success) {
                    Fluttertoast.showToast(
                        msg: "Physical status saved successful");
                  } else {
                    Fluttertoast.showToast(msg: "Error. Please try again");
                  }
                },
                child: const Text(
                  'Save as your physical status?',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

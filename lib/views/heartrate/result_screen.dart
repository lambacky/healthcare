import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// ignore: must_be_immutable
class ResultScreen extends StatelessWidget {
  final double bpm;

  String? bpmStatus;

  String? bpmInterpretation;

  Color? bpmStatusColor;

  ResultScreen({Key? key, required this.bpm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setbpmInterpretation();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Heart Rate Measurement"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((bpm.round().toString()),
                      style: const TextStyle(
                          fontSize: 70, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 30),
                  const Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 30,
                        color: Colors.red,
                      ),
                      Text(" bpm",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SfLinearGauge(
                minimum: 20,
                maximum: 150,
                showTicks: false,
                showLabels: false,
                axisTrackStyle: const LinearAxisTrackStyle(thickness: 0),
                markerPointers: [
                  LinearShapePointer(
                      value: bpm,
                      shapeType: LinearShapePointerType.triangle,
                      position: LinearElementPosition.inside)
                ],
                ranges: const [
                  //First range.
                  LinearGaugeRange(
                      startValue: 0,
                      endValue: 60,
                      color: Colors.yellow,
                      startWidth: 15,
                      endWidth: 15),
                  //Second range.
                  LinearGaugeRange(
                      startValue: 60,
                      endValue: 100,
                      color: Colors.green,
                      startWidth: 15,
                      endWidth: 15),
                  //Third range.
                  LinearGaugeRange(
                      startValue: 100,
                      endValue: 200,
                      color: Colors.deepOrange,
                      startWidth: 15,
                      endWidth: 15)
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                bpmStatus!,
                style: TextStyle(fontSize: 30, color: bpmStatusColor!),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                bpmInterpretation!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const Expanded(child: SizedBox()),
              const Text("Note: This result is only for reference"),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  void setbpmInterpretation() {
    if (bpm < 60) {
      bpmStatus = "LOW";
      bpmInterpretation = "Your heart rate is lower than average";
      bpmStatusColor = Colors.orange;
    } else if (bpm <= 100) {
      bpmStatus = "NORMAL";
      bpmInterpretation = "Your heart rate is in normal range";
      bpmStatusColor = Colors.green;
    } else {
      bpmStatus = "HIGH";
      bpmInterpretation = "Your heart rate is higher than average";
      bpmStatusColor = Colors.red;
    }
  }
}

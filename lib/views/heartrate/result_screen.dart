import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// ignore: must_be_immutable
class ResultScreen extends StatelessWidget {
  final int bpm;

  String? bpmStatus;

  String? bpmInterpretation;

  Color? bpmStatusColor;

  ResultScreen({Key? key, required this.bpm}) : super(key: key);

  void _setbpmInterpretation() {
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

  @override
  Widget build(BuildContext context) {
    _setbpmInterpretation();
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
              Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 168, 162),
                      width: 10,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text((bpm.toString()),
                        style: const TextStyle(
                            fontSize: 70, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 10),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                      value: bpm.toDouble(),
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
              const Spacer(),
              const Text(
                "Note: This result is only for reference",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}

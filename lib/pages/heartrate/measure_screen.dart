import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'result_screen.dart';

class MeasureScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const MeasureScreen({this.cameras, Key? key}) : super(key: key);

  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  late CameraController _cameraController;
  final List<SensorValue> _data = [];
  final List<double> _bpms = [];
  double _value = 0;
  bool isProcessing = false;
  String _text = "Place you finger on camera";
  Timer? _timer;
  Timer? _bpmTimer;
  double _bpm = 0;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
        widget.cameras![0], ResolutionPreset.max,
        enableAudio: false);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController.setFlashMode(FlashMode.torch);
      _cameraController.startImageStream((CameraImage cameraImage) {
        if (mounted) {
          if (!isProcessing) {
            setState(() {
              isProcessing = true;
            });
            scanImage(cameraImage);
          }
        }
      });
      // setState(() {});
    });
  }

  void scanImage(CameraImage cameraImage) {
    double avg = cameraImage.planes[0].bytes
            .reduce((value, element) => value + element) /
        cameraImage.planes[0].bytes.length;
    double avg1 = cameraImage.planes[1].bytes
            .reduce((value, element) => value + element) /
        cameraImage.planes[1].bytes.length;
    double avg2 = cameraImage.planes[2].bytes
            .reduce((value, element) => value + element) /
        cameraImage.planes[2].bytes.length;
    // List<int> ar = [avg.round(), avg1.round(), avg2.round()];
    // print(ar);

    if (avg < 120 && avg > 80 && avg1 > 150 && avg2 > 150) {
      if (_data.isEmpty) {
        _timer = Timer(const Duration(seconds: 15), () {
          _bpm =
              _bpms.reduce((value, element) => value + element) / _bpms.length;
          // _cameraController.setFlashMode(FlashMode.off);
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 500),
                child: ResultScreen(bpm: _bpm)),
          );
        });
        _bpmTimer = Timer.periodic(const Duration(milliseconds: 1650), (timer) {
          updateBPM();
        });
        _text = "Analyzing...";
        _value = 1;
      }
      _data.add(SensorValue(DateTime.now(), avg));
    } else {
      if (_data.isNotEmpty) {
        _data.clear();
        _bpms.clear();
        _timer?.cancel();
        _bpmTimer?.cancel();
        _text = "Place your finger on camera";
        _value = 0;
      }
    }
    if (_data.length >= 50) {
      _data.removeAt(0);
    }

    Future.delayed(const Duration(milliseconds: 33)).then((onValue) {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    });
  }

  void updateBPM() async {
    List<SensorValue> values;
    double avg;
    int n;
    double m;
    double threshold;
    double bpm;
    int counter;
    int previous;

    values = List.from(_data);
    avg = 0;
    n = values.length;
    m = 0;
    for (var value in values) {
      avg += value.value / n;
      if (value.value > m) m = value.value;
    }
    threshold = (m + avg) / 2;
    bpm = 0;
    counter = 0;
    previous = 0;
    for (int i = 1; i < n; i++) {
      if (values[i - 1].value < threshold && values[i].value > threshold) {
        if (previous != 0) {
          counter++;
          bpm += 60000 / (values[i].time.millisecondsSinceEpoch - previous);
        }
        previous = values[i].time.millisecondsSinceEpoch;
      }
    }
    if (counter > 0) {
      bpm = bpm / counter;
      _bpms.add(bpm);
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _timer?.cancel();
    _bpmTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!_cameraController.value.isInitialized) {
    //   Navigator.pop(context);
    // }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Heart Rate Measurement"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              CircularPercentIndicator(
                animation: true,
                animationDuration: 15000,
                radius: 150,
                lineWidth: 15,
                percent: _value,
                progressColor: Colors.green,
                center: ClipOval(
                  child: SizedBox(
                    width: 270,
                    height: 270,
                    child: CameraPreview(_cameraController),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(_text, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 30),
              Expanded(
                child: SfCartesianChart(
                    margin: const EdgeInsets.all(0),
                    backgroundColor: Colors.black,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: DateTimeAxis(isVisible: false),
                    primaryYAxis: NumericAxis(isVisible: false),
                    series: <ChartSeries>[
                      // Renders fast line chart
                      LineSeries<SensorValue, DateTime>(
                          dataSource: _data,
                          color: Colors.red,
                          width: 3,
                          xValueMapper: (SensorValue data, _) => data.time,
                          yValueMapper: (SensorValue data, _) => data.value)
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);
}

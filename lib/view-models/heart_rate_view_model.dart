import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/sensor_data.dart';

class HeartRateViewModel extends ChangeNotifier {
  late CameraController _cameraController;
  CameraController get cameraController => _cameraController;
  late bool _isProcessing;
  List<SensorData> _data = [];
  List<double> _bpms = [];
  List<double> get bpms => _bpms;
  Timer? _bpmTimer;
  late String _text;
  String get text => _text;
  late double _value;
  double get value => _value;

  Future<void> initialize(CameraDescription camera) async {
    _text = "Place your finger on camera";
    _value = 0;
    _isProcessing = false;
    _data.clear();
    _bpms.clear();
    _cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await _cameraController.initialize();
    _cameraController.setFlashMode(FlashMode.torch);
    _cameraController.startImageStream((CameraImage cameraImage) {
      if (!_isProcessing) {
        _isProcessing = true;
        scanImage(cameraImage);
      }
    });
    notifyListeners();
  }

  void scanImage(CameraImage cameraImage) async {
    double avg = cameraImage.planes[0].bytes
            .reduce((value, element) => value + element) /
        cameraImage.planes[0].bytes.length;
    double avg1 = cameraImage.planes[1].bytes
            .reduce((value, element) => value + element) /
        cameraImage.planes[1].bytes.length;
    double avg2 = cameraImage.planes[2].bytes
            .reduce((value, element) => value + element) /
        cameraImage.planes[2].bytes.length;
    print(
        '${avg.toStringAsFixed(1)}, ${avg1.toStringAsFixed(1)}, ${avg2.toStringAsFixed(1)}');

    if (avg < 120 && avg1 > 150 && avg2 > 150) {
      if (_data.isEmpty) {
        _bpmTimer = Timer.periodic(const Duration(milliseconds: 1650), (timer) {
          updateBPM();
        });
        _text = "Analyzing...";
        _value = 1;
      }
      _data.add(SensorData(time: DateTime.now(), value: avg));
    } else {
      if (_data.isNotEmpty) {
        _data.clear();
        _bpms.clear();
        _bpmTimer?.cancel();
        _text = "Place your finger on camera";
        _value = 0;
      }
    }
    if (_data.length >= 50) {
      _data.removeAt(0);
    }

    Future.delayed(const Duration(milliseconds: 33)).then((onValue) {
      _isProcessing = false;
    });
    notifyListeners();
  }

  void updateBPM() async {
    List<SensorData> values;
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

  Future<void> cancel() async {
    await _cameraController.dispose();
    _bpmTimer?.cancel();
  }
}

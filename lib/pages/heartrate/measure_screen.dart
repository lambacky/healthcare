import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'result_screen.dart';

class MeasureScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const MeasureScreen({this.cameras, Key? key}) : super(key: key);

  @override
  _MeasureScreenState createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  late CameraController controller;
  double _value = 0;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras![0], ResolutionPreset.max,
        enableAudio: false);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    // setState(() {
    //   if (_value == 0) {
    //     _value = 0.4;
    //   } else {
    //     _value = 0;
    //   }
    // });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          bpm: 80,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (!controller.value.isInitialized) {
    //   Navigator.pop(context);
    // }
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
              CircularPercentIndicator(
                animation: true,
                radius: 150,
                lineWidth: 20,
                percent: _value,
                progressColor: Colors.green,
                circularStrokeCap: CircularStrokeCap.round,
                center: ClipOval(
                  child: Container(
                    width: 260,
                    height: 260,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
              TextButton(onPressed: startAnimation, child: const Text("hello"))
            ],
          ),
        ),
      ),
    );
  }
}

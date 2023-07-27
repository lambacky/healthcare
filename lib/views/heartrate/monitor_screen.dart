import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../view-models/heart_rate_view_model.dart';
import 'result_screen.dart';

class MonitorScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MonitorScreen({required this.cameras, Key? key}) : super(key: key);

  @override
  State<MonitorScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MonitorScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HeartRateViewModel>().initialize(widget.cameras[0]);
  }

  _goToResultScreen() {
    final heartRateViewModel = context.read<HeartRateViewModel>();
    if (heartRateViewModel.value == 1) {
      int bpm = heartRateViewModel.getFinalResult();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            bpm: bpm,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() async {
    super.deactivate();
    await context.read<HeartRateViewModel>().cancel();
  }

  @override
  Widget build(BuildContext context) {
    final heartRateViewModel = context.watch<HeartRateViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Heart Rate Measurement"),
      ),
      body: Center(
        child: !heartRateViewModel.cameraController.value.isInitialized
            ? const CircularProgressIndicator()
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      animation: true,
                      animationDuration: 15000,
                      radius: 150,
                      lineWidth: 15,
                      percent: heartRateViewModel.value,
                      progressColor: Colors.green,
                      onAnimationEnd: _goToResultScreen,
                      center: ClipOval(
                        child: SizedBox(
                          width: 270,
                          height: 270,
                          child: CameraPreview(
                              heartRateViewModel.cameraController),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(heartRateViewModel.text,
                        style: const TextStyle(fontSize: 18)),
                    // const SizedBox(height: 20),
                    // Text(heartRateViewModel.bpm.toString(),
                    //     style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
      ),
    );
  }
}

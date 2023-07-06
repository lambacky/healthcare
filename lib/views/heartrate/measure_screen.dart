import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../view-models/heart_rate_view_model.dart';
import 'result_screen.dart';

class MeasureScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MeasureScreen({required this.cameras, Key? key}) : super(key: key);

  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HeartRateViewModel>().initialize(widget.cameras[0]);
  }

  goToResultScreen() {
    final heartRateViewModel = context.read<HeartRateViewModel>();
    if (heartRateViewModel.value == 1) {
      double bpm =
          heartRateViewModel.bpms.reduce((value, element) => value + element) /
              heartRateViewModel.bpms.length;
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500),
            child: ResultScreen(bpm: bpm)),
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
                      onAnimationEnd: goToResultScreen,
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
                    // const SizedBox(height: 30),
                    // Expanded(
                    //   child: SfCartesianChart(
                    //       margin: const EdgeInsets.all(0),
                    //       backgroundColor: Colors.black,
                    //       plotAreaBorderWidth: 0,
                    //       primaryXAxis: DateTimeAxis(isVisible: false),
                    //       primaryYAxis: NumericAxis(isVisible: false),
                    //       series: <ChartSeries>[
                    //         // Renders fast line chart
                    //         LineSeries<SensorValue, DateTime>(
                    //             dataSource: _data,
                    //             color: Colors.red,
                    //             width: 3,
                    //             xValueMapper: (SensorValue data, _) => data.time,
                    //             yValueMapper: (SensorValue data, _) => data.value)
                    //       ]),
                    // )
                  ],
                ),
              ),
      ),
    );
  }
}

import 'package:breathing_collection/breathing_collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:camera/camera.dart';
import 'package:healthcare/pages/heartrate/measure_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({Key? key}) : super(key: key);

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  checkCameraPermission(List<CameraDescription> value) async {
    var cameraStatus = await Permission.camera.request();
    if (cameraStatus.isDenied) {
      return;
    }
    if (cameraStatus.isPermanentlyDenied) {
      openDialog();
      return;
    }
    openMeasureScreen(value);
  }

  openDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Allow app to acess your camera ?'),
        content: const Text(
            'You need to allow camera access to measure heart rate in your app'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Don\'t allow'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  openMeasureScreen(List<CameraDescription> value) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeasureScreen(
          cameras: value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Heart Rate Measurement"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/heart-rate-tutorial.jpg'),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Use your finger to fully cover your phone camera lens. Hold steadily until the measurement is completed",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            BreathingGlowingButton(
              height: 100,
              width: 100,
              buttonBackgroundColor: const Color(0xffFF4B4B),
              glowColor: const Color(0xff11BFEB),
              icon: FontAwesomeIcons.heartPulse,
              onTap: () async {
                await availableCameras()
                    .then((value) => checkCameraPermission(value));
              },
            ),
          ],
        ),
      ),
    );
  }
}

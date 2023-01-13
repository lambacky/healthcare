import 'package:breathing_collection/breathing_collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthcare/pages/running/running_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class RunningMenuScreen extends StatefulWidget {
  const RunningMenuScreen({Key? key}) : super(key: key);

  @override
  State<RunningMenuScreen> createState() => _RunningMenuScreenState();
}

class _RunningMenuScreenState extends State<RunningMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Running"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BreathingGlowingButton(
              height: 150,
              width: 150,
              buttonBackgroundColor: const Color(0xffFF4B4B),
              glowColor: const Color(0xff11BFEB),
              icon: FontAwesomeIcons.heartPulse,
              onTap: () async {
                await checkLocationPermission();
              },
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Start running",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  checkLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Allow app to acess your location ?'),
          content:
              const Text('You need to allow location access to start running'),
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
      return;
    }

    openRunningScreen();
  }

  openRunningScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RunningScreen()),
    );
  }
}

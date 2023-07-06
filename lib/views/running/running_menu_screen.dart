import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthcare/views/running/history_screen.dart';
import 'package:healthcare/views/running/target_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../view-models/target_view_model.dart';
import '../../view-models/track_view_model.dart';
import 'tracking_screen.dart';

class RunningMenuScreen extends StatefulWidget {
  const RunningMenuScreen({Key? key}) : super(key: key);

  @override
  State<RunningMenuScreen> createState() => _RunningMenuScreenState();
}

class _RunningMenuScreenState extends State<RunningMenuScreen> {
  final List pages = const [HistoryScreen(), TargetScreen()];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TargetViewModel>().checkDueDate();
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
      openDialog();
      return;
    }
    openTrackingScreen();
  }

  openDialog() {
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
  }

  openTrackingScreen() {
    context.read<TrackViewModel>().setTrack();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TrackingScreen()),
    ).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await checkLocationPermission();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 4),
        color: Colors.red,
        notchMargin: 4,
        shape: const CircularNotchedRectangle(),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.list,
                        color: _currentIndex == 0
                            ? Colors.white
                            : Colors.white.withOpacity(0.7)),
                    Text("Records",
                        style: TextStyle(
                            color: _currentIndex == 0
                                ? Colors.white
                                : Colors.white.withOpacity(0.7)))
                  ],
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                child: Column(
                  children: [
                    Icon(Icons.track_changes,
                        color: _currentIndex == 1
                            ? Colors.white
                            : Colors.white.withOpacity(0.7)),
                    Text("Targets",
                        style: TextStyle(
                            color: _currentIndex == 1
                                ? Colors.white
                                : Colors.white.withOpacity(0.7)))
                  ],
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

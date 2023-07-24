import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthcare/views/running/history_screen.dart';
import 'package:healthcare/views/running/target_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../view-models/target_view_model.dart';
import '../../view-models/track_view_model.dart';
import 'tracking_screen.dart';

class RunningMenuScreen extends StatelessWidget {
  const RunningMenuScreen({Key? key}) : super(key: key);

  void _checkLocationPermission(BuildContext context) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _openDialog(context);
      return;
    }
    context.read<TrackViewModel>().setTrack();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TrackingScreen()),
    );
  }

  _openDialog(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    context.read<TargetViewModel>().checkDueDate();
    final trackViewModel = context.watch<TrackViewModel>();
    return Scaffold(
      body: trackViewModel.isHistoryScreen
          ? const HistoryScreen()
          : const TargetScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _checkLocationPermission(context);
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
                  trackViewModel.changeScreen(true);
                },
                child: Column(
                  children: [
                    Icon(Icons.list,
                        color: trackViewModel.isHistoryScreen
                            ? Colors.white
                            : Colors.white.withOpacity(0.7)),
                    Text("Records",
                        style: TextStyle(
                            color: trackViewModel.isHistoryScreen
                                ? Colors.white
                                : Colors.white.withOpacity(0.7)))
                  ],
                )),
            GestureDetector(
                onTap: () {
                  trackViewModel.changeScreen(false);
                },
                child: Column(
                  children: [
                    Icon(Icons.track_changes,
                        color: !trackViewModel.isHistoryScreen
                            ? Colors.white
                            : Colors.white.withOpacity(0.7)),
                    Text("Targets",
                        style: TextStyle(
                            color: !trackViewModel.isHistoryScreen
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

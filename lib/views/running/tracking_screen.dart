import 'dart:async';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthcare/view-models/track_view_model.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../view-models/target_view_model.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TrackViewModel>().setInitialLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() async {
    super.deactivate();
    await context.read<TrackViewModel>().cancel();
  }

  void restartRun() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Restart the track ?'),
        content: const Text('All the current data will be cleared'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TrackViewModel>().restartRun();
              Navigator.pop(context);
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void finishRun() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Finish running ?'),
        content: const Text('All the current data will be saved'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              var navigator = Navigator.of(context);
              await context.read<TrackViewModel>().saveRun();
              await context
                  .read<TargetViewModel>()
                  .updateTargets(context.read<TrackViewModel>().track.distance);
              navigator.pop();
              navigator.pop();
              Fluttertoast.showToast(msg: "Running track saved successfully");
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void closeScreen() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Save the track before closing?'),
        content: const Text('All the current data will be saved'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              var navigator = Navigator.of(context);
              await context.read<TrackViewModel>().saveRun();
              await context
                  .read<TargetViewModel>()
                  .updateTargets(context.read<TrackViewModel>().track.distance);
              navigator.pop();
              navigator.pop();
              Fluttertoast.showToast(msg: "Running track saved successfully");
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trackViewModel = context.watch<TrackViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Running"),
        leading: BackButton(onPressed: () {
          if (trackViewModel.runningState != 'none') {
            closeScreen();
          } else {
            Navigator.pop(context);
          }
        }),
      ),
      body: trackViewModel.currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: GoogleMap(
                      myLocationEnabled: true,
                      polylines: trackViewModel.polyLines,
                      initialCameraPosition: CameraPosition(
                          zoom: 15,
                          target: LatLng(
                              trackViewModel.currentPosition!.latitude,
                              trackViewModel.currentPosition!.longitude)),
                      onMapCreated: trackViewModel.onMapCreated),
                ),
                Flexible(
                    child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: [
                              const Text("SPEED (KM/H)",
                                  style: TextStyle(fontSize: 11)),
                              Text(
                                  trackViewModel.track.speed.toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 25))
                            ],
                          ),
                          Column(
                            children: [
                              const Text("TIME",
                                  style: TextStyle(fontSize: 11)),
                              StreamBuilder<int>(
                                stream: trackViewModel.stopWatchTimer!.rawTime,
                                initialData: trackViewModel
                                    .stopWatchTimer!.rawTime.value,
                                builder: (context, snap) {
                                  String displayTime =
                                      StopWatchTimer.getDisplayTime(snap.data!,
                                          milliSecond: false);
                                  return Text(
                                    displayTime,
                                    style: const TextStyle(fontSize: 25),
                                  );
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text("DISTANCE (KM)",
                                  style: TextStyle(fontSize: 11)),
                              Text(
                                  trackViewModel.track.distance
                                      .toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 25))
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          trackViewModel.runningState == "stop"
                              ? TextButton(
                                  onPressed: trackViewModel.restartRun,
                                  style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      fixedSize: const Size(110, 30)),
                                  child: const Text("RESTART"))
                              : const SizedBox(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(90, 90),
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                trackViewModel.runningState != "run"
                                    ? trackViewModel.startRun()
                                    : trackViewModel.stopRun();
                              },
                              child: trackViewModel.runningState == "none"
                                  ? const Text("START",
                                      style: TextStyle(fontSize: 13))
                                  : trackViewModel.runningState == "run"
                                      ? const Text("STOP",
                                          style: TextStyle(fontSize: 13))
                                      : const Text("RESUME",
                                          style: TextStyle(fontSize: 13))),
                          trackViewModel.runningState == "stop"
                              ? TextButton(
                                  onPressed: finishRun,
                                  style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      minimumSize: const Size(110, 30)),
                                  child: const Text("FINISH"))
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ))
              ],
            ),
    );
  }
}

import 'dart:async';

import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  StreamSubscription<Position>? _positionStreamSubscription;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Position? _currentPosition;
  String _runningState = "none";
  late int _time;
  late String _displayTime;
  double _distance = 0;
  double _speed = 0;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final Set<Polyline> _polyLines = {};
  Polyline _polyLine = const Polyline(polylineId: PolylineId("route"));
  int _polyLineCount = 0;
  final List<List<LatLng>> _coordinates = [];

  @override
  void initState() {
    super.initState();
    setInitialLocation();
  }

  void setInitialLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  void _onMapCreated(GoogleMapController mapController) async {
    _controller.complete(mapController);
    var controller = await _controller.future;
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high, distanceFilter: 10))
        .listen((Position position) {
      setState(() {
        if (_runningState == "run") {
          _distance += Geolocator.distanceBetween(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  position.latitude,
                  position.longitude) /
              1000;
          _speed = _stopWatchTimer.secondTime.value > 0
              ? 3600 * _distance / _stopWatchTimer.secondTime.value
              : 0;

          _coordinates[_polyLineCount - 1]
              .add(LatLng(position.latitude, position.longitude));
          _polyLine = Polyline(
            polylineId: PolylineId(_polyLineCount.toString()),
            points: _coordinates[_polyLineCount - 1],
            color: Colors.blue,
            width: 5,
          );
          _polyLines.add(_polyLine);
        }
        _currentPosition = position;
        controller.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude), 15));
      });
    });
  }

  @override
  void dispose() async {
    _positionStreamSubscription?.cancel();
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  void startRun() async {
    setState(() {
      _runningState = "run";
    });
    _coordinates.add([]);
    _polyLineCount++;
    _stopWatchTimer.onStartTimer();
  }

  void stopRun() {
    setState(() {
      _runningState = "stop";
    });

    _stopWatchTimer.onStopTimer();
  }

  void restartRun() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Restart the track ?'),
        content: const Text('All the current data will be cleared'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _runningState = "none";
                _distance = 0.0;
                _speed = 0.0;
                _polyLines.clear();
                _stopWatchTimer.onResetTimer();
                _polyLineCount = 0;
                _coordinates.clear();
              });
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
              var track = {
                "date": DateTime.now(),
                "distance": _distance.toStringAsFixed(2),
                "speed": _speed.toStringAsFixed(2),
                "time": _displayTime,
                "steps": (_distance * 1312.336).round()
              };
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .update({
                "running": FieldValue.arrayUnion([track])
              });
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Running"),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    polylines: _polyLines,
                    initialCameraPosition: CameraPosition(
                        zoom: 15,
                        target: LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude)),
                    onMapCreated: _onMapCreated,
                  ),
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
                              Text(_speed.toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 25))
                            ],
                          ),
                          Column(
                            children: [
                              const Text("TIME",
                                  style: TextStyle(fontSize: 11)),
                              StreamBuilder<int>(
                                stream: _stopWatchTimer.rawTime,
                                initialData: _stopWatchTimer.rawTime.value,
                                builder: (context, snap) {
                                  _time = snap.data!;
                                  _displayTime = StopWatchTimer.getDisplayTime(
                                      _time,
                                      milliSecond: false);
                                  return Text(
                                    _displayTime,
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
                              Text(_distance.toStringAsFixed(2),
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
                          _runningState == "stop"
                              ? TextButton(
                                  onPressed: restartRun,
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
                                _runningState != "run" ? startRun() : stopRun();
                              },
                              child: _runningState == "none"
                                  ? const Text("START",
                                      style: TextStyle(fontSize: 13))
                                  : _runningState == "run"
                                      ? const Text("STOP",
                                          style: TextStyle(fontSize: 13))
                                      : const Text("RESUME",
                                          style: TextStyle(fontSize: 13))),
                          _runningState == "stop"
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

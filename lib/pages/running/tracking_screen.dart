import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import '../../models/running_target.dart';
import '../../models/track_model.dart';
import '../../providers/user_firestore.dart';

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
  final _currentUser = FirebaseAuth.instance.currentUser?.uid;
  final _storageReference = FirebaseStorage.instance.ref();
  String _place = '';
  late double north;
  late double south;
  late double west;
  late double east;

  @override
  void initState() {
    super.initState();
    setInitialLocation();
  }

  void setInitialLocation() async {
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        north = position.latitude;
        south = position.latitude;
        east = position.longitude;
        west = position.longitude;
        setState(() {
          _currentPosition = position;
        });
      });
    } catch (e) {}
  }

  void _onMapCreated(GoogleMapController mapController) async {
    _controller.complete(mapController);
    var controller = await _controller.future;
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high, distanceFilter: 10))
        .listen((Position position) {
      if (position.longitude > east) {
        east = position.longitude;
      } else if (position.longitude < west) {
        west = position.longitude;
      }
      if (position.latitude > north) {
        north = position.latitude;
      } else if (position.latitude < south) {
        south = position.latitude;
      }
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
        if (_runningState != "finish") {
          controller.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(position.latitude, position.longitude), 15));
        }
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
              setState(() {
                _runningState = "finish";
              });
              final userFireStore = context.read<UserFireStore>();

              var navigator = Navigator.of(context);
              try {
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    _currentPosition!.latitude, _currentPosition!.longitude);
                if (placemarks.isNotEmpty) {
                  _place =
                      "${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";
                }
              } catch (e) {}

              var controller = await _controller.future;
              await controller.animateCamera(CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                      southwest: LatLng(south, west),
                      northeast: LatLng(north, east)),
                  15));
              Future.delayed(const Duration(seconds: 2), () async {
                var routeSnapshot = await controller.takeSnapshot();
                String routeImageFile =
                    DateTime.now().microsecondsSinceEpoch.toString();
                String routeImagePath = '$_currentUser/$routeImageFile';
                Reference imageReference =
                    _storageReference.child(routeImagePath);
                await imageReference.putData(routeSnapshot!);
                String routeImageURL = await imageReference.getDownloadURL();
                Track track = Track(
                    date: DateTime.now(),
                    distance: _distance,
                    speed: _speed,
                    time: _displayTime,
                    steps: (_distance * 1312.336).round(),
                    routeImageURL: routeImageURL,
                    routeImagePath: routeImagePath,
                    place: _place);
                List<dynamic> targets = [];
                final user = userFireStore.userData;
                if (user.isNotEmpty) {
                  if (user.containsKey("targets") &&
                      user['targets'].length > 0) {
                    targets = user['targets'];
                    for (int i = 0; i < targets.length; i++) {
                      RunningTarget runningTarget = RunningTarget.fromJson(
                          Map<String, dynamic>.from(targets[i]));
                      if (runningTarget.status == 'progress') {
                        runningTarget.achievedDistance += track.distance;
                        if (runningTarget.achievedDistance >=
                            runningTarget.targetDistance) {
                          runningTarget.status = 'done';
                        }
                      }
                      targets[i] = runningTarget.toJson();
                    }
                  }
                }
                userFireStore.updateData({
                  'running': FieldValue.arrayUnion([track.toJson()]),
                  'targets': targets
                });
                navigator.pop();
                navigator.pop();
                Fluttertoast.showToast(msg: "Running track saved successfully");
              });
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

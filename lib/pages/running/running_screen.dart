import 'dart:async';

import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({Key? key}) : super(key: key);

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Position? currentPosition;
  bool isRunning = false;
  String runningState = "none";
  late int _time;
  double _distance = 0;
  double _speed = 0;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    setInitialLocation();
  }

  void setInitialLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
    });
  }

  void _onMapCreated(GoogleMapController mapController) {
    _controller.complete(mapController);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Running"),
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                SizedBox(
                  height: 420,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                        zoom: 15,
                        target: LatLng(currentPosition!.latitude,
                            currentPosition!.longitude)),
                    onMapCreated: _onMapCreated,
                  ),
                ),
                Flexible(
                    child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: [
                              const Text("SPEED (KM/H)",
                                  style: TextStyle(fontSize: 15)),
                              Text(_speed.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 30))
                            ],
                          ),
                          Column(
                            children: [
                              const Text("TIME",
                                  style: TextStyle(fontSize: 15)),
                              StreamBuilder<int>(
                                stream: _stopWatchTimer.rawTime,
                                initialData: _stopWatchTimer.rawTime.value,
                                builder: (context, snap) {
                                  _time = snap.data!;
                                  final displayTime =
                                      StopWatchTimer.getDisplayTime(_time,
                                          milliSecond: false);
                                  return Text(
                                    displayTime,
                                    style: const TextStyle(fontSize: 30),
                                  );
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text("DISTANCE (KM)",
                                  style: TextStyle(fontSize: 15)),
                              Text(_distance.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 30))
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
                          runningState == "stop"
                              ? TextButton(
                                  onPressed: () {
                                    _stopWatchTimer.onResetTimer();
                                    setState(() {
                                      runningState = "none";
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      fixedSize: const Size(110, 30)),
                                  child: const Text("RESTART"))
                              : const SizedBox(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(95, 95),
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                runningState != "run"
                                    ? _stopWatchTimer.onStartTimer()
                                    : _stopWatchTimer.onStopTimer();
                                setState(() {
                                  if (runningState != "run") {
                                    runningState = "run";
                                  } else {
                                    runningState = "stop";
                                  }
                                });
                              },
                              child: runningState == "none"
                                  ? const Text("START",
                                      style: TextStyle(fontSize: 15))
                                  : runningState == "run"
                                      ? const Text("STOP",
                                          style: TextStyle(fontSize: 15))
                                      : const Text("RESUME",
                                          style: TextStyle(fontSize: 15))),
                          runningState == "stop"
                              ? TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
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


// Container(
//             width: double.infinity,
//             margin: EdgeInsets.fromLTRB(10, 0, 10, 40),
//             height: 140,
//             padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       children: [
//                         Text("SPEED (KM/H)",
//                             style: GoogleFonts.montserrat(
//                                 fontSize: 10, fontWeight: FontWeight.w300)),
//                         Text(_speed.toStringAsFixed(2),
//                             style: GoogleFonts.montserrat(
//                                 fontSize: 30, fontWeight: FontWeight.w300))
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         Text("TIME",
//                             style: GoogleFonts.montserrat(
//                                 fontSize: 10, fontWeight: FontWeight.w300)),
//                         StreamBuilder<int>(
//                           stream: _stopWatchTimer.rawTime,
//                           initialData: 0,
//                           builder: (context, snap) {
//                             _time = snap.data;
//                             _displayTime =
//                                 StopWatchTimer.getDisplayTimeHours(_time) +
//                                     ":" +
//                                     StopWatchTimer.getDisplayTimeMinute(_time) +
//                                     ":" +
//                                     StopWatchTimer.getDisplayTimeSecond(_time);
//                             return Text(_displayTime,
//                                 style: GoogleFonts.montserrat(
//                                     fontSize: 30, fontWeight: FontWeight.w300));
//                           },
//                         )
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         Text("DISTANCE (KM)",
//                             style: GoogleFonts.montserrat(
//                                 fontSize: 10, fontWeight: FontWeight.w300)),
//                         Text((_dist / 1000).toStringAsFixed(2),
//                             style: GoogleFonts.montserrat(
//                                 fontSize: 30, fontWeight: FontWeight.w300))
//                       ],
//                     )
//                   ],
//                 ),
//                 Divider(),
//                 IconButton(
//                   icon: Icon(
//                     Icons.stop_circle_outlined,
//                     size: 50,
//                     color: Colors.redAccent,
//                   ),
//                   padding: EdgeInsets.all(0),
//                   onPressed: () async {
//                     Entry en = Entry(
//                         date: DateFormat.yMMMMd('en_US').format(DateTime.now()),
//                         duration: _displayTime,
//                         speed:
//                             _speedCounter == 0 ? 0 : _avgSpeed / _speedCounter,
//                         distance: _dist);
//                     Navigator.pop(context, en);
//                   },
//                 )
//               ],
//             ),
//           )

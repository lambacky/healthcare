import 'dart:async';

import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({Key? key}) : super(key: key);

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // late GoogleMapController _controller;
  late Position _currentPosition;
  // void getCurrentLocation() async {
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() {
  //       currentPosition = position;
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void _onMapCreated(GoogleMapController mapController) async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // _controller = mapController;
    _controller.complete(mapController);
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 16)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Running"),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition:
            const CameraPosition(target: LatLng(0, 0), zoom: 11),
        onMapCreated: _onMapCreated,
      ),
    );
  }
}

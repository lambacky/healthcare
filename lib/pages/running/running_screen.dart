// import 'dart:async';

// import "package:flutter/material.dart";
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class RunningScreen extends StatefulWidget {
//   const RunningScreen({Key? key}) : super(key: key);

//   @override
//   State<RunningScreen> createState() => _RunningScreenState();
// }

// class _RunningScreenState extends State<RunningScreen> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
//   static const LatLng destination = LatLng(37.33429383, -122.06600055);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Running"),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: const CameraPosition(
//           target: sourceLocation,
//           zoom: 13.5,
//         ),
//         markers: {
//           const Marker(
//             markerId: MarkerId("source"),
//             position: sourceLocation,
//           ),
//           const Marker(
//             markerId: MarkerId("destination"),
//             position: destination,
//           ),
//         },
//         onMapCreated: (mapController) {
//           _controller.complete(mapController);
//         },
//       ),
//     );
//   }
// }

import "package:flutter/material.dart";

class RunningScreen extends StatelessWidget {
  const RunningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Run Tracking"),
        ),
        body: const Center(
          child: Text("Running"),
        ));
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthcare/components/track_list_tile.dart';
import 'package:healthcare/pages/running/tracking_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RunningMenuScreen extends StatefulWidget {
  const RunningMenuScreen({Key? key}) : super(key: key);

  @override
  State<RunningMenuScreen> createState() => _RunningMenuScreenState();
}

class _RunningMenuScreenState extends State<RunningMenuScreen> {
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TrackingScreen()),
    ).then((value) => setState(() {}));
  }

  deleteTrack(dynamic track) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this track ?'),
        content: const Text('The track will be removed permanently'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .update({
                "running": FieldValue.arrayRemove([track])
              });
              setState(() {});
            },
            child: const Text('Yes'),
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
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data!;
            if (!user.data()!.containsKey("running")) {
              return const Center(
                  child: Text("There are currently no records"));
            }
            var tracks = user['running'];
            tracks = List.from(tracks.reversed);
            return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                return Slidable(
                    endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                              onPressed: (context) =>
                                  deleteTrack(tracks[index]),
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: "Delete")
                        ]),
                    child: TrackListTile(track: tracks[index]));
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await checkLocationPermission();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.red,
        notchMargin: 4,
        shape: CircularNotchedRectangle(),
        height: 45,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

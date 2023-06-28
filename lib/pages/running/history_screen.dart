import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/track_card.dart';
import 'package:healthcare/providers/user_firestore.dart';
import 'package:provider/provider.dart';

import '../../models/track_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _storageReference = FirebaseStorage.instance.ref();

  deleteTrack(Track track) {
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
              context.read<UserFireStore>().updateData({
                'running': FieldValue.arrayRemove([track.toJson()])
              });
              await _storageReference.child(track.routeImagePath).delete();
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
        title: const Text("Running History"),
      ),
      body: Consumer<UserFireStore>(builder: (context, userFireStore, child) {
        if (userFireStore.userData.isNotEmpty) {
          if (userFireStore.userData.containsKey('running') &&
              userFireStore.userData['running'].length > 0) {
            List<dynamic> tracks = userFireStore.userData['running'];
            return ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                Track track =
                    Track.fromJson(Map<String, dynamic>.from(tracks[index]));
                return TrackCard(track: track, deleteAction: deleteTrack);
              },
            );
          }
        }
        return const Center(child: Text("There are currently no records"));
      }),
    );
  }
}

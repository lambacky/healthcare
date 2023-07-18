import 'package:flutter/material.dart';
import 'package:healthcare/components/track_card.dart';
import 'package:healthcare/view-models/track_view_model.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  deleteTrack(int index) {
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
            onPressed: () {
              Navigator.pop(context);
              context.read<TrackViewModel>().deleteTrack(index);
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
      body: Consumer<TrackViewModel>(builder: (context, trackViewModel, child) {
        if (trackViewModel.tracks.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: trackViewModel.tracks.length,
            itemBuilder: (context, index) {
              return TrackCard(index: index, deleteAction: deleteTrack);
            },
          );
        }
        return const Center(child: Text("There are currently no records"));
      }),
    );
  }
}
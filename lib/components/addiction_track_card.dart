import 'package:flutter/material.dart';
import 'package:healthcare/view-models/addiction_track_view_model.dart';
import 'package:provider/provider.dart';

class AddictionTrackCard extends StatelessWidget {
  final Function(int, BuildContext) clickAction;
  final int index;
  const AddictionTrackCard(
      {Key? key, required this.clickAction, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addictionTracker =
        context.read<AddictionTrackViewModel>().addictionTracks[index];
    final days = DateTime.now().difference(addictionTracker.startDate).inDays;
    return InkWell(
      onTap: () {
        clickAction(index, context);
      },
      child: Container(
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(addictionTracker.type,
                  style: const TextStyle(fontSize: 18)),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: Text(
                'Free for $days ${days == 1 ? 'day' : 'days'}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

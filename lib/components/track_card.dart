import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../view-models/track_view_model.dart';

class TrackCard extends StatelessWidget {
  final Function(int, BuildContext) deleteAction;
  final int index;
  const TrackCard({Key? key, required this.index, required this.deleteAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final track = context.read<TrackViewModel>().tracks[index];
    final steps = track.steps.toString();
    final speed = track.speed.toStringAsFixed(2);
    final distance = track.distance.toStringAsFixed(2);
    final time = track.time;
    final routeImageURL = track.routeImageURL;
    final date = DateFormat.yMMMd().add_jm().format(track.date).toString();
    final place = track.place;
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ArticlePage(
        //               article: article,
        //             )));
      },
      child: Container(
        margin: const EdgeInsets.all(12.0),
        padding: const EdgeInsets.all(8.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 95, 94, 94))),
                    const SizedBox(height: 5),
                    Text(place,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 95, 94, 94))),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    deleteAction(index, context);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            CachedNetworkImage(
              imageUrl: routeImageURL,
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 205.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                );
              },
              placeholder: (context, url) => Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Distance",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('$distance km', style: const TextStyle(fontSize: 18))
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Speed",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('$speed km/h', style: const TextStyle(fontSize: 18))
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Time",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(time, style: const TextStyle(fontSize: 18))
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Steps",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(steps, style: const TextStyle(fontSize: 18))
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

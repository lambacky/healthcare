import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackListTile extends StatelessWidget {
  final dynamic track;
  const TrackListTile({Key? key, this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = track['steps'].toString();
    final speed = track['speed'];
    final distance = track['distance'];
    final time = track['time'];
    final date =
        DateFormat.yMMMd().add_jm().format(track['date'].toDate()).toString();
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
              Text(date,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 95, 94, 94))),
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
          )
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       height: 200.0,
          //       width: double.infinity,
          //       decoration: BoxDecoration(
          //         //let's add the height

          //         image: DecorationImage(
          //             image: NetworkImage(article.urlToImage!),
          //             fit: BoxFit.cover),
          //         borderRadius: BorderRadius.circular(12.0),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 8.0,
          //     ),
          //     Container(
          //       padding: const EdgeInsets.all(6.0),
          //       decoration: BoxDecoration(
          //         color: Colors.red,
          //         borderRadius: BorderRadius.circular(30.0),
          //       ),
          //       child: Text(
          //         article.source.name,
          //         style: const TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 8.0,
          //     ),
          //     Text(
          //       article.title,
          //       style: const TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 16.0,
          //       ),
          //     )
          //   ],
          // ),
          ),
    );
  }
}

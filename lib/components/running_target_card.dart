import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../view-models/target_view_model.dart';

class RunningTargetCard extends StatelessWidget {
  final int index;

  final Function(int, BuildContext) deleteAction;
  const RunningTargetCard(
      {Key? key, required this.index, required this.deleteAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final target = context.read<TargetViewModel>().targets[index];
    final startDate = DateFormat('dd/MM/yyyy').format(target.startDate);
    final endDate = DateFormat('dd/MM/yyyy').format(target.endDate);
    final targetDistance = target.targetDistance;
    final achievedDistance = target.achievedDistance;
    final status = target.status;
    return Container(
        margin: const EdgeInsets.all(12.0),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 15),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    '$startDate - $endDate',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    status == 'finished'
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.edit,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                    const SizedBox(width: 20),
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
              ],
            ),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(width: 25),
              status == "progress"
                  ? CircularPercentIndicator(
                      animation: true,
                      animationDuration: 1000,
                      radius: 40,
                      lineWidth: 10,
                      circularStrokeCap: CircularStrokeCap.round,
                      percent: achievedDistance / targetDistance,
                      progressColor: Colors.green,
                      center: Text(
                        (achievedDistance / targetDistance * 100)
                            .toStringAsFixed(0),
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ))
                  : achievedDistance >= targetDistance
                      ? const Icon(Icons.check_circle,
                          color: Colors.green, size: 50)
                      : Text(
                          '${(achievedDistance / targetDistance * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
              const SizedBox(width: 70),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Target: ${targetDistance.toString()} km',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: achievedDistance < targetDistance ? 6 : 0),
                achievedDistance < targetDistance
                    ? Text(
                        'Achieved: ${achievedDistance.toStringAsFixed(1)} km',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold))
                    : const SizedBox(),
              ])
            ])
          ],
        ));
  }
}

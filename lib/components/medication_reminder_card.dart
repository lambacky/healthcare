import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view-models/medication_reminder_view_model.dart';

class MedicationReminderCard extends StatelessWidget {
  final Function(int, BuildContext) deleteAction;
  final Function(int, BuildContext) editAction;
  final int index;
  const MedicationReminderCard(
      {Key? key,
      required this.deleteAction,
      required this.editAction,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reminder =
        context.read<MedicationReminderViewModel>().reminders[index];
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
                  reminder.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      editAction(index, context);
                    },
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
            Icon(reminder.medicationType.icon,
                size: 55, color: Colors.blueGrey),
            const SizedBox(width: 70),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  '${reminder.doses} ${reminder.medicationType.unit} each time',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${reminder.times} times a day',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              SizedBox(
                width: 170,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: List.generate(
                      reminder.schedule.length,
                      (index) => Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                                reminder.schedule[index].format(context),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )),
                ),
              ),
            ])
          ])
        ],
      ),
    );
  }
}

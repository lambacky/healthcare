import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/models/medication_type.dart';
import 'package:healthcare/view-models/medication_reminder_view_model.dart';
import 'package:provider/provider.dart';

class ReminderDescriptionScreen extends StatefulWidget {
  const ReminderDescriptionScreen({Key? key}) : super(key: key);

  @override
  State<ReminderDescriptionScreen> createState() =>
      _ReminderDescriptionScreenState();
}

class _ReminderDescriptionScreenState extends State<ReminderDescriptionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildMedicationTypeCard(MedicationType type, int index) {
    final reminderViewModel = context.watch<MedicationReminderViewModel>();
    return GestureDetector(
        onTap: () {
          context.read<MedicationReminderViewModel>().updateType(type);
        },
        child: Container(
            // margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: reminderViewModel.reminder.medicationType == type
                  ? Colors.red
                  : Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Icon(type.icon,
                    color: reminderViewModel.reminder.medicationType == type
                        ? Colors.white
                        : Colors.red,
                    size: 40),
                const SizedBox(height: 10),
                Text(
                  type.name,
                  style: TextStyle(
                      color: reminderViewModel.reminder.medicationType == type
                          ? Colors.white
                          : const Color.fromARGB(255, 91, 91, 91),
                      fontWeight: FontWeight.bold),
                )
              ],
            )));
  }

  Widget _buildScheduleTimeCard(TimeOfDay scheduleTime, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 224, 224),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _openTimePicker(scheduleTime);
            },
            child: Text(
              scheduleTime.format(context),
              style: const TextStyle(
                  color: Color.fromARGB(255, 111, 111, 111),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
              onTap: () {
                context
                    .read<MedicationReminderViewModel>()
                    .deleteScheduleTime(scheduleTime);
              },
              child: const Icon(Icons.cancel,
                  color: Color.fromARGB(255, 111, 111, 111)))
        ],
      ),
    );
  }

  void _openTimePicker(TimeOfDay? scheduleTime) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          DateTime time = DateTime.now();
          if (scheduleTime != null) {
            time = DateTime(time.year, time.month, time.day, scheduleTime.hour,
                scheduleTime.minute);
          }
          return Container(
            height: 255,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    context
                        .read<MedicationReminderViewModel>()
                        .addScheduleTime(time, scheduleTime);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 126, 126, 126),
                        decoration: TextDecoration.none),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: CupertinoDatePicker(
                    initialDateTime: time,
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newTime) {
                      time = newTime;
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showMyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                Center(child: Text('Saving reminder...')),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveReminder() {
    _showMyDialog();
    context.read<MedicationReminderViewModel>().updateReminder();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final reminderViewModel = context.watch<MedicationReminderViewModel>();
    return Scaffold(
        appBar: AppBar(
            centerTitle: true, title: const Text('Reminder Description')),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Medication name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blueGrey)),
                  TextField(
                    controller: TextEditingController(
                        text: reminderViewModel.reminder.name),
                    onChanged: (value) {
                      reminderViewModel.updateName(value.toString());
                    },
                  ),
                  const SizedBox(height: 50),
                  Row(children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Doses per time",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blueGrey)),
                          Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  controller: TextEditingController(
                                      text: reminderViewModel.reminder.doses),
                                  onChanged: (value) {
                                    reminderViewModel
                                        .updateDoses(value.toString());
                                  },
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                  reminderViewModel
                                      .reminder.medicationType.unit,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 91, 91, 91)))
                            ],
                          )
                        ]),
                    const SizedBox(width: 60),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Times per day",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blueGrey)),
                          SizedBox(
                            width: 60,
                            child: TextField(
                              controller: TextEditingController(
                                  text: reminderViewModel.reminder.times),
                              onChanged: (value) {
                                reminderViewModel.updateTimes(value.toString());
                              },
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'))
                              ],
                            ),
                          )
                        ]),
                  ]),
                  const SizedBox(height: 30),
                  const Text("Type",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blueGrey)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Constants.medicationTypes.length,
                      itemBuilder: (context, index) => _buildMedicationTypeCard(
                          Constants.medicationTypes[index], index),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text("Schedule",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blueGrey)),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          _openTimePicker(null);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                              color: Colors.blueGrey, shape: BoxShape.circle),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: reminderViewModel.reminder.schedule.length,
                      itemBuilder: (context, index) => _buildScheduleTimeCard(
                          reminderViewModel.reminder.schedule[index], index),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: reminderViewModel.isEnabled
                          ? () {
                              _saveReminder();
                            }
                          : null,
                      child: const Text(
                        'Add Reminder',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}

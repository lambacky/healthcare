import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcare/models/medication_reminder.dart';
import 'package:healthcare/models/medication_type.dart';
import 'package:provider/provider.dart';

import '../../providers/user_firestore.dart';
import '../../services/notification_service.dart';

class ReminderDescriptionScreen extends StatefulWidget {
  final MedicationReminder? reminder;
  const ReminderDescriptionScreen({Key? key, this.reminder}) : super(key: key);

  @override
  State<ReminderDescriptionScreen> createState() =>
      _ReminderDescriptionScreenState();
}

class _ReminderDescriptionScreenState extends State<ReminderDescriptionScreen> {
  final _nameController = TextEditingController();
  final _dosesController = TextEditingController();
  final _timesController = TextEditingController();
  List<TimeOfDay> _schedule = [];
  int _selectedTypeIndex = 0;
  bool _isEnabled = false;
  final List<MedicationType> types = <MedicationType>[
    MedicationType(
        name: 'Tablet', icon: FontAwesomeIcons.tablets, unit: 'pills'),
    MedicationType(
        name: 'Capsule', icon: FontAwesomeIcons.capsules, unit: 'pills'),
    MedicationType(name: 'Syringe', icon: FontAwesomeIcons.syringe, unit: 'ml'),
    MedicationType(
        name: 'Drop', icon: FontAwesomeIcons.eyeDropper, unit: 'drops'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      _nameController.text = widget.reminder!.name;
      _dosesController.text = widget.reminder!.doses;
      _timesController.text = widget.reminder!.times;
      _schedule = widget.reminder!.schedule;
      for (int i = 0; i < types.length; i++) {
        if (types[i].name == widget.reminder!.medicationType.name) {
          _selectedTypeIndex = i;
          break;
        }
      }

      _isEnabled = true;
    }
    _nameController.addListener(_updateButtonState);
    _dosesController.addListener(_updateButtonState);
    _timesController.addListener(_updateButtonState);
    // NotificationService().cancelAllNotifications();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosesController.dispose();
    _timesController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isEnabled = _nameController.text.isNotEmpty &&
          _dosesController.text.isNotEmpty &&
          _timesController.text.isNotEmpty &&
          _schedule.isNotEmpty;
    });
  }

  Widget _buildMedicationTypeCard(MedicationType type, int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedTypeIndex = index;
          });
        },
        child: Container(
            // margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: _selectedTypeIndex == index ? Colors.red : Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Icon(type.icon,
                    color:
                        _selectedTypeIndex == index ? Colors.white : Colors.red,
                    size: 40),
                const SizedBox(height: 10),
                Text(
                  type.name,
                  style: TextStyle(
                      color: _selectedTypeIndex == index
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
                setState(() {
                  _schedule.remove(scheduleTime);
                });
                _updateButtonState();
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
                    setState(() {
                      TimeOfDay newTime = TimeOfDay.fromDateTime(time);
                      if (scheduleTime != null && scheduleTime != newTime) {
                        _schedule.remove(scheduleTime);
                      }
                      _addScheduleTime(newTime);
                    });
                    _updateButtonState();
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

  void _addScheduleTime(TimeOfDay scheduleTime) {
    int insertIndex = _schedule.length;
    for (int i = 0; i < _schedule.length; i++) {
      int compare = _schedule[i].toString().compareTo(scheduleTime.toString());
      if (compare == 0) {
        return;
      } else if (compare > 0) {
        insertIndex = i;
        break;
      }
    }
    _schedule.insert(insertIndex, scheduleTime);
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

  void _saveReminder() async {
    _showMyDialog();
    List<int> ids = [];
    for (var scheduleTime in _schedule) {
      int id = Random().nextInt(10000);
      ids.add(id);
      await NotificationService()
          .scheduleNotification(id: id, scheduleTime: scheduleTime);
    }
    MedicationReminder reminder = MedicationReminder(
        name: _nameController.text,
        doses: _dosesController.text,
        times: _timesController.text,
        medicationType: types[_selectedTypeIndex],
        schedule: _schedule,
        notificationIds: ids);
    if (widget.reminder == null) {
      context.read<UserFireStore>().updateData({
        'medicine': FieldValue.arrayUnion([reminder.toJson()])
      });
    } else {
      for (var id in widget.reminder!.notificationIds) {
        await NotificationService().cancelNotification(id);
      }
    }
    Navigator.pop(context);
    Navigator.pop(context, reminder.toJson());
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: _nameController,
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
                                  controller: _dosesController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(types[_selectedTypeIndex].unit,
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
                              controller: _timesController,
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
                      itemCount: types.length,
                      itemBuilder: (context, index) =>
                          _buildMedicationTypeCard(types[index], index),
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
                      itemCount: _schedule.length,
                      itemBuilder: (context, index) =>
                          _buildScheduleTimeCard(_schedule[index], index),
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
                      onPressed: _isEnabled ? _saveReminder : null,
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

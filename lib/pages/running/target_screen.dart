import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:healthcare/components/running_target_card.dart';
import 'package:healthcare/models/running_target.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/user_firestore.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({Key? key}) : super(key: key);

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  double _distance = 0;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<RunningTarget> _progress = [];
  List<RunningTarget> _done = [];
  @override
  void initState() {
    super.initState();
    _startDateController.text = DateFormat('dd/MM/yyyy').format(startDate);
    _endDateController.text = DateFormat('dd/MM/yyyy').format(endDate);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void addTarget(BuildContext context) {
    RunningTarget runningTarget = RunningTarget(
        targetDistance: _distance,
        achievedDistance: 0.0,
        startDate: startDate,
        endDate: endDate,
        status: 'progress');

    context.read<UserFireStore>().updateData({
      'targets': FieldValue.arrayUnion([runningTarget.toJson()])
    });
    Navigator.pop(context);
  }

  void deleteTarget(RunningTarget runningTarget) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this target ?'),
        content: const Text('The target will be removed permanently'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UserFireStore>().updateData({
                'targets': FieldValue.arrayRemove([runningTarget.toJson()])
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void openDatePicker(DateTime date, String type) {
    showDatePicker(
            context: context,
            initialDate: date,
            firstDate: date,
            lastDate: DateTime(2100))
        .then((value) {
      setState(() {
        if (value != null && value != date) {
          setState(() {
            if (type == 'start') {
              startDate = value;
              _startDateController.text =
                  DateFormat('dd/MM/yyyy').format(startDate);
              if (startDate.compareTo(endDate) > 0) {
                endDate = startDate;
                _endDateController.text =
                    DateFormat('dd/MM/yyyy').format(endDate);
              }
            } else {
              endDate = value;
              _endDateController.text =
                  DateFormat('dd/MM/yyyy').format(endDate);
            }
          });
        }
      });
    });
  }

  void openTargetDialog() {
    final distanceController = TextEditingController();
    bool isEnabled = false;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          void updateButtonState() {
            setState(() {
              isEnabled = distanceController.text.isNotEmpty &&
                  double.parse(distanceController.text) != 0;
            });
          }

          distanceController.addListener(updateButtonState);

          return Dialog(
            child: Container(
              height: 280,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text("Target distance:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: distanceController,
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,1}'))
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("km",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Start date",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _startDateController,
                                  onTap: () {
                                    openDatePicker(startDate, 'start');
                                  },
                                ),
                              )
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("End date",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _endDateController,
                                  onTap: () {
                                    openDatePicker(endDate, 'end');
                                  },
                                ),
                              )
                            ])
                      ]),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: const Size(180, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: !isEnabled
                          ? null
                          : () {
                              _distance = double.parse(distanceController.text);
                              addTarget(context);
                            },
                      child: const Text(
                        'Save new target',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Targets"),
      ),
      body: Consumer<UserFireStore>(builder: (context, userFireStore, child) {
        if (userFireStore.userData.isNotEmpty) {
          if (userFireStore.userData.containsKey('targets') &&
              userFireStore.userData['targets'].length > 0) {
            List<dynamic> targets = userFireStore.userData['targets'];
            List<RunningTarget> progress = [];
            List<RunningTarget> done = [];
            for (var target in targets) {
              RunningTarget runningTarget =
                  RunningTarget.fromJson(Map<String, dynamic>.from(target));
              if (runningTarget.status == 'progress') {
                progress.add(runningTarget);
              } else {
                done.add(runningTarget);
              }
            }
            _progress = progress;
            _done = done;
          }
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(children: [
                const SizedBox(width: 12),
                const Text('In Progress',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    openTargetDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: Colors.blueGrey, shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                )
              ]),
              _progress.isEmpty
                  ? Container(
                      margin: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                          child: Text(
                              "There are currently no targets in progress",
                              style: TextStyle(color: Colors.grey))))
                  : ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      reverse: true,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _progress.length,
                      itemBuilder: (context, index) {
                        return RunningTargetCard(
                            runningTarget: _progress[index],
                            deleteAction: deleteTarget);
                      },
                    ),
              const SizedBox(height: 20),
              Row(children: [
                const SizedBox(width: 20),
                const Text('Done',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: Colors.blueGrey, shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                )
              ]),
              _done.isEmpty
                  ? Container(
                      margin: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                          child: Text("There are currently no targets done",
                              style: TextStyle(color: Colors.grey))))
                  : ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      reverse: true,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _done.length,
                      itemBuilder: (context, index) {
                        return RunningTargetCard(
                            runningTarget: _done[index],
                            deleteAction: deleteTarget);
                      },
                    ),
            ],
          ),
        );
      }),
    );
  }
}

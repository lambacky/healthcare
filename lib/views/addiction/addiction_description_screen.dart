import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare/components/submit_button.dart';
import 'package:healthcare/view-models/addiction_track_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddictionDescriptionScreen extends StatelessWidget {
  const AddictionDescriptionScreen({Key? key}) : super(key: key);

  void _restartAddictionTrack(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Restart this addiction tracker ?'),
        content: const Text('The tracker will be restarted to today'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              bool success = await context
                  .read<AddictionTrackViewModel>()
                  .restartAddictionTrack();
              if (success) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "Addiction tracker restarted successful");
              } else {
                Fluttertoast.showToast(msg: "Error. Please try again");
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _editAddictionTrack(BuildContext context) {
    context.read<AddictionTrackViewModel>().getEditAddictionTypes();
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          final addictionTrackViewModel =
              context.watch<AddictionTrackViewModel>();
          return Dialog(
            child: Container(
              height: 260,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Addiction Type",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField(
                    items: addictionTrackViewModel.editAddictionTypes
                        .map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      addictionTrackViewModel.updateType(value.toString());
                    },
                    value: addictionTrackViewModel.addictionTracker.type,
                  ),
                  const SizedBox(height: 20),
                  const Text("Start Date",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(
                            addictionTrackViewModel
                                .addictionTracker.startDate)),
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: addictionTrackViewModel
                                  .addictionTracker.startDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null &&
                            value !=
                                addictionTrackViewModel
                                    .addictionTracker.startDate) {
                          addictionTrackViewModel.updateStartDate(value);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                      alignment: Alignment.center,
                      child: SubmitButton(
                          text: 'Save new tracker',
                          onPressed: addictionTrackViewModel.isEnabled
                              ? () async {
                                  bool success = await addictionTrackViewModel
                                      .updateAddictionTracker();
                                  if (success) {
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                        msg:
                                            "Addiction tracker saved successful");
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Error. Please try again");
                                  }
                                }
                              : null)),
                ],
              ),
            ),
          );
        });
  }

  void _deleteAddictionTrack(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this addiction tracker ?'),
        content: const Text('The tracker will be removed permanently'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              bool success = await context
                  .read<AddictionTrackViewModel>()
                  .deleteAddictionTracker();
              if (success) {
                Navigator.pop(context);
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "Addiction tracker deleted successful");
              } else {
                Fluttertoast.showToast(msg: "Error. Please try again");
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _buildMileStoneCard(int milestone, int index, BuildContext context) {
    final currentmilestone =
        context.read<AddictionTrackViewModel>().currentMilestone;
    return Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 50, 8),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: currentmilestone == milestone
                      ? Colors.lightGreen
                      : Colors.orange,
                  shape: BoxShape.circle),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(' $milestone ${milestone == 1 ? 'day' : 'days'}')
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final addictionTrackViewModel = context.watch<AddictionTrackViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(addictionTrackViewModel.currentAddictionTracker.type),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Center(
            child: Column(children: [
              Text(
                'You have been ${addictionTrackViewModel.currentAddictionTracker.type} free for',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 168, 162),
                      width: 10,
                    )),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          addictionTrackViewModel.days.toString(),
                          style: const TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          addictionTrackViewModel.days == 1 ? 'day' : 'days',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ]),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Starting from',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                  DateFormat.yMMMd().add_jm().format(addictionTrackViewModel
                      .currentAddictionTracker.startDate),
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Current Milestone',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 7),
              _buildMileStoneCard(addictionTrackViewModel.currentMilestone,
                  addictionTrackViewModel.lastMileStones.length, context),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Last MileStones',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 7),
              Container(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: addictionTrackViewModel.lastMileStones.length,
                    itemBuilder: (context, index) {
                      return _buildMileStoneCard(
                          addictionTrackViewModel.lastMileStones[index],
                          index,
                          context);
                    }),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        _restartAddictionTrack(context);
                      },
                      child: const Column(children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(height: 5),
                        Text('Restart',
                            style: TextStyle(color: Colors.blueGrey))
                      ])),
                  GestureDetector(
                      onTap: () {
                        _editAddictionTrack(context);
                      },
                      child: const Column(children: [
                        Icon(
                          Icons.edit,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(height: 5),
                        Text('Edit', style: TextStyle(color: Colors.blueGrey))
                      ])),
                  GestureDetector(
                      onTap: () {
                        _deleteAddictionTrack(context);
                      },
                      child: const Column(children: [
                        Icon(Icons.delete, color: Colors.blueGrey),
                        SizedBox(height: 5),
                        Text('Delete', style: TextStyle(color: Colors.blueGrey))
                      ])),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}

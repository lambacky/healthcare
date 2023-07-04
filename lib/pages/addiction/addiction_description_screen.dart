import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/models/addiction_tracker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/user_firestore.dart';

class AddictionDescriptionScreen extends StatefulWidget {
  final List<dynamic> addictionTracks;
  final int index;
  final AddictionTracker addictionTracker;
  const AddictionDescriptionScreen(
      {Key? key,
      required this.addictionTracker,
      required this.addictionTracks,
      required this.index})
      : super(key: key);

  @override
  State<AddictionDescriptionScreen> createState() =>
      _AddictionDescriptionScreenState();
}

class _AddictionDescriptionScreenState
    extends State<AddictionDescriptionScreen> {
  int _days = 0;
  DateTime now = DateTime.now();
  String _startDateString = '';
  late String _addictionType;
  late DateTime _startDate;
  int _currentIndex = 0;
  List<dynamic> addictionTracks = [];
  List<String> addictionTypes = [];
  final _startDateController = TextEditingController();
  @override
  void initState() {
    super.initState();

    addictionTracks = widget.addictionTracks;
    upDateValue(
        widget.addictionTracker.type, widget.addictionTracker.startDate);
    getCurrentMileStone();
  }

  void getCurrentMileStone() {
    for (int i = 0; i < Constants.mileStones.length; i++) {
      if (_days < Constants.mileStones[i]) {
        _currentIndex = i;
        break;
      }
    }
  }

  void updateList(String type, DateTime startDate, BuildContext context) {
    AddictionTracker addictionTracker =
        AddictionTracker(type: type, startDate: startDate);
    addictionTracks[widget.index] = addictionTracker.toJson();
    context.read<UserFireStore>().updateData({'addiction': addictionTracks});
    Navigator.pop(context);
    setState(() {
      upDateValue(type, startDate);
      getCurrentMileStone();
    });
  }

  void upDateValue(String type, DateTime startDate) {
    _addictionType = type;
    _startDate = startDate;
    _days = now.difference(_startDate).inDays;
    _startDateString = DateFormat.yMMMd().add_jm().format(_startDate);
    addictionTypes = List.from(Constants.addictionTypes);
    for (int i = 0; i < addictionTracks.length; i++) {
      if (i != widget.index) {
        addictionTypes.remove(addictionTracks[i]['type']);
      }
    }
  }

  void restartAddictionTrack() {
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
            onPressed: () {
              updateList(_addictionType, DateTime.now(), context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void openDatePicker() {
    showDatePicker(
            context: context,
            initialDate: _startDate,
            firstDate: DateTime(2000),
            lastDate: _startDate)
        .then((value) {
      setState(() {
        if (value != null && value != _startDate) {
          setState(() {
            _startDate = value;
            _startDateController.text =
                DateFormat('dd/MM/yyyy').format(_startDate);
          });
        }
      });
    });
  }

  void editAddictionTrack() {
    _startDateController.text = DateFormat('dd/MM/yyyy').format(_startDate);
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
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
                    items: addictionTypes.map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _addictionType = value.toString();
                      });
                    },
                    value: _addictionType,
                  ),
                  const SizedBox(height: 20),
                  const Text("Start Date",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _startDateController,
                    onTap: openDatePicker,
                  ),
                  const SizedBox(height: 20),
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
                      onPressed: () {
                        updateList(_addictionType, _startDate, context);
                      },
                      child: const Text(
                        'Save new tracker',
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
  }

  void deleteAddictionTrack() {
    AddictionTracker addictionTracker =
        AddictionTracker(type: _addictionType, startDate: _startDate);
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
            onPressed: () {
              Navigator.pop(context);
              context.read<UserFireStore>().updateData({
                'addiction': FieldValue.arrayRemove([addictionTracker.toJson()])
              });
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _buildMileStoneCard(int index) {
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
                  color: _currentIndex == index
                      ? Colors.lightGreen
                      : Colors.orange,
                  shape: BoxShape.circle),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
                '${Constants.mileStones[index].toString()} ${Constants.mileStones[index] == 1 ? 'day' : 'days'}')
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_addictionType),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Center(
            child: Column(children: [
              Text(
                'You have been $_addictionType free for',
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
                          _days.toString(),
                          style: const TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _days == 1 ? 'day' : 'days',
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
              Text(_startDateString, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Current Milestone',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 7),
              _buildMileStoneCard(_currentIndex),
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
                    itemCount: Constants.mileStones.length,
                    itemBuilder: (context, index) {
                      if (index < _currentIndex) {
                        return _buildMileStoneCard(index);
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: restartAddictionTrack,
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
                      onTap: editAddictionTrack,
                      child: const Column(children: [
                        Icon(
                          Icons.edit,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(height: 5),
                        Text('Edit', style: TextStyle(color: Colors.blueGrey))
                      ])),
                  GestureDetector(
                      onTap: deleteAddictionTrack,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/addiction_tracker.dart';
import 'package:healthcare/pages/addiction/addiction_description_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/addiction_track_card.dart';
import '../../constants/constants.dart';
import '../../providers/user_firestore.dart';

class AddictionListScreen extends StatefulWidget {
  const AddictionListScreen({Key? key}) : super(key: key);

  @override
  State<AddictionListScreen> createState() => _AddictionListScreenState();
}

class _AddictionListScreenState extends State<AddictionListScreen> {
  List<dynamic> addictionTracks = [];
  final _startDateController = TextEditingController();
  DateTime _startDate = DateTime.now();
  String _addictionType = 'Alcohol';
  List<String> _addictionTypes = [];

  @override
  void initState() {
    super.initState();
    _startDateController.text = DateFormat('dd/MM/yyyy').format(_startDate);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    super.dispose();
  }

  void openAddictionScreen(AddictionTracker addictionTracker, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddictionDescriptionScreen(
              addictionTracker: addictionTracker,
              addictionTracks: addictionTracks,
              index: index)),
    );
  }

  void addAddictionTrack(BuildContext context) {
    AddictionTracker addictionTracker =
        AddictionTracker(type: _addictionType, startDate: _startDate);
    context.read<UserFireStore>().updateData({
      'addiction': FieldValue.arrayUnion([addictionTracker.toJson()])
    });
    Navigator.pop(context);
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

  void openAddictionTrackerDialog() {
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
                    items: _addictionTypes.map((String type) {
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
                        addAddictionTrack(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Addiction Tracker"),
      ),
      body: Consumer<UserFireStore>(builder: (context, userFireStore, child) {
        if (userFireStore.userData.isNotEmpty) {
          if (userFireStore.userData.containsKey('addiction') &&
              userFireStore.userData['addiction'].length > 0) {
            addictionTracks = userFireStore.userData['addiction'];
            _addictionTypes = List.from(Constants.addictionTypes);
            return ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: addictionTracks.length,
              itemBuilder: (context, index) {
                AddictionTracker addictionTracker = AddictionTracker.fromJson(
                    Map<String, dynamic>.from(addictionTracks[index]));
                _addictionTypes.remove(addictionTracker.type);
                _addictionType = _addictionTypes[0];
                return AddictionTrackCard(
                    addictionTracker: addictionTracker,
                    index: index,
                    clickAction: openAddictionScreen);
              },
            );
          }
        }
        return const Center(
            child: Text("There are currently no addiction trackers"));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddictionTrackerDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.red,
        notchMargin: 4,
        shape: CircularNotchedRectangle(),
        height: 45,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

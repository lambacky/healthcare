import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare/views/addiction/addiction_description_screen.dart';
import 'package:healthcare/view-models/addiction_track_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/addiction_track_card.dart';
import '../../components/submit_button.dart';

class AddictionListScreen extends StatelessWidget {
  const AddictionListScreen({Key? key}) : super(key: key);

  void _openAddictionScreen(int index, BuildContext context) {
    context.read<AddictionTrackViewModel>().getAddictionTracker(index);
    context.read<AddictionTrackViewModel>().getDaysAndMilestones();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AddictionDescriptionScreen()),
    );
  }

  void _openAddictionTrackerDialog(BuildContext context) {
    final addictionTrackViewModel = context.read<AddictionTrackViewModel>();
    addictionTrackViewModel.getAddictionTypes();
    addictionTrackViewModel
        .getAddictionTracker(addictionTrackViewModel.addictionTracks.length);
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
                    items: addictionTrackViewModel.addictionTypes
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
                              lastDate: addictionTrackViewModel
                                  .addictionTracker.startDate)
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
                          onPressed: () async {
                            bool success = await addictionTrackViewModel
                                .updateAddictionTracker();
                            if (success) {
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                  msg: "Addiction tracker saved successful");
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Error. Please try again");
                            }
                          })),
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
      body: Consumer<AddictionTrackViewModel>(
          builder: (context, addictionTrackViewModel, child) {
        if (addictionTrackViewModel.addictionTracks.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: addictionTrackViewModel.addictionTracks.length,
            itemBuilder: (context, index) {
              return AddictionTrackCard(
                  index: index, clickAction: _openAddictionScreen);
            },
          );
        }
        return const Center(
            child: Text("There are currently no addiction trackers"));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddictionTrackerDialog(context);
        },
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

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare/views/medicine/reminder_description_screen.dart';
import 'package:healthcare/view-models/medication_reminder_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../components/medication_reminder_card.dart';

class ReminderListScreen extends StatelessWidget {
  const ReminderListScreen({Key? key}) : super(key: key);

  void _checkNotificationPermission(BuildContext context) async {
    final reminderViewModel = context.read<MedicationReminderViewModel>();
    bool isGranted = await reminderViewModel.checkPermission();
    if (!isGranted) {
      _openDialog(context);
      return;
    }
    reminderViewModel.getReminder(reminderViewModel.reminders.length);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ReminderDescriptionScreen()),
    );
  }

  void _openDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Allow app to acess your notifications ?'),
        content: const Text(
            'You need to allow notifications access to add reminders'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Don\'t allow'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  void _deleteReminder(int index, BuildContext context) {
    final reminderViewModel = context.read<MedicationReminderViewModel>();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this reminder ?'),
        content: const Text('The reminder will be removed permanently'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              bool success = await reminderViewModel.deleteReminder(index);
              if (success) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "Medication reminder deleted successful");
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

  void _editReminder(int index, BuildContext context) async {
    final reminderViewModel = context.read<MedicationReminderViewModel>();
    reminderViewModel.getReminder(index);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ReminderDescriptionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Medicine Reminder"),
      ),
      body: Consumer<MedicationReminderViewModel>(
          builder: (context, reminderViewModel, child) {
        if (reminderViewModel.reminders.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: reminderViewModel.reminders.length,
            itemBuilder: (context, index) {
              return MedicationReminderCard(
                  deleteAction: _deleteReminder,
                  editAction: _editReminder,
                  index: index);
            },
          );
        }
        return const Center(child: Text("There are currently no reminders"));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _checkNotificationPermission(context);
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

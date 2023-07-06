import 'package:flutter/material.dart';
import 'package:healthcare/views/medicine/reminder_description_screen.dart';
import 'package:healthcare/view-models/medication_reminder_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../components/medication_reminder_card.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({Key? key}) : super(key: key);

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  checkNotificationPermission() {
    // LocationPermission permission;
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     return;
    //   }
    // }
    // if (permission == LocationPermission.deniedForever) {
    //   openDialog();
    //   return;
    // }
    // if (!context.mounted) return;
    final reminderViewModel = context.read<MedicationReminderViewModel>();
    reminderViewModel.getReminder(reminderViewModel.reminders.length);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ReminderDescriptionScreen()),
    );
  }

  openDialog() {
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

  void deleteReminder(int index) {
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
            onPressed: () {
              Navigator.pop(context);
              reminderViewModel.deleteReminder(index);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void editReminder(int index) async {
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
                  deleteAction: deleteReminder,
                  editAction: editReminder,
                  index: index);
            },
          );
        }
        return const Center(child: Text("There are currently no records"));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkNotificationPermission();
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

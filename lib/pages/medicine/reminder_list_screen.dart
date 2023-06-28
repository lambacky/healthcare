import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/medication_reminder.dart';
import 'package:healthcare/pages/medicine/reminder_description_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../components/medication_reminder_card.dart';
import '../../providers/user_firestore.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({Key? key}) : super(key: key);

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  List<dynamic> reminders = [];
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

  void deleteReminder(MedicationReminder reminder) {
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
              context.read<UserFireStore>().updateData({
                'medicine': FieldValue.arrayRemove([reminder.toJson()])
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void editReminder(MedicationReminder reminder, int index) async {
    final userFireStore = context.read<UserFireStore>();
    final newReminder = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReminderDescriptionScreen(reminder: reminder)),
    );
    if (newReminder != null) {
      reminders[index] = newReminder;
      userFireStore.updateData({'medicine': reminders});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Medicine Reminder"),
      ),
      body: Consumer<UserFireStore>(builder: (context, userFireStore, child) {
        if (userFireStore.userData.isNotEmpty) {
          if (userFireStore.userData.containsKey('medicine') &&
              userFireStore.userData['medicine'].length > 0) {
            reminders = userFireStore.userData['medicine'];
            return ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                MedicationReminder reminder = MedicationReminder.fromJson(
                    Map<String, dynamic>.from(reminders[index]));
                return MedicationReminderCard(
                    reminder: reminder,
                    deleteAction: deleteReminder,
                    editAction: editReminder,
                    index: index);
              },
            );
          }
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

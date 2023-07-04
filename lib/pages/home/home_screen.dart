// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/pages/addiction/addiction_list_screen.dart';
import 'package:healthcare/pages/medicine/reminder_list_screen.dart';
import 'package:healthcare/pages/meal/meal_screen.dart';
import 'package:healthcare/providers/user_firestore.dart';
import 'package:provider/provider.dart';
import '../../components/feature_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcare/pages/articles/articles_screen.dart';
import '../../services/notification_service.dart';
import '../bmi/bmi_screen.dart';
import '../heartrate/heart_rate_screen.dart';
import '../profile/profile_screen.dart';
import '../running/running_menu_screen.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:workmanager/workmanager.dart';
// import 'dart:convert';
// import 'dart:math';
// import '../../services/firebase_messaging_sevice.dart';
// import 'package:http/http.dart' as http;

// @pragma(
//     'vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     switch (task) {
//       case 'sendNotification':
//         // print(inputData!['token']);
//         // sendNotification(inputData['token']);
//         NotificationService().showNotification(
//             id: Random().nextInt(10000), title: 'hello', body: 'hello');
//         break;
//     }
//     return Future.value(true);
//   });
// }

// void sendNotification(String token) async {
//   try {
//     await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization':
//               'key=AAAAdxH9xC4:APA91bGbxDVuuLtpp3pUO-JdX53qxWd4yDrlw3fMDDmIQedwH-pU-KEpWull5Z6H3eFnAuRh01Ws4ttn-AfklCleEemb0LllJHxa53BY442XYLv94FTYhAhKa64z2R6Alm9mIAPVARfZ'
//         },
//         body: jsonEncode(<String, dynamic>{
//           'to': token,
//           'data': {},
//           'notification': {
//             'title': 'hello',
//             'body': 'How are you',
//           },
//         }));
//   } catch (e) {
//     print(e);
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String token = '';
  @override
  void initState() {
    super.initState();
    NotificationService().initNotification();

    context.read<UserFireStore>().fetchData();
    // FireBaseMessagingApi().initNotifications();
    // getToken();
    // Workmanager().initialize(callbackDispatcher);
  }

  final List<FeatureButton> features = const [
    FeatureButton(
        label: 'HEART RATE MONITOR',
        icon: FontAwesomeIcons.heartPulse,
        color: Colors.red,
        widget: HeartRateScreen()),
    FeatureButton(
        label: 'BMI CALCULATOR',
        icon: Icons.speed,
        color: Colors.green,
        widget: BMIScreen()),
    FeatureButton(
        label: 'RUN TRACKER',
        icon: Icons.directions_run,
        color: Colors.blue,
        widget: RunningMenuScreen()),
    FeatureButton(
        label: 'ARTICLES',
        icon: FontAwesomeIcons.newspaper,
        color: Color.fromARGB(255, 202, 131, 131),
        widget: ArticleScreen()),
    FeatureButton(
        label: 'MEAL PLANNER',
        icon: Icons.restaurant_menu,
        color: Color.fromARGB(255, 212, 133, 104),
        widget: MealScreen()),
    FeatureButton(
        label: 'MEDICINE REMINDER',
        icon: Icons.medication_outlined,
        color: Colors.blueGrey,
        widget: ReminderListScreen()),
    FeatureButton(
        label: 'ADDICTION TRACKER',
        icon: Icons.liquor,
        color: Colors.green,
        widget: AddictionListScreen())
  ];

  // void getToken() async {
  //   final user = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .get();
  //   token = user.data()!['token'];
  //   print('my token is ${token}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Health Care'),
        actions: [
          IconButton(
            onPressed: () {
              // FirebaseAuth.instance.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
            icon: const Icon(Icons.account_circle),
          )
        ],
      ),
      body: GridView.count(
        shrinkWrap: true,
        padding: const EdgeInsets.all(30),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 30,
        children: List.generate(features.length, (index) => features[index]),
      ),
      // body: Center(
      //   child: Column(children: [
      //     TextButton(
      //         onPressed: () {
      //           Workmanager().registerPeriodicTask(
      //               'sendNotification', 'sendNotification',
      //               frequency: const Duration(minutes: 15),
      //               // inputData: {'token': token},
      //               initialDelay: const Duration(seconds: 5));
      //         },
      //         child: const Text("send notification")),
      //     TextButton(
      //         onPressed: () {}, child: const Text("start workmanager")),
      //     TextButton(
      //         onPressed: () {
      //           Workmanager().cancelAll();
      //         },
      //         child: const Text("stop workmanager"))
      //   ]),
      // )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:healthcare/views/addiction/addiction_list_screen.dart';
import 'package:healthcare/views/medicine/reminder_list_screen.dart';
import 'package:healthcare/views/meal/meal_screen.dart';
import 'package:healthcare/services/firebase_service.dart';
import 'package:healthcare/view-models/addiction_track_view_model.dart';
import 'package:healthcare/view-models/meal_plan_view_model.dart';
import 'package:healthcare/view-models/medication_reminder_view_model.dart';
import 'package:provider/provider.dart';
import '../../components/feature_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcare/views/articles/articles_screen.dart';
import '../../services/notification_service.dart';
import '../../view-models/physical_status_view_model.dart';
import '../../view-models/target_view_model.dart';
import '../../view-models/track_view_model.dart';
import '../../view-models/user_view_model.dart';
import '../bmi/bmi_screen.dart';
import '../heartrate/heart_rate_screen.dart';
import '../profile/profile_screen.dart';
import '../running/running_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    NotificationService().initNotification();
    fetchData();
  }

  void fetchData() async {
    await FireBaseService().fetchData().then((data) {
      context.read<MedicationReminderViewModel>().getReminders(data);
      context.read<AddictionTrackViewModel>().getAddictionTracks(data);
      context.read<MealPlanViewModel>().getMealPlan(data);
      context.read<UserViewModel>().getUserModel(data);
      context.read<PhysicStatViewModel>().getPhysicStat(data);
      context.read<TrackViewModel>().getTracks(data);
      context.read<TargetViewModel>().getTargets(data);
    });
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
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:healthcare/views/main_screen.dart';
import 'package:healthcare/view-models/addiction_track_view_model.dart';
import 'package:healthcare/view-models/article_view_model.dart';
import 'package:healthcare/view-models/auth_view_model.dart';
import 'package:healthcare/view-models/heart_rate_view_model.dart';
import 'package:healthcare/view-models/meal_plan_view_model.dart';
import 'package:healthcare/view-models/medication_reminder_view_model.dart';
import 'package:healthcare/view-models/physical_status_view_model.dart';
import 'package:healthcare/view-models/target_view_model.dart';
import 'package:healthcare/view-models/track_view_model.dart';
import 'package:healthcare/view-models/user_view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

// import 'package:dcdg/dcdg.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  // await FireBaseMessagingService().initNotifications();
  // final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(timeZone));
  // NotificationService().initNotification();

  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
            create: (_) => AuthViewModel()),
        ChangeNotifierProvider<MedicationReminderViewModel>(
            create: (_) => MedicationReminderViewModel()),
        ChangeNotifierProvider<AddictionTrackViewModel>(
            create: (_) => AddictionTrackViewModel()),
        ChangeNotifierProvider<MealPlanViewModel>(
            create: (_) => MealPlanViewModel()),
        ChangeNotifierProvider<ArticleViewModel>(
            create: (_) => ArticleViewModel()),
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<PhysicStatViewModel>(
            create: (_) => PhysicStatViewModel()),
        ChangeNotifierProvider<TargetViewModel>(
            create: (_) => TargetViewModel()),
        ChangeNotifierProvider<TrackViewModel>(create: (_) => TrackViewModel()),
        ChangeNotifierProvider<HeartRateViewModel>(
            create: (_) => HeartRateViewModel())
      ],
      child: MaterialApp(
        title: 'Health Care App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          // fontFamily: GoogleFonts.montserrat().fontFamily
        ),
        home: const MainScreen(),
      ),
    );
  }
}

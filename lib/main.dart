import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthcare/pages/main_screen.dart';
import 'package:healthcare/providers/user_firestore.dart';
import 'package:healthcare/services/firebase_messaging_sevice.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

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
  // await FireBaseMessagingService().initNotifications();
  // final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(timeZone));
  // NotificationService().initNotification();

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserFireStore>(create: (_) => UserFireStore())
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/feature_button.dart';
import 'package:healthcare/models/feature_button_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcare/pages/articles/articles_screen.dart';
import 'package:healthcare/pages/running/running_screen.dart';
import '../bmi/bmi_screen.dart';
import '../heartrate/heart_rate_screen.dart';
import '../recommend/recommend.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<FeatureButton> features = <FeatureButton>[
      FeatureButton(
          label: 'HEART RATE',
          icon: FontAwesomeIcons.heartPulse,
          color: Colors.red,
          widget: HeartRateScreen()),
      FeatureButton(
          label: 'BMI CALCULATOR',
          icon: Icons.speed,
          color: Colors.green,
          widget: BMIScreen()),
      FeatureButton(
          label: 'RUN TRACKING',
          icon: Icons.directions_run,
          color: Colors.blue,
          widget: RunningScreen()),
      FeatureButton(
          label: 'ARTICLES',
          icon: FontAwesomeIcons.newspaper,
          color: Color.fromARGB(255, 202, 131, 131),
          widget: ArticleScreen()),
      FeatureButton(
          label: 'RECOMMENDATIONS',
          icon: Icons.tips_and_updates,
          color: Colors.yellow,
          widget: Recommend()),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Health Care'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(30),
        crossAxisCount: 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        children: List.generate(features.length,
            (index) => SelectFeature(feature: features[index])),
      ),
    );
  }
}

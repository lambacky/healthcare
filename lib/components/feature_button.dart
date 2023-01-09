import 'package:flutter/material.dart';
import 'package:healthcare/models/feature_button_model.dart';

class SelectFeature extends StatelessWidget {
  final FeatureButton feature;
  const SelectFeature({Key? key, required this.feature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(10),
        side: const BorderSide(
          color: Color.fromARGB(255, 231, 226, 226),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => feature.widget),
        );
      },
      child: Column(
        children: <Widget>[
          Icon(feature.icon, color: feature.color, size: 80),
          const SizedBox(height: 20),
          Text(feature.label),
        ],
      ),
    );
  }
}

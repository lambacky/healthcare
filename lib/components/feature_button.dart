import 'package:flutter/material.dart';

class FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Widget widget;
  const FeatureButton(
      {Key? key,
      required this.label,
      required this.icon,
      required this.color,
      required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
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
          MaterialPageRoute(builder: (context) => widget),
        );
      },
      child: Column(
        children: <Widget>[
          Icon(icon, color: color, size: 80),
          const SizedBox(height: 20),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 78, 77, 77))),
        ],
      ),
    );
  }
}

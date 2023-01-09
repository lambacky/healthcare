import 'package:flutter/material.dart';

class FeatureButton {
  const FeatureButton(
      {required this.label,
      required this.icon,
      required this.color,
      required this.widget});
  final String label;
  final IconData icon;
  final Color color;
  final Widget widget;
}

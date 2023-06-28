import 'package:flutter/material.dart';

class MedicationType {
  final String name;
  final IconData icon;
  final String unit;
  MedicationType({required this.name, required this.icon, required this.unit});

  factory MedicationType.fromJson(Map<String, dynamic> json) {
    IconData icon = IconData(json['icon'],
        fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    return MedicationType(name: json['name'], icon: icon, unit: json['unit']);
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon.codePoint,
      'unit': unit,
    };
  }
}

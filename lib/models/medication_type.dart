import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';

class MedicationType extends Equatable {
  final String name;
  final IconData icon;
  final String unit;

  MedicationType({required this.name, required this.icon, required this.unit});

  factory MedicationType.fromString(String name) {
    for (var medicationType in Constants.medicationTypes) {
      if (name == medicationType.name) {
        return medicationType.clone();
      }
    }
    return Constants.medicationTypes[0].clone();
  }

  MedicationType clone() {
    return MedicationType(name: name, icon: icon, unit: unit);
  }

  @override
  List<Object?> get props => [name, icon, unit];
}

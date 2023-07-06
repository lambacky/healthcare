import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcare/models/medication_type.dart';

class Constants {
  static List<String> diets = [
    'None',
    'Gluten Free',
    'Ketogenic',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Pescetarian',
    'Paleo',
    'Primal',
  ];

  static const List<String> addictionTypes = [
    'Alcohol',
    'Nicotine',
    'Drug',
    'Junk Food',
    'Sweets',
    'Video Games',
    'Pornography'
  ];

  static List<MedicationType> medicationTypes = [
    MedicationType(
        name: 'Tablet', icon: FontAwesomeIcons.tablets, unit: 'pills'),
    MedicationType(
        name: 'Capsule', icon: FontAwesomeIcons.capsules, unit: 'pills'),
    MedicationType(name: 'Syringe', icon: FontAwesomeIcons.syringe, unit: 'ml'),
    MedicationType(
        name: 'Drop', icon: FontAwesomeIcons.eyeDropper, unit: 'drops'),
  ];
  static List<int> mileStones = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    15,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
    110,
    120,
    130,
    140,
    150,
    160,
    170,
    180,
    190,
    200,
    220,
    240,
    260,
    280,
    300,
    320,
    340,
    365
  ];
}

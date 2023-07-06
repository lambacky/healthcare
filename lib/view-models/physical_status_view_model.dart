import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/physical_status.dart';

import '../services/firebase_service.dart';

class PhysicStatViewModel extends ChangeNotifier {
  PhysicalStatus? _physicStat;
  PhysicalStatus? get physicStat => _physicStat;
  late String _bmiInterpretation;
  String get bmiInterpretation => _bmiInterpretation;
  late Color _bmiStatusColor;
  Color get bmiStatusColor => _bmiStatusColor;
  bool _isSaved = false;
  bool get isSaved => _isSaved;

  void setPhysicStat(int height, int weight) {
    _isSaved = false;
    double bmiScore = weight / pow(height / 100, 2);
    String bmiStatus = '';
    if (bmiScore > 30) {
      bmiStatus = "OBESE";
      _bmiInterpretation = "Please work to reduce obesity";
      _bmiStatusColor = Colors.pink;
    } else if (bmiScore >= 25) {
      bmiStatus = "OVERWEIGHT";
      _bmiInterpretation = "Do regular exercise & reduce the weight";
      _bmiStatusColor = Colors.orange;
    } else if (bmiScore >= 18.5) {
      bmiStatus = "NORMAL";
      _bmiInterpretation = "You are fit, keep maintaining your health";
      _bmiStatusColor = Colors.green;
    } else if (bmiScore < 18.5) {
      bmiStatus = "UNDERWEIGHT";
      _bmiInterpretation = "Please work to increase your weight";
      _bmiStatusColor = Colors.red;
    }
    _physicStat = PhysicalStatus(
        height: height, weight: weight, bmi: bmiScore, status: bmiStatus);
    notifyListeners();
  }

  void getPhysicStat(Map<String, dynamic>? data) {
    if (data != null &&
        data.containsKey('physicStat') &&
        data['physicStat'] != null) {
      _physicStat = PhysicalStatus.fromJson(data['physicStat']);
      _isSaved = true;
    }
    notifyListeners();
  }

  Future<void> updatePhysicStat() async {
    try {
      await FireBaseService().updateData({'physicStat': physicStat!.toJson()});
      _isSaved = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePhysicStat() async {
    try {
      await FireBaseService().updateData({'physicStat': FieldValue.delete()});
      _physicStat = null;
      _isSaved = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

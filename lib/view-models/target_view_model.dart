import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/running_target.dart';
import '../services/firebase_service.dart';

class TargetViewModel extends ChangeNotifier {
  List<RunningTarget> _targets = [];
  List<RunningTarget> get targets => _targets;
  late RunningTarget _target;
  RunningTarget get target => _target;
  late RunningTarget _currentTarget;
  late int _currentIndex;
  late bool _isEnabled;
  bool get isEnabled => _isEnabled;
  int _progress = 0;
  int get progress => _progress;

  void getTargets(Map<String, dynamic>? data) {
    _targets.clear();
    _progress = 0;
    if (data != null &&
        data.containsKey('targets') &&
        data['targets'].length > 0) {
      List<dynamic> targets = data['targets'];
      _targets = targets.map((item) {
        RunningTarget target = RunningTarget.fromJson(item);
        if (target.status == 'progress') {
          _progress++;
        }
        return target;
      }).toList();
    }
    notifyListeners();
  }

  Future<void> checkDueDate() async {
    List<dynamic> targets = [];
    bool isChange = false;
    for (var target in _targets) {
      if (target.checkDueDate()) {
        isChange = true;
      }
      targets.add(target.toJson());
    }
    if (isChange) {
      await FireBaseService().updateData({'targets': targets});
      notifyListeners();
    }
  }

  Future<void> updateTargets(double distance) async {
    List<dynamic> targets = [];
    bool isChange = false;
    for (var target in _targets) {
      if (target.checkDistance(distance)) {
        isChange = true;
      }
      targets.add(target.toJson());
    }
    if (isChange) {
      await FireBaseService().updateData({'targets': targets});
      notifyListeners();
    }
  }

  Future<void> deleteRunningTarget(int index) async {
    try {
      await FireBaseService().updateData({
        'targets': FieldValue.arrayRemove([_targets[index].toJson()])
      });
      if (_targets[index].status == 'progress') {
        _progress--;
      }
      _targets.removeAt(index);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void getRunningTarget(int index) {
    if (index == _targets.length) {
      _target = RunningTarget(
          targetDistance: 0,
          achievedDistance: 0,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          status: 'progress');
    } else {
      _target = _targets[index].clone();
    }
    _currentTarget = _target.clone();
    _currentIndex = index;
    _isEnabled = false;
    notifyListeners();
  }

  void checkButtonState() {
    _isEnabled = _target.targetDistance != 0 && _target != _currentTarget;
    notifyListeners();
  }

  void updateDistance(String distance) {
    _target.updateDistance(distance);
    checkButtonState();
  }

  void updateDate(DateTime dateTime, String type) {
    _target.updateDate(dateTime, type);
    checkButtonState();
  }

  Future<void> updateRunningTarget() async {
    try {
      if (_currentIndex < _targets.length) {
        _targets[_currentIndex] = _target;
      } else {
        _targets.add(_target);
        _progress++;
      }
      List<dynamic> targets = _targets.map((item) => item.toJson()).toList();
      await FireBaseService().updateData({'targets': targets});
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

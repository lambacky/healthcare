import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/running_target.dart';

import '../models/track_model.dart';
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
    if (data != null &&
        data.containsKey('targets') &&
        data['targets'].length > 0) {
      List<dynamic> targets = data['targets'];
      for (var item in targets) {
        RunningTarget target = RunningTarget.fromJson(item);
        _targets.add(target);
        if (target.status == 'progress') {
          _progress++;
        }
      }
    }
    notifyListeners();
  }

  Future<void> updateTargets(Track track) async {
    List<dynamic> targets = [];
    for (var target in _targets) {
      if (target.status == 'progress') {
        target.achievedDistance += track.distance;
        if (target.achievedDistance > target.targetDistance) {
          target.status = 'finished';
        }
      }
      targets.add(target.toJson());
    }
    await FireBaseService().updateData({'targets': targets});
    notifyListeners();
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
    _target.targetDistance =
        (distance.isEmpty || distance == '.') ? 0 : double.parse(distance);
    checkButtonState();
  }

  void updateDate(DateTime dateTime, String type) {
    if (type == 'start') {
      _target.startDate = dateTime;
      if (_target.startDate.compareTo(_target.endDate) > 0) {
        _target.endDate = _target.startDate;
      }
    } else {
      _target.endDate = dateTime;
    }
    checkButtonState();
  }

  Future<void> updateRunningTarget() async {
    try {
      _target.startDate = DateTime(_target.startDate.year,
          _target.startDate.month, target.startDate.day, 0, 0, 0);
      _target.endDate = DateTime(_target.endDate.year, _target.endDate.month,
          target.endDate.day, 23, 59, 59);
      if (_currentIndex < _targets.length) {
        _targets[_currentIndex] = _target;
      } else {
        _targets.add(_target);
      }
      List<dynamic> targets = [];
      for (var target in _targets) {
        targets.add(target.toJson());
      }
      await FireBaseService().updateData({'targets': targets});
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

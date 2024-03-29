import 'package:flutter/material.dart';
import 'package:healthcare/models/addiction_tracker.dart';
import '../constants/constants.dart';
import '../services/firebase_service.dart';

class AddictionTrackViewModel extends ChangeNotifier {
  List<AddictionTracker> _addictionTracks = [];
  List<AddictionTracker> get addictionTracks => _addictionTracks;
  late AddictionTracker _addictionTracker;
  AddictionTracker get addictionTracker => _addictionTracker;
  late AddictionTracker _currentAddictionTracker;
  AddictionTracker get currentAddictionTracker => _currentAddictionTracker;
  late int _currentIndex;
  late bool _isEnabled;
  bool get isEnabled => _isEnabled;
  late List<String> _addictionTypes;
  List<String> get addictionTypes => _addictionTypes;
  late List<String> _editAddictionTypes;
  List<String> get editAddictionTypes => _editAddictionTypes;
  late int _days;
  int get days => _days;
  late int _currentMilestone;
  int get currentMilestone => _currentMilestone;
  late List<int> _lastMilestones;
  List<int> get lastMileStones => _lastMilestones;

  void getDaysAndMilestones() {
    _days = DateTime.now().difference(_addictionTracker.startDate).inDays;
    _lastMilestones = [];
    for (var milestone in Constants.mileStones) {
      if (_days < milestone) {
        _currentMilestone = milestone;
        break;
      }
      _lastMilestones.add(milestone);
    }
    notifyListeners();
  }

  void getAddictionTypes() {
    _addictionTypes = List.from(Constants.addictionTypes);
    for (var addictionTracker in addictionTracks) {
      _addictionTypes.remove(addictionTracker.type);
    }
    notifyListeners();
  }

  void getEditAddictionTypes() {
    _editAddictionTypes = List.from(Constants.addictionTypes);
    for (var addictionTracker in addictionTracks) {
      if (addictionTracker.type != _addictionTracker.type) {
        _editAddictionTypes.remove(addictionTracker.type);
      }
    }
    notifyListeners();
  }

  Future<void> updateData() async {
    List<dynamic> addictionTracks =
        _addictionTracks.map((item) => item.toJson()).toList();
    await FireBaseService().updateData({'addiction': addictionTracks});
  }

  void getAddictionTracks(Map<String, dynamic>? data) {
    _addictionTracks.clear();
    if (data != null &&
        data.containsKey('addiction') &&
        data['addiction'].length > 0) {
      List<dynamic> addictionTracks = data['addiction'];
      _addictionTracks = addictionTracks
          .map((item) => AddictionTracker.fromJson(item))
          .toList();
    }
    notifyListeners();
  }

  Future<bool> deleteAddictionTracker() async {
    try {
      _addictionTracks.remove(_addictionTracker);
      await updateData();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAddictionTracker() async {
    try {
      _currentAddictionTracker = _addictionTracker;
      if (_currentIndex < _addictionTracks.length) {
        _addictionTracks[_currentIndex] = _addictionTracker;
      } else {
        _addictionTracks.add(_addictionTracker);
      }
      await updateData();
      getDaysAndMilestones();
      return true;
    } catch (e) {
      return false;
    }
  }

  void getAddictionTracker(int index) {
    if (index == _addictionTracks.length) {
      _addictionTracker =
          AddictionTracker(type: _addictionTypes[0], startDate: DateTime.now());
    } else {
      _addictionTracker = _addictionTracks[index].clone();
    }
    _currentAddictionTracker = _addictionTracker.clone();
    _currentIndex = index;
    _isEnabled = false;
    notifyListeners();
  }

  void checkButtonState() {
    _isEnabled = _addictionTracker != _currentAddictionTracker;

    notifyListeners();
  }

  void updateType(String type) {
    _addictionTracker.updateType(type);
    checkButtonState();
  }

  void updateStartDate(DateTime startDate) {
    _addictionTracker.updateStartDate(startDate);
    checkButtonState();
  }

  Future<bool> restartAddictionTrack() async {
    _addictionTracker.restartAddictionTrack();
    _currentAddictionTracker = _addictionTracker;
    return await updateAddictionTracker();
  }
}

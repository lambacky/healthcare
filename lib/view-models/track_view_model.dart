import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../models/track.dart';
import '../services/firebase_service.dart';

class TrackViewModel extends ChangeNotifier {
  List<Track> _tracks = [];
  List<Track> get tracks => _tracks;
  late Track _track;
  Track get track => _track;
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;
  StopWatchTimer? _stopWatchTimer;
  StopWatchTimer? get stopWatchTimer => _stopWatchTimer;

  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<Position>? get positionStreamSubscription =>
      _positionStreamSubscription;
  Completer<GoogleMapController>? _controller;
  late String _runningState;
  String get runningState => _runningState;
  Set<Polyline> _polyLines = {};
  Set<Polyline> get polyLines => _polyLines;
  List<List<LatLng>> _coordinates = [];
  late double _north;
  late double _south;
  late double _west;
  late double _east;
  late int _polyLineCount;
  bool _isHistoryScreen = true;
  bool get isHistoryScreen => _isHistoryScreen;

  void changeScreen(bool value) {
    _isHistoryScreen = value;
    notifyListeners();
  }

  void onMapCreated(GoogleMapController mapController) async {
    _controller!.complete(mapController);
    var controller = await _controller!.future;
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high, distanceFilter: 10))
        .listen((Position position) async {
      if (_runningState == 'finish') {
        await _positionStreamSubscription!.cancel();
      } else {
        if (_runningState == "run") {
          if (position.longitude > _east) {
            _east = position.longitude;
          } else if (position.longitude < _west) {
            _west = position.longitude;
          }
          if (position.latitude > _north) {
            _north = position.latitude;
          } else if (position.latitude < _south) {
            _south = position.latitude;
          }
          double distance = Geolocator.distanceBetween(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  position.latitude,
                  position.longitude) /
              1000;
          double speed = _stopWatchTimer!.secondTime.value > 0
              ? 3600 * _track.distance / _stopWatchTimer!.secondTime.value
              : 0;
          _track.updateDistanceAndSpeed(distance, speed);
          _coordinates[_polyLineCount - 1]
              .add(LatLng(position.latitude, position.longitude));
          Polyline polyLine = Polyline(
            polylineId: PolylineId(_polyLineCount.toString()),
            points: _coordinates[_polyLineCount - 1],
            color: Colors.blue,
            width: 5,
          );
          _polyLines.add(polyLine);
        }
        _currentPosition = position;
        controller.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude), 15));
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void setInitialLocation() {
    try {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        _north = position.latitude;
        _south = position.latitude;
        _east = position.longitude;
        _west = position.longitude;
        _currentPosition = position;
        notifyListeners();
      });
    } catch (e) {
      print('error: $e');
    }
  }

  void getTracks(Map<String, dynamic>? data) {
    _tracks.clear();
    if (data != null &&
        data.containsKey('running') &&
        data['running'].length > 0) {
      List<dynamic> tracks = data['running'];
      _tracks = tracks.map((item) => Track.fromJson(item)).toList();
    }
    notifyListeners();
  }

  void setTrack() {
    _stopWatchTimer = StopWatchTimer();
    _track = Track(
        date: DateTime.now(),
        distance: 0,
        speed: 0,
        time: '00:00:00',
        steps: 0,
        routeImageURL: '',
        routeImagePath: '',
        place: '');
    _controller = Completer<GoogleMapController>();
    _runningState = 'none';
    _polyLines.clear();
    _polyLineCount = 0;
    _coordinates.clear();
    notifyListeners();
  }

  void startRun() {
    _runningState = "run";
    _coordinates.add([]);
    _polyLineCount++;
    _stopWatchTimer!.onStartTimer();
    notifyListeners();
  }

  void stopRun() {
    _runningState = "stop";
    _stopWatchTimer!.onStopTimer();
    notifyListeners();
  }

  void restartRun() {
    _track = Track(
        date: DateTime.now(),
        distance: 0,
        speed: 0,
        time: '00:00:00',
        steps: 0,
        routeImageURL: '',
        routeImagePath: '',
        place: '');
    _stopWatchTimer!.onResetTimer();
    _polyLines.clear();
    _polyLineCount = 0;
    _coordinates.clear();
    _runningState = 'none';
    notifyListeners();
  }

  Future<void> saveRun() async {
    String place = '';
    _runningState = 'finish';
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      if (placemarks.isNotEmpty) {
        place =
            "${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";
      }
    } catch (e) {}

    var controller = await _controller!.future;
    await controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(_south, _west), northeast: LatLng(_north, _east)),
        15));
    await Future.delayed(const Duration(seconds: 2), () async {
      var routeSnapshot = await controller.takeSnapshot();
      String routeImageFile = DateTime.now().microsecondsSinceEpoch.toString();
      String routeImagePath =
          '${FirebaseAuth.instance.currentUser?.uid}/$routeImageFile';
      String routeImageURL = await FireBaseService()
          .uploadAndGetURL(routeImagePath, routeSnapshot!);
      String time = StopWatchTimer.getDisplayTime(
          _stopWatchTimer!.rawTime.value,
          milliSecond: false);
      _track.updateTrack(time, place, routeImageURL, routeImagePath);
      addTrack();
    });
  }

  Future<void> deleteTrack(int index) async {
    try {
      await FireBaseService().updateData({
        'running': FieldValue.arrayRemove([_tracks[index].toJson()])
      });
      await FirebaseStorage.instance
          .ref()
          .child(_tracks[index].routeImagePath)
          .delete();
      _tracks.removeAt(index);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addTrack() async {
    try {
      _tracks.add(_track);
      await FireBaseService().updateData({
        'running': FieldValue.arrayUnion([_track.toJson()])
      });
      _isHistoryScreen = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancel() async {
    await _positionStreamSubscription?.cancel();
    await _stopWatchTimer!.dispose();
  }
}

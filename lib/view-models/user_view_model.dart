import 'package:flutter/material.dart';
import 'package:healthcare/models/user_model.dart';

import '../services/firebase_service.dart';

class UserViewModel extends ChangeNotifier {
  late UserModel _userModel;
  UserModel get userModel => _userModel;
  late UserModel _newUserModel;
  UserModel get newUserModel => _newUserModel;
  bool _isValid = false;
  bool get isValid => _isValid;

  void getUserModel(Map<String, dynamic>? data) {
    _userModel = UserModel.fromJson(data!);
    notifyListeners();
  }

  void setNewUserModel() {
    _newUserModel = _userModel.clone();
    notifyListeners();
  }

  void setFirstName(String firstName) {
    _newUserModel.setFirstName(firstName);
    checkValid();
  }

  void setLastName(String lastName) {
    _newUserModel.setLastName(lastName);
    checkValid();
  }

  void checkValid() {
    _isValid = _newUserModel.firstName.isNotEmpty &&
        _newUserModel.lastName.isNotEmpty &&
        _newUserModel != _userModel;
    notifyListeners();
  }

  Future<void> updateUserModel() async {
    try {
      _userModel = _newUserModel;
      await FireBaseService().updateData(
          {'firstName': _userModel.firstName, 'lastName': _userModel.lastName});
      _isValid = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

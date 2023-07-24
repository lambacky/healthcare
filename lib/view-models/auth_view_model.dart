import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/services/firebase_service.dart';
import 'package:healthcare/services/notification_service.dart';

import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _resetPasswordFormKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? _confirmPassword;
  String? _firstName;
  String? _lastName;
  bool _showLoginPage = true;
  bool get showLoginPage => _showLoginPage;
  GlobalKey<FormState> get loginFormKey => _loginFormKey;
  GlobalKey<FormState> get registerFormKey => _registerFormKey;
  GlobalKey<FormState> get resetPasswordFormKey => _resetPasswordFormKey;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String? validate(value, title) {
    if (value!.isEmpty) {
      return ("Field cannot be Empty");
    }
    if (title == "Email") {
      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
        return ("Please Enter a valid email");
      }
    }
    if (title == "Password") {
      if (!RegExp(r'^.{6,}$').hasMatch(value)) {
        return ("Enter Valid Password(Min. 6 Character)");
      }
    }
    if (title == "Confirm Password") {
      if (_confirmPassword != _password) {
        return "Password don't match";
      }
    }
    return null;
  }

  toggle() {
    _showLoginPage = !_showLoginPage;
    notifyListeners();
  }

  updateEmail(String value) {
    _email = value;
  }

  updatePassword(String value) {
    _password = value;
  }

  updateConfirmPassword(String value) {
    _confirmPassword = value;
  }

  updateFirstName(String value) {
    _firstName = value;
  }

  updateLastName(String value) {
    _lastName = value;
  }

  Future<String?> signIn() async {
    if (_loginFormKey.currentState!.validate()) {
      String message = await FireBaseService().signIn(_email!, _password!);
      switch (message) {
        case "successful":
          _email = null;
          _password = null;
          return "Login Successful";
        case "invalid-email":
        case "wrong-password":
        case "user-not-found":
          return "Your email or password is wrong.";
        case "user-disabled":
          return "User with this email has been disabled.";
        case "too-many-requests":
          return "Too many requests";
        case "operation-not-allowed":
          return "Signing in with Email and Password is not enabled.";
        default:
          return "An undefined Error happened.";
      }
    }
    return null;
  }

  Future<String?> signUp() async {
    if (_registerFormKey.currentState!.validate()) {
      String message = await FireBaseService().signUp(_email!, _password!);
      switch (message) {
        case "successful":
          try {
            User? user = _auth.currentUser;
            UserModel userModel = UserModel(
                uid: user!.uid,
                email: _email!,
                firstName: _firstName!,
                lastName: _lastName!);
            await FireBaseService().setUser(userModel.toJson(), user.uid);
            _email = null;
            _password = null;
            _lastName = null;
            _firstName = null;
            return "Account created successful";
          } catch (e) {
            return "An undefined Error happened.";
          }
        case "invalid-email":
        case "wrong-password":
        case "user-not-found":
          return "Your email or password is wrong.";
        case "user-disabled":
          return "User with this email has been disabled.";
        case "too-many-requests":
          return "Too many requests";
        case "operation-not-allowed":
          return "Signing in with Email and Password is not enabled.";
        default:
          return "An undefined Error happened.";
      }
    }
    return null;
  }

  Future<String?> resetPassword() async {
    if (_resetPasswordFormKey.currentState!.validate()) {
      String message = await FireBaseService().resetPassword(_email!);
      switch (message) {
        case "successful":
          _email = null;
          return "Email sent successful";
        default:
          return "An undefined Error happened.";
      }
    }
    return null;
  }

  Future<String> signOut() async {
    String message = await FireBaseService().signOut();
    switch (message) {
      case "successful":
        await NotificationService().cancelAllNotifications();
        return "Sign out successful";
      default:
        return "An undefined Error happened.";
    }
  }
}

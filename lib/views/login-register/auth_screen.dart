import 'package:flutter/material.dart';
import 'package:healthcare/views/login-register/login_screen.dart';
import 'package:healthcare/views/login-register/registration_screen.dart';
import 'package:provider/provider.dart';
import '../../view-models/auth_view_model.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLogin = context.watch<AuthViewModel>().showLoginPage;
    if (isLogin) {
      return const LoginScreen();
    } else {
      return const RegistrationScreen();
    }
  }
}

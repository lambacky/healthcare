import 'package:flutter/material.dart';
import 'package:healthcare/views/login-register/auth_screen.dart';
import 'package:healthcare/views/home/home_screen.dart';
import 'package:provider/provider.dart';
import '../view-models/auth_view_model.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authStateChanges = context.read<AuthViewModel>().authStateChanges;
    return Scaffold(
      body: StreamBuilder(
        stream: authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}

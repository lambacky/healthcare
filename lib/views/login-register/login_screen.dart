import 'package:healthcare/views/login-register/reset_password_screen.dart';
import 'package:provider/provider.dart';
import '../../components/submit_button.dart';
import '../../components/text_input.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../view-models/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signIn(BuildContext context) async {
    String? message = await context.read<AuthViewModel>().signIn();
    if (message != null) {
      Fluttertoast.showToast(msg: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    final List<TextInput> formInputs = <TextInput>[
      TextInput(
        title: 'Email',
        icon: Icons.email,
        onChanged: authViewModel.updateEmail,
      ),
      TextInput(
          title: 'Password',
          icon: Icons.lock,
          onChanged: authViewModel.updatePassword),
    ];
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: authViewModel.loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 100,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 45),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                          formInputs.length, (index) => formInputs[index]),
                    ),
                    SubmitButton(
                        text: 'Log In',
                        onPressed: () {
                          signIn(context);
                        }),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: authViewModel.toggle,
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ]),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ResetPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:healthcare/view-models/auth_view_model.dart';
import 'package:provider/provider.dart';
import '../../components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/text_input.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  void signUp(BuildContext context) async {
    String? message = await context.read<AuthViewModel>().signUp();
    if (message != null) {
      Fluttertoast.showToast(msg: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();

    final List<TextInput> formInputs = <TextInput>[
      TextInput(
        title: 'First Name',
        icon: Icons.account_circle,
        onChanged: authViewModel.updateFirstName,
      ),
      TextInput(
        title: 'Last Name',
        icon: Icons.account_circle,
        onChanged: authViewModel.updateLastName,
      ),
      TextInput(
        title: 'Email',
        icon: Icons.email,
        onChanged: authViewModel.updateEmail,
      ),
      TextInput(
        title: 'Password',
        icon: Icons.lock,
        onChanged: authViewModel.updatePassword,
      ),
      TextInput(
        title: 'Confirm Password',
        icon: Icons.lock,
        onChanged: authViewModel.updateConfirmPassword,
      ),
    ];

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 36, 40),
              child: Form(
                key: authViewModel.registerFormKey,
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
                    // confirmPasswordField,
                    const SizedBox(height: 20),
                    SubmitButton(
                        text: 'Sign Up',
                        onPressed: () {
                          signUp(context);
                        }),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("I am a member! "),
                          GestureDetector(
                            onTap: authViewModel.toggle,
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ])
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

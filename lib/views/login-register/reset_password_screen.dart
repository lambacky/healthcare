import 'package:provider/provider.dart';
import '../../components/submit_button.dart';
import '../../components/text_input.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../view-models/auth_view_model.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  void _resetPassword(BuildContext context) async {
    String? message = await context.read<AuthViewModel>().resetPassword();
    if (message != null) {
      Fluttertoast.showToast(msg: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: authViewModel.resetPasswordFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Enter your email and we will send you a link to reset password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextInput(
                  title: 'Email',
                  icon: Icons.email,
                  onChanged: (value) {},
                ),
                SubmitButton(
                    text: "Reset Password",
                    onPressed: () {
                      _resetPassword(context);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

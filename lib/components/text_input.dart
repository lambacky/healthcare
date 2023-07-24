import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view-models/auth_view_model.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onChanged})
      : super(key: key);
  final String title;
  final IconData icon;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        autofocus: false,
        obscureText:
            title == "Password" || title == "Confirm Password" ? true : false,
        validator: (value) {
          return context.read<AuthViewModel>().validate(value, title);
        },
        onChanged: (value) {
          onChanged(value);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

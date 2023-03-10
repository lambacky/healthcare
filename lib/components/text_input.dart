import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput(
      {Key? key,
      required this.textEditingController,
      required this.title,
      required this.icon})
      : super(key: key);
  final TextEditingController textEditingController;
  final String title;
  final IconData icon;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        autofocus: false,
        controller: widget.textEditingController,
        obscureText: widget.title == "Password" ? true : false,
        validator: (value) {
          return validate(value);
        },
        onSaved: (value) {
          widget.textEditingController.text = value!;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: widget.title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  String? validate(value) {
    if (value!.isEmpty) {
      return ("Field cannot be Empty");
    }
    if (widget.title == "Email") {
      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
        return ("Please Enter a valid email");
      }
    }
    if (widget.title == "Password") {
      if (!RegExp(r'^.{6,}$').hasMatch(value)) {
        return ("Enter Valid Password(Min. 6 Character)");
      }
    }
    return null;
  }
}

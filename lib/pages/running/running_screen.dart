import "package:flutter/material.dart";

class RunningScreen extends StatelessWidget {
  const RunningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Run Tracking"),
        ),
        body: const Center(
          child: Text("Running"),
        ));
  }
}

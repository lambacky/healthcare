import 'package:flutter/material.dart';

class Recommend extends StatelessWidget {
  const Recommend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Health Recommendations"),
      ),
      body: const Center(
        child: Text("Recommendations"),
      ),
    );
  }
}

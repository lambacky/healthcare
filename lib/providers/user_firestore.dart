import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserFireStore extends ChangeNotifier {
  late Map<String, dynamic> _userData = {};

  Map<String, dynamic> get userData => _userData;

  void fetchData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (snapshot.exists) {
      _userData = snapshot.data() as Map<String, dynamic>;
    }
    notifyListeners();
  }

  void updateData(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(data);
    fetchData();
  }
}

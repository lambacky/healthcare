import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseService {
  final fireStore = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid);
  final storageReference = FirebaseStorage.instance.ref();
  Future<Map<String, dynamic>?> fetchData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await fireStore.get();
    if (snapshot.exists) {
      return snapshot.data()!;
    }
    return null;
  }

  Future<void> updateData(Map<String, dynamic> data) async {
    fireStore.update(data);
  }

  Future<String> uploadAndGetURL(String path, Uint8List snapshot) async {
    await storageReference.child(path).putData(snapshot);
    String url = await storageReference.child(path).getDownloadURL();
    return url;
  }
}

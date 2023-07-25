import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireBaseService {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  final _storageReference = FirebaseStorage.instance.ref();

  Future<Map<String, dynamic>?> fetchData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _fireStore.collection("users").doc(_auth.currentUser?.uid).get();
    if (snapshot.exists) {
      return snapshot.data()!;
    }
    return null;
  }

  Future<void> updateData(Map<String, dynamic> data) async {
    _fireStore.collection("users").doc(_auth.currentUser?.uid).update(data);
  }

  Future<void> setUser(Map<String, dynamic> data, String id) async {
    _fireStore.collection("users").doc(id).set(data);
  }

  Future<String> uploadAndGetURL(String path, Uint8List snapshot) async {
    await _storageReference.child(path).putData(snapshot);
    String url = await _storageReference.child(path).getDownloadURL();
    return url;
  }

  Future<void> deleteImage(String path) async {
    await _storageReference.child(path).delete();
  }

  Future<String> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "successful";
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "successful";
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "successful";
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return "successful";
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
  }
}

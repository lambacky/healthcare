import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare/models/physical_status.dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/pages/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/user_firestore.dart';
import '../bmi/bmi_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _userInfo;
  PhysicalStatus? _physicStat;

  void openSignOutDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sign out of this app?'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pop(context))
                  .catchError((e) {
                Fluttertoast.showToast(msg: "Sign out error");
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My profile'),
      ),
      body: Consumer<UserFireStore>(builder: (context, userFireStore, child) {
        if (userFireStore.userData.isNotEmpty) {
          _userInfo = UserModel.fromJson(userFireStore.userData);
          if (userFireStore.userData.containsKey('physicStat') &&
              userFireStore.userData['physicStat'] != null) {
            _physicStat =
                PhysicalStatus.fromJson(userFireStore.userData['physicStat']);
          }
        }
        return SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 15),
            const Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 5),
                    Text('Edit profile',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 0, 30),
              decoration: const BoxDecoration(
                  border: Border(
                      top:
                          BorderSide(color: Color.fromARGB(255, 190, 190, 190)),
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 190, 190, 190)))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Info',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(height: 15),
                  Row(children: [
                    const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('First Name',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 120, 120, 120))),
                          SizedBox(height: 10),
                          Text('Last Name',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 120, 120, 120))),
                          SizedBox(height: 10),
                          Text('Email',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 120, 120, 120)))
                        ]),
                    const SizedBox(width: 30),
                    _userInfo == null
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(_userInfo!.firstName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 10),
                                Text(_userInfo!.lastName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 10),
                                Text(_userInfo!.email,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ]),
                  ]),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(30, 20, 0, 30),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 190, 190, 190)))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Physical Status',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(height: _physicStat == null ? 0 : 15),
                  _physicStat == null
                      ? const SizedBox()
                      : Row(children: [
                          const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Height',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(
                                            255, 120, 120, 120))),
                                SizedBox(height: 10),
                                Text('Weight',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(
                                            255, 120, 120, 120))),
                                SizedBox(height: 10),
                                Text('BMI',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(
                                            255, 120, 120, 120))),
                                SizedBox(height: 10),
                                Text('Status',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 120, 120, 120)))
                              ]),
                          const SizedBox(width: 60),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_physicStat!.height.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 10),
                                Text(_physicStat!.weigth.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 10),
                                Text(_physicStat!.bmi.toStringAsFixed(1),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 10),
                                Text(_physicStat!.status,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ]),
                        ]),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BMIScreen()));
                    },
                    child: const Text(
                      'Measure again?',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: openSignOutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Sign Out", style: TextStyle(fontSize: 20))),
            const SizedBox(height: 20),
          ]),
        );
      }),
    );
  }
}

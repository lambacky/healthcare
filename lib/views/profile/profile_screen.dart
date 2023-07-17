import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare/view-models/user_view_model.dart';
import 'package:provider/provider.dart';
import '../../components/submit_button.dart';
import '../../view-models/physical_status_view_model.dart';
import '../bmi/bmi_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void deletePhysicStat() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete your physical status ?'),
        content: const Text('The data will be removed permanently'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<PhysicStatViewModel>().deletePhysicStat();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void editProfile() {
    final userViewModel = context.read<UserViewModel>();
    userViewModel.setNewUserModel();
    final firstNameController =
        TextEditingController(text: userViewModel.newUserModel.firstName);
    final lastNameController =
        TextEditingController(text: userViewModel.newUserModel.lastName);
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          final userViewModel = context.watch<UserViewModel>();
          return Dialog(
            child: Container(
              height: 260,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("First Name",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: firstNameController,
                    onChanged: (value) {
                      userViewModel.setFirstName(value.toString());
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Last Name",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: lastNameController,
                    onChanged: (value) {
                      userViewModel.setLastName(value.toString());
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                      alignment: Alignment.center,
                      child: SubmitButton(
                          text: 'Save new profile',
                          onPressed: !userViewModel.isValid
                              ? null
                              : () {
                                  userViewModel.updateUserModel();
                                  Navigator.pop(context);
                                })),
                ],
              ),
            ),
          );
        });
  }

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
    final physicStatViewModel = context.watch<PhysicStatViewModel>();
    final userModel = context.watch<UserViewModel>().userModel;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My profile'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 15),
          const Icon(
            Icons.account_circle,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          const Text('My Account',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 20, 0, 30),
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color.fromARGB(255, 190, 190, 190)),
                    bottom:
                        BorderSide(color: Color.fromARGB(255, 190, 190, 190)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Personal Info',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: editProfile,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 5),
                            Text('Edit',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ],
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
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userModel.firstName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        Text(userModel.lastName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        Text(userModel.email,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
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
                    bottom:
                        BorderSide(color: Color.fromARGB(255, 190, 190, 190)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Physical Status',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(width: 15),
                    !physicStatViewModel.isSaved
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: deletePhysicStat,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 90,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 5),
                                  Text('Delete',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: !physicStatViewModel.isSaved ? 0 : 15),
                !physicStatViewModel.isSaved
                    ? const SizedBox()
                    : Row(children: [
                        const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Height',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Color.fromARGB(255, 120, 120, 120))),
                              SizedBox(height: 10),
                              Text('Weight',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Color.fromARGB(255, 120, 120, 120))),
                              SizedBox(height: 10),
                              Text('BMI',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Color.fromARGB(255, 120, 120, 120))),
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
                              Text(
                                  '${physicStatViewModel.physicStat!.height.toString()} cm',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 10),
                              Text(
                                  '${physicStatViewModel.physicStat!.height.toString()} kg',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 10),
                              Text(
                                  physicStatViewModel.physicStat!.bmi
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 10),
                              Text(physicStatViewModel.physicStat!.status,
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
                  child: Text(
                    !physicStatViewModel.isSaved
                        ? 'Measure your body?'
                        : 'Measure again?',
                    style: const TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SubmitButton(text: 'Sign Out', onPressed: openSignOutDialog),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

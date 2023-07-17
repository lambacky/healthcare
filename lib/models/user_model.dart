import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  String uid;
  String email;
  String firstName;
  String lastName;

  UserModel(
      {required this.uid,
      required this.email,
      required this.firstName,
      required this.lastName});

  // receive data from server
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  // send data to server
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  UserModel clone() {
    return UserModel(
        uid: uid, email: email, firstName: firstName, lastName: lastName);
  }

  @override
  List<Object?> get props => [firstName, lastName];

  void setFirstName(String name) {
    firstName = name;
  }

  void setLastName(String name) {
    lastName = name;
  }
}

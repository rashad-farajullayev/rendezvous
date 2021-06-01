import 'package:flutter/material.dart';

class User {
  int id;
  String userName;
  String password;
  String firstName;
  String lastName;
  String bio;
  String email;
  String phoneNumber;
  DateTime birthDate;
  DateTime lastLoginDate;

  User({
    @required this.id,
    @required this.userName,
    @required password,
    this.firstName,
    this.lastName,
    this.bio,
    this.email,
    this.phoneNumber,
    this.birthDate,
    this.lastLoginDate,
  });
}

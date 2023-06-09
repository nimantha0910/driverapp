import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users {
  late String id;
  late String email;
  late String name;
  late String phone;

  Users(
      {required this.id,
      required this.email,
      required this.name,
      required this.phone});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key!;
    email = (dataSnapshot.child("email").value.toString());
    name = (dataSnapshot.child("name").value.toString());
    phone = (dataSnapshot.child("phone").value.toString());
  }
}

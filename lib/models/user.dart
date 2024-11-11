// models/user.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final String role;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      role: data['role'],
    );
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
    );
  }
}

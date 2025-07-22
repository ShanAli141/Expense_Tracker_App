import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final User user;
  const UserInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Name: ${user.displayName ?? 'No name set'}',
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          'Email: ${user.email ?? 'No email'}',
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ],
    );
  }
}

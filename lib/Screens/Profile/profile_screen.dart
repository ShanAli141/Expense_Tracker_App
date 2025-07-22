import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/Screens/Profile/user_info_section.dart';
import 'package:first_project/Screens/Profile/touch_id_switch.dart';
import 'package:first_project/Screens/Profile/credit_info_tile.dart';
import 'package:first_project/Screens/Profile/profile_options.dart';
import 'package:first_project/Screens/Profile/contact_about_section.dart';
import 'package:first_project/Screens/Profile/logout_button.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: user == null
          ? const Center(child: Text('No user found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Color.fromARGB(255, 71, 112, 189),
                  ),
                  const SizedBox(height: 20),
                  UserInfoSection(user: user),
                  const SizedBox(height: 20),
                  const TouchIdSwitch(),
                  const CreditInfoTile(),
                  const ProfileOptions(),
                  const ContactAboutSection(),
                  const SizedBox(height: 20),
                  const LogoutButton(),
                ],
              ),
            ),
    );
  }
}

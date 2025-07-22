import 'package:first_project/Screens/Profile/change_password.dart';
import 'package:first_project/Screens/Profile/marketing_pref.dart';
import 'package:first_project/Screens/Profile/refer_friend.dart';
import 'package:first_project/Screens/Profile/remittance_certificate.dart';
import 'package:first_project/Screens/Profile/reward_screen.dart';
import 'package:flutter/material.dart';
import 'profile_option_tile.dart';
import 'package:first_project/Screens/Profile/verification_screen.dart';
import 'package:first_project/Screens/Profile/language_screen.dart';
import 'package:first_project/Screens/Profile/support_screen.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(
        Icons.person,
        color: Color.fromARGB(255, 71, 112, 189),
      ),
      title: const Text('Profile', style: TextStyle(color: Colors.black)),
      collapsedIconColor: const Color.fromARGB(255, 71, 112, 189),
      children: [
        ProfileOptionTile(
          icon: Icons.verified_user,
          label: 'Document Verification',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerificationScreen()),
            );
          },
        ),
        ProfileOptionTile(
          icon: Icons.share,
          label: 'Refer a Friend',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReferFriendScreen()),
            );
          },
        ),
        ProfileOptionTile(
          icon: Icons.card_giftcard,
          label: 'My Rewards',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RewardsScreen()),
            );
          },
        ),
        ProfileOptionTile(
          icon: Icons.lock,
          label: 'Change Password',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
            );
          },
        ),
        ProfileOptionTile(
          icon: Icons.receipt,
          label: 'Remittance Certificate',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RemittanceCertificateScreen(),
              ),
            );
          },
        ),
        ProfileOptionTile(
          icon: Icons.language,
          label: 'Language',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LanguageScreen()),
            );
          },
        ),
        ProfileOptionTile(
          icon: Icons.settings,
          label: 'Marketing Preferences',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MarketingPreferencesScreen(),
              ),
            );
          },
        ),
        ProfileOptionTile(
          icon: Icons.support,
          label: 'Support',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SupportScreen()),
            );
          },
        ),
      ],
    );
  }
}

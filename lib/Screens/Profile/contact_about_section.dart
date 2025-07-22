import 'package:first_project/Screens/about_us.dart';
import 'package:flutter/material.dart';

class ContactAboutSection extends StatelessWidget {
  const ContactAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.store,
        color: Color.fromARGB(255, 71, 112, 189),
      ),
      subtitle: Column(
        children: [
          const ListTile(
            title: Text('Contact Us', style: TextStyle(color: Colors.black)),
          ),
          ListTile(
            title: const Text(
              'About Us',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

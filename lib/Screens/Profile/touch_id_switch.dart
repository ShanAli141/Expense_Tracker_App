import 'package:flutter/material.dart';

class TouchIdSwitch extends StatelessWidget {
  const TouchIdSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.verified_user,
        color: Color.fromARGB(255, 228, 165, 72),
      ),
      title: const Text('Login with Touch Id'),
      trailing: Switch(
        value: false,
        onChanged: (_) {},
        activeColor: Color.fromARGB(255, 228, 165, 72),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TouchIdSwitch extends StatelessWidget {
  const TouchIdSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.verified_user,
        color: Color.fromARGB(255, 71, 112, 189),
      ),
      title: const Text(
        'Login with Touch Id',
        style: TextStyle(color: Colors.black),
      ),
      trailing: Switch(
        value: false,
        onChanged: (_) {},
        activeColor: const Color.fromARGB(255, 71, 112, 189),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // <-- Fix: Proper type and field declaration

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap, // <-- Optional or required (your choice)
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 71, 112, 189)),
      title: Text(label, style: const TextStyle(color: Colors.black)),
      onTap: onTap, // <-- Fix: Apply onTap here
    );
  }
}

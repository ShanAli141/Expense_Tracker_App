import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  final Size preferredSize;

  const ChangePasswordScreen({super.key})
    : preferredSize = const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('ChangePasswordScreen'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      automaticallyImplyLeading: true,
    );
  }
}

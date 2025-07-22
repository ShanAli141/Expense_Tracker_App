import 'package:flutter/material.dart';

class RemittanceCertificateScreen extends StatelessWidget {
  const RemittanceCertificateScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('RemittanceCertificateScreen'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      automaticallyImplyLeading: true,
    );
  }
}

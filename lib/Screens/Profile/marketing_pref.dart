import 'package:flutter/material.dart';

class MarketingPreferencesScreen extends StatelessWidget {
  const MarketingPreferencesScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('MarketingPreferencesScreen'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      automaticallyImplyLeading: true,
    );
  }
}

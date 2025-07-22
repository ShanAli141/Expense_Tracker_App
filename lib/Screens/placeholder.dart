import 'package:first_project/Notification%20System/notification_system.dart';
import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          NotificationHelper.showNotification(
            'Budget Warning!',
            'You’ve used 80% of your budget!',
          );
        },
        child: Text('Show Notification'),
      ),
    );
  }
}

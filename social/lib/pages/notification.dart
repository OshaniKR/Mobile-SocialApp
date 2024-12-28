import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Notification 1'),
            onTap: () {
              // Handle Notification 1
            },
          ),
          ListTile(
            title: const Text('Notification 2'),
            onTap: () {
              // Handle Notification 2
            },
          ),
          // Add more notifications here
        ],
      ),
    );
  }
}

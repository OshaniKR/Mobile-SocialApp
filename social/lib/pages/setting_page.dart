import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Account Settings'),
            onTap: () {
              // Navigate to Account Settings Page
            },
          ),
          ListTile(
            title: const Text('Notification Settings'),
            onTap: () {
              // Navigate to Notification Settings Page
            },
          ),
          ListTile(
            title: const Text('Privacy Settings'),
            onTap: () {
              // Navigate to Privacy Settings Page
            },
          ),
          ListTile(
            title: const Text('Help & Support'),
            onTap: () {
              // Navigate to Help & Support Page
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              // Navigate to About Page
            },
          ),
        ],
      ),
    );
  }
}

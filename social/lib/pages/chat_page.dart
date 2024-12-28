import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Conversation 1'),
            onTap: () {
              // Navigate to Conversation 1
            },
          ),
          ListTile(
            title: const Text('Conversation 2'),
            onTap: () {
              // Navigate to Conversation 2
            },
          ),
          // Add more conversations here
        ],
      ),
    );
  }
}

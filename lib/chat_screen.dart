import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String userId;

  const ChatScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // You can use the userId here to fetch user details and display in AppBar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'), // Placeholder title
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Placeholder number of messages
              itemBuilder: (context, index) {
                // Placeholder message widget
                return ListTile(
                  title: Text('Message ${index + 1}'),
                );
              },
            ),
          ),
          const Divider(height: 1.0), // Visual separation
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // TODO: Implement send message functionality
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
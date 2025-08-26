import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.go('/login'); // Navigate back to login after signing out
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome Home!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/reminders');
              },
              child: const Text('Reminder Settings'),
            ),
            const SizedBox(height: 10), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                context.go('/awareness'); // Navigate to awareness screen
              },
              child: const Text('Awareness')
            ),
          ],
 ),
      ),
    );
  }
}
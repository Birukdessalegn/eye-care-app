import 'package:flutter/material.dart';

class AwarenessScreen extends StatelessWidget {
  const AwarenessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Health Awareness'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'Learn about maintaining healthy eyes!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Placeholder content for eye health awareness tips and information.',
                textAlign: TextAlign.center,
              ),
              // Add more awareness content here
            ],
          ),
        ),
      ),
    );
  }
}
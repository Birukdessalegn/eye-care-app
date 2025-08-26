import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Exercises'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Here you can find eye exercises.',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Text(
                'Exercise 1: Palming\nExercise 2: Blinking\nExercise 3: Zooming',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              // Add more exercise placeholders or widgets here
            ],
          ),
        ),
      ),
    );
  }
}
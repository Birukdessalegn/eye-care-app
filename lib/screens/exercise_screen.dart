import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/exercise_model.dart';
import '../widgets/exercise_card.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final List<Exercise> exercises = [
    Exercise(
      id: '1',
      title: 'Palming',
      description: 'Rub your hands together to generate heat, then gently cup your palms over your closed eyes without applying pressure. Relax and breathe deeply.',
      duration: '2 minutes',
      benefits: 'Reduces eye strain, relaxes eye muscles',
      steps: [
        'Sit comfortably and relax your shoulders',
        'Rub your palms together vigorously for 15-20 seconds',
        'Cup your palms gently over your closed eyes',
        'Breathe deeply and relax for 1-2 minutes',
        'Slowly remove your hands and blink several times'
      ],
    ),
    Exercise(
      id: '2',
      title: 'Blinking',
      description: 'Sit comfortably with your eyes open. Blink regularly to moisten your eyes and prevent dryness.',
      duration: '2 minutes',
      benefits: 'Prevents dry eyes, refreshes eyes',
      steps: [
        'Sit straight with relaxed shoulders',
        'Blink every 3-4 seconds for 30 seconds',
        'Close your eyes tightly for 2 seconds, then open wide',
        'Repeat this sequence 10 times',
        'Finish with gentle eye massage'
      ],
    ),
    Exercise(
      id: '3',
      title: 'Zooming',
      description: 'Focus on objects at different distances to improve focus flexibility.',
      duration: '3-5 minutes',
      benefits: 'Improves focus flexibility, reduces strain',
      steps: [
        'Hold your thumb 10 inches from your face',
        'Focus on your thumb for 10-15 seconds',
        'Shift focus to an object 10-20 feet away',
        'Hold for 10-15 seconds',
        'Repeat 10 times'
      ],
    ),
    Exercise(
      id: '4',
      title: 'Figure Eight',
      description: 'Trace imaginary figures to improve eye mobility.',
      duration: '4 minutes',
      benefits: 'Improves eye mobility, reduces stiffness',
      steps: [
        'Imagine a giant figure eight 10 feet in front of you',
        'Slowly trace the figure with your eyes',
        'Complete 10 circles in one direction',
        'Reverse direction and complete 10 more circles',
        'Blink frequently throughout the exercise'
      ],
    ),
    Exercise(
      id: '5',
      title: 'Near and Far Focus',
      description: 'Alternate focus between near and far objects to strengthen eye muscles.',
      duration: '3 minutes',
      benefits: 'Strengthens eye muscles, improves focus',
      steps: [
        'Hold a pen at arm\'s length',
        'Focus on the tip of the pen',
        'Slowly bring the pen closer to your nose',
        'Stop when the pen becomes blurry',
        'Slowly move it back to arm\'s length',
        'Repeat 10 times'
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Exercises'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Regular eye exercises can help reduce digital eye strain and improve overall eye health. Try these exercises daily for best results.',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return ExerciseCard(exercise: exercises[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
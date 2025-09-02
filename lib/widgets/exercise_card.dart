import 'package:flutter/material.dart';

import '../models/exercise_model.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Text(
                  exercise.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              exercise.description,
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            
            // Steps section
            if (exercise.steps.isNotEmpty) ...[
              const Text(
                'Steps:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              ...exercise.steps.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key + 1}. ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(entry.value),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],
            
            Row(
              children: [
                const Icon(Icons.timer, size: 18, color: Colors.blue),
                const SizedBox(width: 6),
                Text(
                  'Duration: ${exercise.duration}',
                  style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.health_and_safety, size: 18, color: Colors.green),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Benefits: ${exercise.benefits}',
                    style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality to start exercise with timer
                  _showExerciseInstructions(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Start Exercise'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExerciseInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exercise.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(exercise.description),
                const SizedBox(height: 16),
                if (exercise.steps.isNotEmpty) ...[
                  const Text(
                    'Steps:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...exercise.steps.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${entry.key + 1}. '),
                          Expanded(child: Text(entry.value)),
                        ],
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 16),
                Text('Duration: ${exercise.duration}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Start timer functionality would go here
              },
              child: const Text('Start Timer'),
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AwarenessScreen extends StatelessWidget {
  const AwarenessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eye Health Awareness')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(
            'Computer Vision Syndrome (CVS)',
            'CVS is a condition resulting from focusing the eyes on a computer or other display device for prolonged, uninterrupted periods of time. Symptoms include headaches, blurred vision, neck pain, redness in the eyes, fatigue, eye strain, dry eyes, irritated eyes, double vision, and difficulty refocusing the eyes.',
            Icons.computer,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Prevention Tips',
            '• Follow the 20-20-20 rule: Every 20 minutes, look at something 20 feet away for 20 seconds\n• Ensure proper lighting in your workspace\n• Blink frequently to moisten your eyes\n• Adjust your screen brightness and contrast\n• Use artificial tears if your eyes feel dry\n• Position your screen at eye level and at arm\'s length distance',
            Icons.lightbulb_outline,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Healthy Diet for Eyes',
            '• Eat plenty of dark leafy greens like spinach and kale\n• Include omega-3 fatty acids found in fish\n• Consume foods rich in vitamins A, C, and E\n• Eat eggs, nuts, and beans for zinc\n• Stay hydrated by drinking plenty of water',
            Icons.restaurant,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'When to See a Doctor',
            'Consult an eye care professional if you experience:\n• Persistent eye discomfort\n• Significant changes in your vision\n• Eye pain\n• Double vision\n• Dry eyes that don\'t improve with drops\n• Frequent headaches related to visual tasks',
            Icons.local_hospital,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Set this index based on the current screen
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/'); // Home
              break;
            case 1:
              context.go('/questions'); // Chat/Questions
              break;
            case 2:
              context.go('/profile'); // Profile/Settings
              break;
          }
        },
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

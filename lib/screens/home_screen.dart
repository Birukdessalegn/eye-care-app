import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              // GoRouter's refreshListenable will handle the navigation
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        children: [
          // Banner with gradient overlay
          Stack(
            children: [
              Image.asset(
                'assets/images/banner.jpg',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                left: 24,
                bottom: 24,
                child: Text(
                  'Welcome to OcuCare!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Feature Cards
          _FeatureCard(
            icon: Icons.visibility,
            label: 'Eye Exercises',
            subtitle: 'Daily routines for healthy eyes',
            onTap: () => context.go('/exercises'),
          ),
          _FeatureCard(
            icon: Icons.info_outline,
            label: 'Awareness',
            subtitle: 'Learn about eye care',
            onTap: () => context.go('/awareness'),
          ),
          _FeatureCard(
            icon: Icons.notifications_active,
            label: 'Reminders',
            subtitle: 'Set up healthy habits',
            onTap: () => context.go('/reminders'),
          ),
          _FeatureCard(
            icon: Icons.local_hospital,
            label: 'Clinics',
            subtitle: 'Find nearby clinics',
            onTap: () => context.go('/clinics'),
          ),
        ],
      ),
      // Bottom navigation bar
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
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo, size: 32),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.indigo),
        onTap: onTap,
      ),
    );
  }
}

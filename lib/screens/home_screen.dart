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
              await authService.signOut();
              // GoRouter's refreshListenable will handle the navigation
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              icon: Icons.visibility,
              label: 'Exercises',
              onTap: () => context.go('/exercises'),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.lightbulb_outline,
              label: 'Awareness',
              onTap: () => context.go('/awareness'),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.alarm,
              label: 'Reminders',
              onTap: () => context.go('/reminders'),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.chat_bubble_outline,
              label: 'Chat',
              onTap: () => context.go('/chat'),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.local_hospital,
              label: 'Clinics',
              onTap: () => context.go('/clinics'),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.person_outline,
              label: 'Profile',
              onTap: () => context.go('/profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

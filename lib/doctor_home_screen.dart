import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // TODO: Implement notification handling
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go('/login'); // Redirect to login after logout
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Header / Top Section
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Dr. John Doe', // Placeholder name
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Add more quick stats here if needed
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 2. Patient Management
            const Text(
              'Patient Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  final patientId = 'patient_id_${index + 1}';
                  return InkWell(
                    onTap: () {
                      context.push('/chat/$patientId');
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Patient ${index + 1}'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Patient...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 3. Patient Records / History
            const Text(
              'Patient Records / History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              color: Colors.grey[200],
              child: const Center(
                child: Text('Placeholder: Recent Patients / History Shortcuts'),
              ),
            ),
            const SizedBox(height: 24),
            // 4. Diagnostic Tools & Quick Actions
            const Text(
              'Diagnostic Tools & Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              color: Colors.grey[200],
              child: const Center(
                child: Text('Placeholder: Diagnostic Tools / Quick Actions'),
              ),
            ),
            const SizedBox(height: 24),
            // 5. Notifications / Alerts
            const Text(
              'Notifications / Alerts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              color: Colors.grey[200],
              child: const Center(
                child: Text('Placeholder: Notifications / Alerts'),
              ),
            ),
            const SizedBox(height: 24),
            // Analytics / Insights
            const Text(
              'Analytics / Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              color: Colors.grey[200],
              child: const Center(child: Text('Placeholder: Analytics')),
            ),
            const SizedBox(height: 24),
            // Settings / Profile Access
            const Text(
              'Settings / Profile Access',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              color: Colors.grey[200],
              child: const Center(
                child: Text('Placeholder: Settings / Profile Access'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Home',
        ), // You might want a more dynamic title later
        actions: <Widget>[
          // Notifications Icon in AppBar
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
            ), // Placeholder notification icon
            onPressed: () {
              // TODO: Implement notification handling
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: () async {
              // TODO: Implement Logout
              await FirebaseAuth.instance.signOut();
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
                // Doctor's Profile Picture
                CircleAvatar(
                  radius: 30,
                  // Placeholder image or icon
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                // Doctor's Name & Quick Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Text('Error loading name');
                          }
                          if (snapshot.hasData && snapshot.data!.exists) {
                            final name = snapshot.data!['name'];
                            return Text(
                              'Dr. $name',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return const Text(
                            'Dr. Unknown',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      // Add more quick stats here
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24), // Spacing after Header
            // 2. Patient Management
            const Text(
              'Patient Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ), // Closing parenthesis for Text widget
            // Removed Expanded and added SizedBox for constrained height
            SizedBox(
              height: 300, // Fixed height for the patient list
              child: ListView.builder(
                itemCount: 10, // Number of placeholder patients
                itemBuilder: (context, index) {
                  final patientId =
                      'patient_id_${index + 1}'; // Placeholder patient ID
                  return InkWell(
                    onTap: () {
                      // Navigate to the chat screen, passing the patient ID
                      context.push('/chat/$patientId');
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Patient ${index + 1}',
                        ), // Placeholder patient name
                      ),
                    ),
                  );
                },
              ),
            ), // Closing parenthesis for SizedBox
            const SizedBox(height: 16),
            // Placeholder for Search Patient
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Patient...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24), // Spacing after Patient Management
            // 3. Patient Records / History
            const Text(
              'Patient Records / History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Placeholder for Recent Patients and Medical History Shortcuts
            Container(
              height: 100, // Placeholder height
              color: Colors.grey[200],
              child: const Center(
                child: Text('Placeholder: Recent Patients / History Shortcuts'),
              ),
            ),
            const SizedBox(height: 24), // Spacing after Patient Records
            // 4. Diagnostic Tools & Quick Actions
            const Text(
              'Diagnostic Tools & Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Placeholder for Diagnostic Tools Shortcuts and Quick Actions
            Container(
              height: 100, // Placeholder height
              color: Colors.grey[200],
              child: const Center(
                child: Text('Placeholder: Diagnostic Tools / Quick Actions'),
              ),
            ),
            const SizedBox(height: 24), // Spacing after Diagnostic Tools
            // 5. Notifications / Alerts
            const Text(
              'Notifications / Alerts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Placeholder for Notifications/Alerts list or section
            Container(
              height: 100, // Placeholder height
              color: Colors.grey[200],
              child: const Center(
                child: Text('Placeholder: Notifications / Alerts'),
              ),
            ),
            // Add more sections (Analytics, Settings) as placeholders if needed
            const SizedBox(
              height: 24,
            ), // Spacing before potential next sections
            // Placeholder for Analytics
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
            // Placeholder for Settings / Profile Access
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

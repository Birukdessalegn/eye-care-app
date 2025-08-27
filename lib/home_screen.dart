import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Modified AppBar for Patient Home Header
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Loading...'),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.error, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Text('Error loading user data'),
                ],
              );
            }
            if (snapshot.hasData && snapshot.data!.exists) {
              final userData = snapshot.data!.data() as Map<String, dynamic>?;
              final userName =
                  userData?['name'] ??
                  'Patient'; // Default to 'Patient' if name is missing
              return Row(
                children: [
                  // Placeholder for profile picture
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Hi, $userName'), // Display fetched name
                ],
              );
            }
            return const Text('Ocu-Care'); // Fallback if user data not found
          },
        ),
        actions: [
          IconButton(
            // Placeholder for the sun/brightness icon from the image
            icon: const Icon(Icons.wb_sunny_outlined),
            onPressed: () {
              // TODO: Implement brightness adjustment or theme change
            },
          ),
          IconButton(
            // Notifications Icon in AppBar for Patient
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
              // Keep logout functionality
              await FirebaseAuth.instance.signOut();
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView to prevent overflow
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0), // Apply padding here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Health Summary (Placeholder)
                  const Text(
                    'Last Checkup: [Date]', // Placeholder Quick Stat
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  // Add more quick health stats here
                ],
              ),
            ),
            // Reminders Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reminders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Placeholder for reminder count and arrows
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        /* TODO */
                      },
                    ),
                    const Text('0/0'), // Placeholder reminder count
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        /* TODO */
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              // Placeholder Card for adding reminders
              child: InkWell(
                onTap: () {
                  // TODO: Navigate to add reminder screen
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add Reminder'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24), // Spacing between sections
            // Tools Section
            const Text(
              'Tools',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView.count(
              // Using GridView for the tools section
              shrinkWrap: true, // Required in a SingleChildScrollView
              physics:
                  const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 16.0, // Spacing between columns
              mainAxisSpacing: 16.0, // Spacing between rows
              children: <Widget>[
                Card(
                  // Placeholder Card for Self Examine
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to self examine screen
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 40,
                        ), // Placeholder icon
                        SizedBox(height: 8),
                        Text('Self Examine'),
                      ],
                    ),
                  ),
                ),
                Card(
                  // Placeholder Card for Clinics
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to clinics screen
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_hospital_outlined,
                          size: 40,
                        ), // Placeholder icon
                        SizedBox(height: 8),
                        Text('Clinics'),
                      ],
                    ),
                  ),
                ),
                Card(
                  // Placeholder Card for Eye Exercises
                  child: InkWell(
                    onTap: () {
                      context.go('/exercises'); // Example navigation
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center_outlined,
                          size: 40,
                        ), // Placeholder icon
                        SizedBox(height: 8),
                        Text('Eye Exercises'),
                      ],
                    ),
                  ),
                ),
                Card(
                  // Placeholder Card for My Record
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to my record screen
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 40,
                        ), // Placeholder icon
                        SizedBox(height: 8),
                        Text('My Record'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Placeholder for the bottom content (glasses images)
            const SizedBox(height: 24), // Spacing after Tools section
            Container(
              height: 150, // Placeholder height
              color: Colors.grey[300], // Placeholder color
              child: Center(
                child: Text('Placeholder for bottom content (glasses images)'),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book), // Placeholder icon for the book
            label: 'Learn', // Placeholder label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store), // Placeholder icon for the store
            label: 'Shop', // Placeholder label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Placeholder icon for the person
            label: 'Profile', // Placeholder label
          ),
        ],
        currentIndex: 0, // Highlight the Home item
        unselectedItemColor: Colors.grey, // Color for unselected items
        selectedItemColor: Colors.blue, // Color for selected item
        onTap: (index) {
          // Corrected closing parenthesis for onTap
          // TODO: Implement navigation for bottom navigation bar items
          switch (index) {
            case 0:
            case 2:
              // Navigate to Shop screen (placeholder)
              // context.go('/shop');
              break;
            case 3:
              // Navigate to Profile screen (placeholder)
              // context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}

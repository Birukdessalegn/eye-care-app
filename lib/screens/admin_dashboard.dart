import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Future<void> _addSampleClinics(BuildContext context) async {
    final clinics = [
      {
        'name': 'Addis Ababa Eye Hospital',
        'address': 'Bole Road, Addis Ababa',
        'phone': '+251 11 555 1234',
        'hours': 'Mon-Fri: 8am-6pm, Sat: 9am-1pm',
        'services': 'General eye care, Cataract surgery, Glaucoma treatment'
      },
      {
        'name': 'St. Paul\'s Hospital Millennium Medical College',
        'address': 'Gurd Shola, Addis Ababa',
        'phone': '+251 11 553 4444',
        'hours': '24/7 Emergency services',
        'services': 'Comprehensive eye care, Emergency services, Specialist consultations'
      },
      {
        'name': 'Myungsung Christian Medical Center',
        'address': 'Kotebe, Addis Ababa',
        'phone': '+251 11 629 1111',
        'hours': 'Mon-Fri: 8:30am-5pm',
        'services': 'Eye examinations, Surgical procedures, Pediatric ophthalmology'
      },
    ];

    final batch = FirebaseFirestore.instance.batch();
    
    for (var clinic in clinics) {
      final docRef = FirebaseFirestore.instance.collection('clinics').doc();
      batch.set(docRef, clinic);
    }
    
    await batch.commit();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sample clinics added successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addSampleClinics(context),
            tooltip: 'Add Sample Clinics',
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Users', icon: Icon(Icons.people)),
                Tab(text: 'Clinics', icon: Icon(Icons.local_hospital)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Users Tab
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      final users = snapshot.data!.docs;
                      
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index].data() as Map<String, dynamic>;
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(user['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['email']),
                                  Text('Role: ${user['role'] ?? 'user'}'),
                                ],
                              ),
                              trailing: Chip(
                                label: Text(user['role'] ?? 'user'),
                                backgroundColor: user['role'] == 'admin' ? Colors.blue : Colors.grey,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  
                  // Clinics Tab
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('clinics').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      final clinics = snapshot.data!.docs;
                      
                      return ListView.builder(
                        itemCount: clinics.length,
                        itemBuilder: (context, index) {
                          final clinic = clinics[index].data() as Map<String, dynamic>;
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(clinic['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(clinic['address']),
                                  Text(clinic['phone']),
                                  Text(clinic['hours'] ?? ''),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  clinics[index].reference.delete();
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicsScreen extends StatelessWidget {
  const ClinicsScreen({super.key});

  Future<void> _launchMaps(String address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Clinics'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clinics').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final clinics = snapshot.data!.docs;
          
          if (clinics.isEmpty) {
            return const Center(
              child: Text(
                'No clinics available. Please check back later.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          
          return ListView.builder(
            itemCount: clinics.length,
            itemBuilder: (context, index) {
              final clinic = clinics[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        clinic['address'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone, color: Colors.blue),
                            onPressed: () => _makePhoneCall(clinic['phone']),
                          ),
                          Text(clinic['phone']),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.map, color: Colors.blue),
                            onPressed: () => _launchMaps(clinic['address']),
                          ),
                        ],
                      ),
                      if (clinic['hours'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Hours: ${clinic['hours']}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                      if (clinic['services'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Services: ${clinic['services']}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
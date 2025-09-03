
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Placeholder model for a clinic
class Clinic {
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;

  // Adding the 'const' keyword to the constructor
  const Clinic({
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}

class ClinicsScreen extends StatelessWidget {
  const ClinicsScreen({super.key});

  // This list requires the Clinic constructor to be const
  final List<Clinic> _clinics = const [
    Clinic(
      name: 'Global Eye & Vision Center',
      address: '123 Vision St, Optic City, 12345',
      phone: '555-123-4567',
      latitude: 34.0522,
      longitude: -118.2437,
    ),
    Clinic(
      name: 'Lens & Frame Specialists',
      address: '456 Focus Ave, Iris Town, 67890',
      phone: '555-987-6543',
      latitude: 40.7128,
      longitude: -74.0060,
    ),
    Clinic(
      name: 'Retina Health Institute',
      address: '789 Pupil Blvd, Cornea County, 54321',
      phone: '555-555-5555',
      latitude: 41.8781,
      longitude: -87.6298,
    ),
  ];

  Future<void> _launchMaps(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Clinics'),
      ),
      body: ListView.builder(
        itemCount: _clinics.length,
        itemBuilder: (context, index) {
          final clinic = _clinics[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.blue, size: 40),
              title: Text(clinic.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(clinic.address),
              trailing: IconButton(
                icon: const Icon(Icons.map_outlined, color: Colors.blue),
                tooltip: 'Show on map',
                onPressed: () => _launchMaps(clinic.latitude, clinic.longitude),
              ),
              onTap: () => _launchMaps(clinic.latitude, clinic.longitude),
            ),
          );
        },
      ),
    );
  }
}

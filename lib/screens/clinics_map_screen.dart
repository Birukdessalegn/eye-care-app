import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class ClinicsMapScreen extends StatefulWidget {
  const ClinicsMapScreen({Key? key}) : super(key: key);
  @override
  State<ClinicsMapScreen> createState() => _ClinicsMapScreenState();
}

class _ClinicsMapScreenState extends State<ClinicsMapScreen> {
  LatLng? userLocation;
  String? errorMsg;
  bool _loading = false;

  // Example clinics (replace with real data or fetch from API)
  final List<LatLng> clinics = [LatLng(9.03, 38.74), LatLng(9.04, 38.75)];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() {
      _loading = true;
      errorMsg = null;
    });
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMsg = 'Location permissions are denied.';
            _loading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMsg = 'Location permissions are permanently denied.';
          _loading = false;
        });
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to get location: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Eye Clinics'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 18),
                    Text(
                      errorMsg!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: _determinePosition,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : userLocation == null
          ? const Center(child: Text('Location not available.'))
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(center: userLocation, zoom: 14.0),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: userLocation!,
                          width: 60,
                          height: 60,
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_pin_circle,
                                color: Colors.blue,
                                size: 40,
                              ),
                              const Text(
                                'You',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...clinics.map(
                          (clinic) => Marker(
                            point: clinic,
                            width: 56,
                            height: 56,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.local_hospital,
                                  color: Colors.red,
                                  size: 36,
                                ),
                                const Text(
                                  'Clinic',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    backgroundColor: Colors.indigo,
                    onPressed: _determinePosition,
                    child: const Icon(Icons.my_location, color: Colors.white),
                    tooltip: 'Recenter to your location',
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Card(
                    color: Colors.white.withOpacity(0.95),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          const Text('You', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 18),
                          Icon(
                            Icons.local_hospital,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          const Text('Clinic', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

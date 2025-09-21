import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class ExerciseProcedureScreen extends StatefulWidget {
  final String exerciseId;
  final String exerciseTitle;
  final String imageUrl; // <-- Add this

  const ExerciseProcedureScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseTitle,
    required this.imageUrl, // <-- Add this
  });

  @override
  State<ExerciseProcedureScreen> createState() =>
      _ExerciseProcedureScreenState();
}

class _ExerciseProcedureScreenState extends State<ExerciseProcedureScreen> {
  late Future<List<dynamic>> _proceduresFuture;

  @override
  void initState() {
    super.initState();
    _proceduresFuture = _fetchProcedures();
  }

  Future<List<dynamic>> _fetchProcedures() async {
    final apiService = ApiService();
    final response = await apiService.getExerciseProcedures(widget.exerciseId);
    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    } else {
      throw Exception(response['message'] ?? 'Failed to load procedures');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.exerciseTitle} Procedures')),
      body: Column(
        children: [
          if (widget.imageUrl.isNotEmpty)
            Image.network(
              widget.imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 80),
            ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _proceduresFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No procedures found.'));
                }
                final procedures = snapshot.data!;
                return ListView.builder(
                  itemCount: procedures.length,
                  itemBuilder: (context, index) {
                    final step = procedures[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step ${step['step_number']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              step['instruction'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${step['duration']} ${step['duration_unit']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            if (step['progress_hint'] != null &&
                                step['progress_hint'].toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        step['progress_hint'],
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
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
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import 'exercise_procedure_screen.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _exercises = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises({String? query}) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final apiService = ApiService();
      Map<String, dynamic> response;
      if (query == null || query.isEmpty) {
        response = await apiService.getExercises();
      } else {
        response = await apiService.searchExercises(query);
      }
      if (response['success'] == true) {
        setState(() {
          _exercises = response['data'] as List<dynamic>;
        });
      } else {
        setState(() {
          _error = response['message'] ?? 'Failed to load exercises';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageBaseUrl =
        'https://your-backend.com/storage/'; // Change to your backend

    return Scaffold(
      appBar: AppBar(title: const Text('Eye Exercises')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _fetchExercises();
                  },
                ),
              ),
              onSubmitted: (value) => _fetchExercises(query: value),
            ),
            const SizedBox(height: 16),
            // Exercises List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                  ? Center(child: Text(_error))
                  : _exercises.isEmpty
                  ? const Center(child: Text('No exercises found.'))
                  : ListView.builder(
                      itemCount: _exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = _exercises[index];
                        final String imageBaseUrl =
                            'https://ocucare.onrender.com/api/contents/';
                        final String imageUrl =
                            '$imageBaseUrl${exercise['content']}';

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: ListTile(
                            leading: exercise['content'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                              ),
                                    ),
                                  )
                                : const Icon(Icons.image),
                            title: Text(
                              exercise['title'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(exercise['description'] ?? ''),
                            trailing: Text(
                              '${exercise['total_duration']} ${exercise['duration_unit']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseProcedureScreen(
                                    exerciseId: exercise['id'],
                                    exerciseTitle: exercise['title'] ?? '',
                                    imageUrl: imageUrl,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
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

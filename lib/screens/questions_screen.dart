import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  Map<String, dynamic>? _currentData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRootQuestion();
  }

  Future<void> _loadRootQuestion() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await ApiService().getRootQuestion();
      if ((response['success'] == true || response['success'] == 'true') &&
          response['data'] != null) {
        setState(() {
          _currentData = response['data'];
        });
      } else {
        setState(() {
          _error = response['message']?.toString() ?? 'No questions found.';
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

  Future<void> _loadNext(int answerId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await ApiService().getNextByAnswer(answerId);
      if ((response['success'] == true || response['success'] == 'true') &&
          response['data'] != null) {
        setState(() {
          _currentData = response['data'];
        });
      } else {
        setState(() {
          _error = response['message']?.toString() ?? 'No more questions.';
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
    final isQuestion = _currentData?['question'] == true;
    final answers = (_currentData?['answers'] as List<dynamic>?) ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostics')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _currentData == null
          ? const Center(child: Text('No question found.'))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: isQuestion
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentData?['question'] ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...answers.map((answer) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                _loadNext(
                                  answer['id'] is int
                                      ? answer['id']
                                      : int.tryParse(answer['id'].toString()) ??
                                            0,
                                );
                              },
                              child: Text(
                                answer['answer'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    )
                  : Center(
                      child: Text(
                        _currentData?['recommendation'] ?? 'No recommendation.',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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

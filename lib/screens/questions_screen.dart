import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:go_router/go_router.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _currentQuestion;
  List<dynamic>? _currentAnswers;
  List<dynamic>? _diagnoses;
  List<Map<String, dynamic>> _questionHistory = [];
  String? _selectedAnswerId;

  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _fetchRootQuestion() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _apiService.getRootQuestion();
      if (data['success'] == true && data['data'] != null) {
        setState(() {
          _currentQuestion = data['data'];
          _currentAnswers = data['data']['answers'];
          _diagnoses = null;
          _questionHistory = [];
        });
      } else {
        setState(() {
          _error = 'No questions found.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load questions.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchNext(String answerId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _apiService.getNextByAnswer(int.parse(answerId));
      if (data['success'] == true && data['data'] != null) {
        if (data['data']['question'] == true) {
          setState(() {
            _questionHistory.add({
              'question': _currentQuestion,
              'answers': _currentAnswers,
              'selected': answerId,
            });
            _currentQuestion = data['data']['data'];
            _currentAnswers = data['data']['data']['answers'];
            _diagnoses = null;
          });
        } else {
          setState(() {
            _questionHistory.add({
              'question': _currentQuestion,
              'answers': _currentAnswers,
              'selected': answerId,
            });
            _diagnoses = data['data']['data'];
            _currentQuestion = null;
            _currentAnswers = null;
          });
        }
      } else {
        setState(() {
          _error = 'No next question or diagnosis.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load next step.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _restart() {
    setState(() {
      _currentQuestion = null;
      _currentAnswers = null;
      _diagnoses = null;
      _questionHistory = [];
      _selectedAnswerId = null;
      _nameController.clear();
      _ageController.clear();
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Examination'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _diagnoses != null
          ? _buildDiagnoses()
          : _currentQuestion != null
          ? _buildDynamicQuestion()
          : _buildUserInfo(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/questions');
              break;
            case 2:
              context.go('/profile');
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

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 18,
            shadowColor: Colors.indigo.withOpacity(0.18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(18),
                      child: const Icon(
                        Icons.person,
                        color: Colors.indigo,
                        size: 54,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Let’s get started!',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.indigo,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: Colors.indigo.withOpacity(0.03),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Enter your name'
                          : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        prefixIcon: const Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: Colors.indigo.withOpacity(0.03),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Enter your age';
                        final age = int.tryParse(v.trim());
                        if (age == null || age < 1 || age > 120) {
                          return 'Enter a valid age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _fetchRootQuestion();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Start Self-Exam',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 18),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicQuestion() {
    final q = _currentQuestion;
    final answers = _currentAnswers ?? [];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            elevation: 18,
            shadowColor: Colors.indigo.withOpacity(0.18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.question_answer,
                      color: Colors.indigo,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    q?['question'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Colors.indigo,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  ...answers.map<Widget>(
                    (a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _fetchNext(a['id'].toString()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                          child: Text(
                            a['answer'],
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 18),
                    Text(
                      _error!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: _restart,
                    icon: const Icon(Icons.restart_alt, color: Colors.indigo),
                    label: const Text(
                      'Restart',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnoses() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            elevation: 18,
            shadowColor: Colors.green.withOpacity(0.18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(18),
                    child: const Icon(
                      Icons.health_and_safety,
                      color: Colors.green,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Possible Diagnoses (${_diagnoses?.length ?? 0})',
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.green,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_diagnoses != null && _diagnoses!.isNotEmpty)
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        itemCount: _diagnoses!.length,
                        separatorBuilder: (context, idx) =>
                            const SizedBox(height: 18),
                        itemBuilder: (context, idx) {
                          final d = _diagnoses![idx];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 22,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.22),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.10),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 36,
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Text(
                                    d['diagnose'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  if (_diagnoses == null || _diagnoses!.isEmpty)
                    const Text(
                      'No symptoms found.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _restart,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'Restart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

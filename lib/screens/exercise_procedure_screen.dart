import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class ExerciseProcedureScreen extends StatefulWidget {
  final String exerciseId;
  final String exerciseTitle;
  final String imageUrl;

  const ExerciseProcedureScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseTitle,
    required this.imageUrl,
  });

  @override
  State<ExerciseProcedureScreen> createState() =>
      _ExerciseProcedureScreenState();
}

class _ExerciseProcedureScreenState extends State<ExerciseProcedureScreen> {
  late Future<List<dynamic>> _proceduresFuture;
  List<dynamic> _procedures = [];
  int _currentStepIndex = 0;

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;
  String _currentTimeDisplay = '';

  @override
  void initState() {
    super.initState();
    _proceduresFuture = _fetchProcedures();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startTimer(int duration) {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = duration;
      _isTimerRunning = true;
      _currentTimeDisplay = _formatTime(_remainingSeconds);
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _currentTimeDisplay = _formatTime(_remainingSeconds);
        });
      } else {
        timer.cancel();
        setState(() => _isTimerRunning = false);
        _moveToNextStep();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isTimerRunning = false);
  }

  void _resumeTimer() {
    if (!_isTimerRunning && _remainingSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
            _currentTimeDisplay = _formatTime(_remainingSeconds);
          });
        } else {
          timer.cancel();
          setState(() => _isTimerRunning = false);
          _moveToNextStep();
        }
      });
      setState(() => _isTimerRunning = true);
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = _getStepDuration(_currentStepIndex);
      _currentTimeDisplay = _formatTime(_remainingSeconds);
    });
  }

  void _moveToNextStep() {
    if (_currentStepIndex < _procedures.length - 1) {
      setState(() {
        _currentStepIndex++;
        _resetTimer();
      });
    } else {
      setState(() {
        _isTimerRunning = false;
      });
      _showCompletionDialog();
    }
  }

  void _moveToPreviousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
        _resetTimer();
      });
    }
  }

  int _getStepDuration(int index) {
    if (index < _procedures.length) {
      final step = _procedures[index];
      return int.tryParse(step['duration'].toString()) ?? 0;
    }
    return 0;
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('🎉 Exercise Completed!'),
          content: const Text('You have successfully completed all steps.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<List<dynamic>> _fetchProcedures() async {
    final apiService = ApiService();
    final response = await apiService.getExerciseProcedures(widget.exerciseId);
    if (response['success'] == true) {
      _procedures = response['data'] as List<dynamic>;
      if (_procedures.isNotEmpty) {
        _remainingSeconds = _getStepDuration(0);
        _currentTimeDisplay = _formatTime(_remainingSeconds);
      }
      return _procedures;
    } else {
      throw Exception(response['message'] ?? 'Failed to load procedures');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double stepProgress = (_procedures.isEmpty)
        ? 0
        : (_currentStepIndex + 1) / _procedures.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.exerciseTitle}'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: Column(
        children: [
          if (widget.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.imageUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 80),
              ),
            ),

          // Step progress bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LinearProgressIndicator(
              value: stepProgress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // Circular Timer
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: CircularProgressIndicator(
                    value: _remainingSeconds > 0
                        ? _remainingSeconds /
                              _getStepDuration(_currentStepIndex)
                        : 0,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
                  ),
                ),
                Text(
                  _currentTimeDisplay,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),

          // Timer controls
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                if (_currentStepIndex > 0)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                    ),
                    onPressed: _moveToPreviousStep,
                    icon: const Icon(Icons.skip_previous),
                    label: const Text('Previous'),
                  ),
                if (!_isTimerRunning && _remainingSeconds > 0)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: _resumeTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  ),
                if (_isTimerRunning)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: _pauseTimer,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                  ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
                if (_currentStepIndex < _procedures.length - 1)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                    onPressed: _moveToNextStep,
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Next'),
                  ),
              ],
            ),
          ),

          // Procedure detail card
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

                final currentStep = _procedures[_currentStepIndex];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Step ${currentStep['step_number']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentStep['instruction'] ?? '',
                            style: const TextStyle(fontSize: 16, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${currentStep['duration']} ${currentStep['duration_unit']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          if (currentStep['progress_hint'] != null &&
                              currentStep['progress_hint']
                                  .toString()
                                  .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      currentStep['progress_hint'],
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.green,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
}

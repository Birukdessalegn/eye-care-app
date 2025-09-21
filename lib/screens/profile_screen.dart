import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  String? _selectedGender;
  late TextEditingController _dobController;

  bool _isEditing = false;
  bool _isLoading = false;
  UserModel? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _apiService.getUser();
      setState(() {
        _userData = user;
        _firstNameController = TextEditingController(text: user.firstName);
        _lastNameController = TextEditingController(text: user.lastName);
        _emailController = TextEditingController(text: user.email);
        _selectedGender = user.gender;
        _dobController = TextEditingController(
          text: _formatDate(user.dateOfBirth),
        );
      });
    } catch (e) {
      // Optionally handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.updateUser(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        gender: _selectedGender ?? '',
        dateOfBirth: _dobController.text,
      );

      if (response['success'] == true) {
        await Provider.of<AuthService>(context, listen: false).refreshUser();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isEditing = false;
        });
        _fetchUserData();
      } else {
        throw Exception(response['message'] ?? 'Failed to update profile.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      // Try parsing ISO 8601 string
      final dt = DateTime.tryParse(date);
      if (dt != null) {
        final day = dt.day.toString().padLeft(2, '0');
        final month = dt.month.toString().padLeft(2, '0');
        final year = dt.year.toString();
        return '$day-$month-$year';
      }
      // Fallback: try splitting by dash
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
      return date;
    } catch (_) {
      return date;
    }
  }

  Widget _profileChip(
    String? value, {
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            value?.isNotEmpty == true ? value! : '-',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF4F8CFF), // Attractive blue
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateProfile();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
            tooltip: _isEditing ? 'Save Changes' : 'Edit Profile',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF6F8F9),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
          ? const Center(child: Text('No user data found.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  // ...existing code...
                  // Professional Profile Card
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4F8CFF), Color(0xFF6BCBFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _userData!.firstName.isNotEmpty
                                  ? Text(
                                      _userData!.firstName[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 54,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 54,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${_userData!.firstName} ${_userData!.lastName}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF222B45),
                              fontSize: 28,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email,
                                color: Color(0xFF4F8CFF),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _userData!.email,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wc,
                                color: Color(0xFF4F8CFF),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                (_userData!.gender?.isNotEmpty ?? false)
                                    ? _userData!.gender![0].toUpperCase() +
                                          _userData!.gender!.substring(1)
                                    : '-',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Icon(
                                Icons.cake,
                                color: Color(0xFF6BCBFF),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDate(_userData!.dateOfBirth),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Editable Form (only if editing)
                  if (_isEditing)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                'Edit Profile',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4F8CFF),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              CustomTextField(
                                controller: _firstNameController,
                                labelText: 'First Name',
                                enabled: _isEditing,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _lastNameController,
                                labelText: 'Last Name',
                                enabled: _isEditing,
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedGender,
                                decoration: const InputDecoration(
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'male',
                                    child: Text('Male'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'female',
                                    child: Text('Female'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'other',
                                    child: Text('Other'),
                                  ),
                                ],
                                onChanged: _isEditing
                                    ? (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      }
                                    : null,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Please select your gender'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _dobController,
                                readOnly: true,
                                enabled: _isEditing,
                                decoration: const InputDecoration(
                                  labelText: 'Date of Birth',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                onTap: !_isEditing
                                    ? null
                                    : () async {
                                        FocusScope.of(
                                          context,
                                        ).requestFocus(FocusNode());
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              DateTime.tryParse(
                                                _userData?.dateOfBirth ?? '',
                                              ) ??
                                              DateTime(2000, 1, 1),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            final day = picked.day
                                                .toString()
                                                .padLeft(2, '0');
                                            final month = picked.month
                                                .toString()
                                                .padLeft(2, '0');
                                            final year = picked.year.toString();
                                            _dobController.text =
                                                "$day-$month-$year";
                                          });
                                        }
                                      },
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Please enter your date of birth'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
        selectedItemColor: const Color(0xFF4F8CFF),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
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
  late TextEditingController _genderController;
  late TextEditingController _dobController;

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _genderController = TextEditingController(text: user?.gender ?? '');
    final dob = user?.dateOfBirth;
    _dobController = TextEditingController(
      text: dob != null ? dob.toString() : '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
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
        gender: _genderController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
        ],
      ),
      body: Consumer<AuthService>(
        builder: (context, auth, child) {
          final user = auth.currentUser;
          if (user == null) {
            return const Center(child: Text('No user data found.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // User Info Card
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.indigo[100],
                          child: Text(
                            user.firstName.isNotEmpty
                                ? user.firstName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 36,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.email,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.email,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.gender ?? '-',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.cake,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.dateOfBirth ?? '-',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_user,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.role ?? 'User',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.badge,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'First Name: ${user.firstName}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.badge_outlined,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Last Name: ${user.lastName}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Editable Form (only if editing)
                if (_isEditing)
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
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
                        CustomTextField(
                          controller: _genderController,
                          labelText: 'Gender (e.g., Male, Female)',
                          enabled: _isEditing,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _dobController,
                          labelText: 'Date of Birth (YYYY-MM-DD)',
                          enabled: _isEditing,
                        ),
                        const SizedBox(height: 30),
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          CustomButton(
                            text: 'Save Changes',
                            onPressed: _updateProfile,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      // Add this widget to all main screens (Home, Profile, etc.)
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

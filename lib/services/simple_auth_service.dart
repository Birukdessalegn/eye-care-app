import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class SimpleAuthService with ChangeNotifier {
  UserModel? _currentUser;
  String _errorMessage = '';

  UserModel? get currentUser => _currentUser;
  String get errorMessage => _errorMessage;

  Future<bool> register(String name, String email, String password) async {
    print('SimpleAuth: Attempting registration with: $email');
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Simple validation
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      _errorMessage = 'Please fill all fields';
      return false;
    }
    
    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      return false;
    }
    
    if (!email.contains('@')) {
      _errorMessage = 'Please enter a valid email address';
      return false;
    }
    
    // Simulate successful registration
    final nameParts = name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    _currentUser = UserModel(
      id: 'simple-user-${DateTime.now().millisecondsSinceEpoch}',
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
    
    _errorMessage = '';
    notifyListeners();
    return true;
  }

  Future<bool> signIn(String email, String password) async {
    print('SimpleAuth: Attempting login with: $email');
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill all fields';
      return false;
    }
    
    if (!email.contains('@')) {
      _errorMessage = 'Please enter a valid email address';
      return false;
    }
    
    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      return false;
    }
    
    // Simulate successful login
    const name = 'Test User';
    final nameParts = name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    _currentUser = UserModel(
      id: 'simple-user-12345',
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
    
    _errorMessage = '';
    notifyListeners();
    return true;
  }

  Future<bool> updateUserProfile(String name) async {
    if (_currentUser != null) {
      final nameParts = name.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      _currentUser = UserModel(
        id: _currentUser!.id,
        firstName: firstName,
        lastName: lastName,
        email: _currentUser!.email,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteAccount() async {
    _currentUser = null;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }
}

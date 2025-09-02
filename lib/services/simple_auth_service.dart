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
    _currentUser = UserModel(
      id: 'simple-user-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
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
    _currentUser = UserModel(
      id: 'simple-user-12345',
      name: 'Test User',
      email: email,
    );
    
    _errorMessage = '';
    notifyListeners();
    return true;
  }

  Future<bool> updateUserProfile(String name) async {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: name,
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
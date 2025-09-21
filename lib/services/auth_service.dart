import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService with ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserModel? _currentUser;
  String _errorMessage = '';
  bool _isInitialized =
      false; // To prevent redirects before startup check is complete

  // Public Getters
  UserModel? get currentUser => _currentUser;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isInitialized => _isInitialized;

  AuthService() {
    _initialize();
  }

  Future<void> _initialize() async {
    final token = await _apiService.getToken();
    if (token != null) {
      try {
        // If a token exists, validate it by fetching the user profile
        await _fetchAndSetUser();
      } catch (e) {
        // If fetching fails (e.g., invalid token), log out
        print('Initialization failed: $e');
        await logout();
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  /// Step 1 of Registration: Request registration and OTP.
  Future<bool> requestRegistration({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.register(
        
        email: email,
        password: password,
      );
      // According to your API, success is determined by the 'success' flag
      if (response['success'] == true) {
        _errorMessage = '';
        notifyListeners();
        return true; // Indicates navigation to OTP screen is safe
      }
      _errorMessage = response['message'] ?? 'Registration request failed.';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Step 2 of Registration: Verify OTP and log in.
  Future<bool> verifyEmailAndLogin({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiService.verifyEmail(email: email, otp: otp);
      if (response['success'] == true && response['jwt'] != null) {
        // OTP is correct, token is received. Now fetch user data.
        await _fetchAndSetUser();
        return true;
      }
      _errorMessage = response['message'] ?? 'OTP verification failed.';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Log in with email and password.
  Future<bool> login({required String email, required String password}) async {
    try {
      final result = await _apiService.login(email: email, password: password);
      if (result['success'] == true) {
        // Save JWT if present
        if (result['jwt'] != null) {
          await _apiService.saveToken(result['jwt']);
        }
        // Fetch and set the user!
        await _fetchAndSetUser(); // <-- Add this line
        _errorMessage = '';
        // notifyListeners() is called in _fetchAndSetUser
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Login failed.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Fetches the latest user data from the server and updates the state.
  Future<void> refreshUser() async {
    await _fetchAndSetUser();
  }

  /// Fetches user data from the API and sets the local state.
  Future<void> _fetchAndSetUser() async {
    try {
      final user = await _apiService.getUser();
      _currentUser = user;
      _errorMessage = '';
    } catch (e) {
      // This might happen if the token is expired/invalid
      _errorMessage = 'Session expired. Please log in again.';
      _currentUser = null;
      // Rethrow to allow callers to handle it (like in _initialize)
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  /// Logs the user out.
  Future<void> logout() async {
    await _apiService.logout();
    _currentUser = null;
    _errorMessage = '';
    notifyListeners();
  }
}

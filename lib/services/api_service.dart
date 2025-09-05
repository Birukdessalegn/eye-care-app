import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  // --- IMPORTANT ---
  // Replace this with your actual Laravel API URL when it is deployed.
  final String _baseUrl = 'http://www.eyecare-api.infinityfree.me/api/doc';
  // -----------------

  // --- Core API Methods ---

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    return _post('/account/register', {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password_confirmation': password,
    });
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final response = await _post('/account/verify-email', {
      'email': email,
      'otp': otp,
    });
    // If verification is successful, save the returned JWT
    if (response['success'] == true && response['jwt'] != null) {
      await saveToken(response['jwt']);
    }
    return response;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _post('/account/login', {
      'email': email,
      'password': password,
    });
    // If login is successful, save the returned JWT
    if (response['success'] == true && response['jwt'] != null) {
      await saveToken(response['jwt']);
    }
    return response;
  }

  Future<Map<String, dynamic>> sendPasswordResetOtp({
    required String email,
  }) async {
    return _post('/account/send-otp', {'email': email});
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
  }) async {
    return _post('/account/reset-password', {
      // Note: API spec says PATCH, but often form data comes via POST
      'email': email,
      'token': token, // The token from the password reset email
      'password': password,
      'password_confirmation': password,
    });
  }

  // Authenticated methods
  Future<UserModel> getUser() async {
    final response = await _get('/user');
    // The full user data is nested under the 'data' key
    return UserModel.fromMap(response['data']);
  }

  Future<Map<String, dynamic>> updateUser({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
  }) async {
    return _patch('/user', {
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'date_of_birth': dateOfBirth,
    });
  }

  Future<void> logout() async {
    // Even if the backend doesn't have a logout endpoint,
    // we always delete the local token.
    await deleteToken();
    // You could optionally notify the backend, e.g.:
    // try { await _post('/account/logout', {}); } catch (e) { /* ignore */ }
  }

  // --- Generic HTTP Handlers ---

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> _patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await getToken();
    final response = await http.patch(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        return responseData;
      } else {
        // Use the message from the API, or a default error
        throw Exception(responseData['message'] ?? 'An API error occurred.');
      }
    } on FormatException {
      throw Exception('Failed to parse server response. Please try again.');
    } catch (e) {
      // Re-throw API exceptions or other errors
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // --- Token Management ---

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  final String _baseUrl = 'https://ocucare.onrender.com/api';

  // --- Auth & Account ---

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    return _post('/accounts/register', {
      'email': email,
      'password': password,
      'password_confirmation': password,
    });
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final response = await _post('/accounts/verify-email', {
      'email': email,
      'otp': otp,
    });
    if (response['success'] == true && response['jwt'] != null) {
      await saveToken(response['jwt']);
    }
    return response;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _post('/accounts/login', {
      'email': email,
      'password': password,
    });
    if (response['success'] == true && response['jwt'] != null) {
      await saveToken(response['jwt']);
    }
    return response;
  }

  Future<Map<String, dynamic>> sendPasswordResetOtp({
    required String email,
  }) async {
    // This endpoint is /accounts/password-reset-token
    return _post('/accounts/password-reset-token', {'email': email});
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
  }) async {
    // This endpoint is PATCH /accounts/reset-password
    return _patch('/accounts/reset-password', {
      'email': email,
      'token': token,
      'password': password,
      'password_confirmation': password,
    });
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    // PATCH /accounts/change-password
    return _patch('/accounts/change-password', {
      'old_password': oldPassword,
      'password': newPassword,
      'password_confirmation': newPassword,
    });
  }

  // --- Exercises ---

  Future<Map<String, dynamic>> getExercises() async {
    return _get('/exercises');
  }

  Future<Map<String, dynamic>> getExerciseProcedures(String exerciseId) async {
    // GET /exercises/:eye_exercise_id/procedures
    return _get('/exercises/$exerciseId/procedures');
  }

  Future<Map<String, dynamic>> searchExercises(String query) async {
    return _post('/exercises', {'title': query});
  }

  // --- Orders ---

  Future<Map<String, dynamic>> getOrders() async {
    return _get('/orders');
  }

  Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    return _post('/orders', orderData);
  }

  Future<Map<String, dynamic>> getOrderItems(String orderId) async {
    return _get('/orders-items/$orderId');
  }

  // --- Products ---

  Future<Map<String, dynamic>> getProducts() async {
    return _get('/products');
  }

  Future<Map<String, dynamic>> createProduct(
    Map<String, dynamic> productData,
  ) async {
    return _post('/products', productData);
  }

  Future<Map<String, dynamic>> rateProduct(String productId, int rate) async {
    // PATCH /products/:product_id
    return _patch('/products/$productId', {'rate': rate});
  }

  // --- User ---

  Future<UserModel> getUser() async {
    final response = await _get(
      '/users',
    ); // <-- changed from '/user' to '/users'
    return UserModel.fromMap(response['data']['user']); // adjust if needed
  }

  Future<Map<String, dynamic>> updateUser({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
  }) async {
    return _patch('/users', {
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'date_of_birth': dateOfBirth,
    });
  }

  Future<void> logout() async {
    await deleteToken();
  }

  // --- Questions ---

  Future<List<dynamic>> getQuestions() async {
    final response = await _get('/questions');
    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    } else {
      throw Exception(response['message'] ?? 'Failed to load questions');
    }
  }

  Future<Map<String, dynamic>> submitAnswer({
    required String questionId,
    required String answer,
  }) async {
    return _post('/questions', {'question_id': questionId, 'answer': answer});
  }

  // Get the next question or recommendation by answer id
  Future<Map<String, dynamic>> getNextByAnswer(int answerId) async {
    final response = await _get('/answers/$answerId');
    return response;
  }

  Future<Map<String, dynamic>> getRootQuestion() async {
    final response = await _get('/questions');
    if (response['data'] is List && response['data'].isNotEmpty) {
      // Return the first question in the list
      return {...response, 'data': response['data'][0]};
    } else if (response['data'] is Map) {
      return response;
    } else {
      throw Exception('No root question found.');
    }
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
    print('Login response: ${response.body}'); // <-- Add this line
    if (response.body.isEmpty) {
      throw Exception('Empty response from server.');
    }
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData['success'] == true) {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'An API error occurred.');
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

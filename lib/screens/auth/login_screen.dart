import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with test values for easier testing
    _emailController.text = 'test@example.com';
    _passwordController.text = 'password123';
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.remove_red_eye,
                        size: 60,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Eye Care',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.emailValidator,
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                        validator: Validators.passwordValidator,
                      ),
                      const SizedBox(height: 24.0),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: 'Login',
                              onPressed: () async {
                                print('Login button pressed');
                                if (_formKey.currentState!.validate()) {
                                  print('Form is valid');
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  
                                  final success = await authService.signIn(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                  
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  
                                  print('Login result: $success');
                                  if (success) {
                                    print('Login successful, navigating to home');
                                    // Navigation is handled by the router based on auth state
                                  } else {
                                    print('Login failed: ${authService.errorMessage}');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          authService.errorMessage.isNotEmpty 
                                              ? authService.errorMessage 
                                              : 'Login failed. Please try again.',
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                } else {
                                  print('Form validation failed');
                                }
                              },
                            ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          print('Navigate to register');
                          context.go('/register');
                        },
                        child: const Text('Don\'t have an account? Register'),
                      ),
                      const SizedBox(height: 8.0),
                      TextButton(
                        onPressed: () {
                          context.go('/reset-password');
                        },
                        child: const Text('Forgot Password?'),
                      ),
                      const SizedBox(height: 16.0),
                      // Debug info
                      const Text(
                        'Test credentials: test@example.com / password123',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
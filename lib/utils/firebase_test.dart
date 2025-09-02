import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTest {
  static Future<void> testConnection() async {
    try {
      // Test if we can create a user (this will fail but show us the error)
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'test@test.com',
        password: 'testpassword',
      );
    } catch (e) {
      print('Firebase connection test error: $e');
    }
  }
}
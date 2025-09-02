import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  String _errorMessage = '';

  UserModel? get currentUser => _currentUser;
  String get errorMessage => _errorMessage;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
      notifyListeners();
    } else {
      try {
        // Get user data from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        
        if (userDoc.exists) {
          _currentUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        } else {
          // Create new user document if it doesn't exist
          _currentUser = UserModel(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? 'User',
            email: firebaseUser.email ?? '',
            role: 'user',
          );
          await _firestore.collection('users').doc(firebaseUser.uid).set(_currentUser!.toMap());
        }
        notifyListeners();
      } catch (e) {
        print('Error in _onAuthStateChanged: $e');
        _currentUser = null;
        notifyListeners();
      }
    }
  }

  Future<bool> register(String name, String email, String password, {String role = 'user'}) async {
    print('Attempting registration with: $email');
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      print('Registration successful: ${result.user?.uid}');
      
      // Create user document in Firestore
      _currentUser = UserModel(
        id: result.user!.uid,
        name: name,
        email: email,
        role: role,
      );

      await _firestore.collection('users').doc(result.user!.uid).set(_currentUser!.toMap());

      _errorMessage = '';
      return true;
    } on FirebaseAuthException catch (e) {
      print('Registration failed: ${e.code} - ${e.message}');
      _errorMessage = _getErrorMessage(e);
      return false;
    } catch (e) {
      print('Unexpected error during registration: $e');
      _errorMessage = 'An unexpected error occurred. Please try again.';
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    print('Attempting login with: $email');
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      print('Login successful: ${result.user?.uid}');
      _errorMessage = '';
      return true;
    } on FirebaseAuthException catch (e) {
      print('Login failed: ${e.code} - ${e.message}');
      _errorMessage = _getErrorMessage(e);
      
      // Show more specific error messages
      if (e.code == 'user-not-found') {
        _errorMessage = 'No account found with this email. Please register first.';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        _errorMessage = 'Invalid email address format.';
      } else if (e.code == 'network-request-failed') {
        _errorMessage = 'Network error. Please check your internet connection.';
      }
      
      return false;
    } catch (e) {
      print('Unexpected error during login: $e');
      _errorMessage = 'An unexpected error occurred. Please try again.';
      return false;
    }
  }

  Future<bool> updateUserProfile(String name) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Update in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
        });
        
        // Update local user data
        _currentUser = UserModel(
          id: user.uid,
          name: name,
          email: _currentUser?.email ?? user.email ?? '',
          role: _currentUser?.role ?? 'user',
        );
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update profile. Please try again.';
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user document from Firestore
        await _firestore.collection('users').doc(user.uid).delete();
        
        // Delete user from Firebase Auth
        await user.delete();
        
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete account. Please try again.';
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _errorMessage = '';
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
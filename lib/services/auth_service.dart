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
  bool get isLoggedIn => _currentUser != null;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
    } else {
      await _fetchUser(firebaseUser.uid);
    }
    notifyListeners();
  }

  Future<void> _fetchUser(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        _currentUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching user: $e');
      _currentUser = null;
    }
  }

  Future<bool> register(String name, String email, String password, {String role = 'user'}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      UserModel newUser = UserModel(
        id: result.user!.uid,
        name: name,
        email: email,
        role: role,
      );

      await _firestore.collection('users').doc(result.user!.uid).set(newUser.toMap());
      
      _errorMessage = '';
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      _errorMessage = '';
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
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
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> updateUserProfile(String name) async {
    if (_currentUser == null) return false;

    try {
      await _firestore.collection('users').doc(_currentUser!.id).update({'name': name});
      // Re-fetch user data to update the UI
      await _fetchUser(_currentUser!.id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    if (_currentUser == null) return false;

    try {
      // First, delete the user's document from Firestore
      await _firestore.collection('users').doc(_currentUser!.id).delete();
      
      // Then, delete the user from Firebase Authentication
      await _auth.currentUser!.delete();
      
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle re-authentication if necessary
      if (e.code == 'requires-recent-login') {
        _errorMessage = 'Please log out and log back in again to delete your account.';
      } else {
        _errorMessage = _getErrorMessage(e);
      }
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete account.';
      notifyListeners();
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
      case 'invalid-credential':
        return 'Invalid credentials, please check your email and password.';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Please log in again before retrying.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/login/login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // SharedPreferences keys
  static const String USER_EMAIL = 'userEmail';
  static const String IS_LOGGED_IN = 'isLoggedIn';
  static const String USER_NAME = 'userName';

  Future<void> signup({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    try {
      // Create user with Firebase
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user data in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(USER_EMAIL, email);
      await prefs.setBool(IS_LOGGED_IN, true);
      await prefs.setString(USER_NAME, username);

      // Update Firebase user profile
      await userCredential.user?.updateDisplayName(username);

      // Navigate to HomePage
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      _showToast(message);
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Sign in with Firebase
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      // Save login state in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(USER_EMAIL, email);
      await prefs.setBool(IS_LOGGED_IN, true);
      
      // Save username if available
      if (userCredential.user?.displayName != null) {
        await prefs.setString(USER_NAME, userCredential.user!.displayName!);
      }

      // Navigate to HomePage
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      _showToast(message);
    }
  }

  Future<void> signout({required BuildContext context}) async {
    await _auth.signOut();
    
    // Clear SharedPreferences data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to Login
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    }
  }

  Future<bool> isUserLoggedIn() async {
    // Check both SharedPreferences and Firebase Auth state
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(IS_LOGGED_IN) ?? false;
    final currentUser = _auth.currentUser;
    
    return isLoggedIn && currentUser != null;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
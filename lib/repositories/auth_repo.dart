// auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Storage keys
  static const String USER_EMAIL = 'userEmail';
  static const String IS_LOGGED_IN = 'isLoggedIn';
  static const String USER_NAME = 'userName';

  // Remote authentication methods
  Future<UserCredential> createUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  Future<UserCredential> signInUser(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  Future<void> updateUserProfile(User user, String username) async {
    await user.updateDisplayName(username);
  }

  // Local storage methods
  Future<void> saveUserLocally({
    required String email,
    required String username,
    required bool isLoggedIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(USER_EMAIL, email),
      prefs.setString(USER_NAME, username),
      prefs.setBool(IS_LOGGED_IN, isLoggedIn),
    ]);
  }

  Future<void> clearLocalUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<Map<String, dynamic>> getLocalUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(USER_EMAIL),
      'username': prefs.getString(USER_NAME),
      'isLoggedIn': prefs.getBool(IS_LOGGED_IN),
    };
  }

  // Auth state methods
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(IS_LOGGED_IN) ?? false;
    final currentUser = _auth.currentUser;
    
    return isLoggedIn && currentUser != null;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;
}
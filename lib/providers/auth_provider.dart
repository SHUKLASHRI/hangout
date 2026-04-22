import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = true;
  StreamSubscription? _userSubscription;

  AuthProvider(this._authService, this._firestoreService) {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _firebaseUser != null;

  Future<void> _onAuthStateChanged(User? user) async {
    _isLoading = true;
    notifyListeners();

    _firebaseUser = user;
    _userSubscription?.cancel();

    if (user != null) {
      // Listen to real-time user document updates
      _userSubscription = _firestoreService.streamUser(user.uid).listen((model) {
        _userModel = model;
        _isLoading = false;
        notifyListeners();
      });
    } else {
      _userModel = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithEmail(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();
      final cred = await _authService.signInWithGoogle();
      
      if (cred != null && cred.additionalUserInfo?.isNewUser == true) {
        // Create initial Firestore doc for Google users
        final newUser = UserModel(
          uid: cred.user!.uid,
          displayName: cred.user!.displayName ?? 'New User',
          email: cred.user!.email ?? '',
          photoUrl: cred.user!.photoURL,
          createdAt: DateTime.now(),
        );
        await _firestoreService.createUser(newUser);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}

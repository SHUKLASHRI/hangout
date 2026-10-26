import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setTab(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Helper to resolve route name from index
  String getRoutePath(int index) {
    switch (index) {
      case 0: return '/map';
      case 1: return '/feed';
      case 2: return '/chat';
      case 3: return '/profile';
      default: return '/map';
    }
  }

  // Helper to resolve index from route path
  void syncIndexWithRoute(String path) {
    int target = _currentIndex;
    if (path.startsWith('/map')) target = 0;
    else if (path.startsWith('/feed')) target = 1;
    else if (path.startsWith('/chat')) target = 2;
    else if (path.startsWith('/profile')) target = 3;
    
    if (target != _currentIndex) {
      _currentIndex = target;
      notifyListeners();
    }
  }
}

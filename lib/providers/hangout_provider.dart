import 'dart:async';
import 'package:flutter/material.dart';
import '../models/hangout_model.dart';
import '../services/hangout_service.dart';

class HangoutProvider extends ChangeNotifier {
  final HangoutService _service;
  
  List<HangoutModel> _hangouts = [];
  bool _isLoading = true;
  StreamSubscription? _subscription;
  
  // Filters
  ActivityType? _categoryFilter;
  
  HangoutProvider(this._service) {
    _init();
  }

  List<HangoutModel> get hangouts {
    if (_categoryFilter == null) return _hangouts;
    return _hangouts.where((h) => h.type == _categoryFilter).toList();
  }
  
  bool get isLoading => _isLoading;
  ActivityType? get categoryFilter => _categoryFilter;

  void _init() {
    _subscription = _service.streamActiveHangouts().listen((list) {
      _hangouts = list;
      _isLoading = false;
      notifyListeners();
    });
  }

  void setFilter(ActivityType? type) {
    _categoryFilter = type;
    notifyListeners();
  }

  Future<void> join(String hangoutId, String uid) async {
    await _service.joinHangout(hangoutId, uid);
  }

  Future<void> leave(String hangoutId, String uid) async {
    await _service.leaveHangout(hangoutId, uid);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

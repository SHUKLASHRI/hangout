import 'dart:async';
import 'package:flutter/material.dart';
import '../models/hangout_model.dart';
import '../services/hangout_service.dart';

class HangoutProvider extends ChangeNotifier {
  final HangoutService _service;
  
  List<HangoutModel> _hangouts = [];
  bool _isLoading = true;
  String? _errorMessage;
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
  String? get errorMessage => _errorMessage;
  ActivityType? get categoryFilter => _categoryFilter;

  void _init() {
    _subscription = _service.streamActiveHangouts().listen(
      (list) {
        _hangouts = list;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('[HangoutProvider] Stream error: $error');
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  void setFilter(ActivityType? type) {
    _categoryFilter = type;
    notifyListeners();
  }

  Future<void> create(HangoutModel hangout) async {
    await _service.createHangout(hangout);
  }

  Future<void> join(String hangoutId, String uid) async {
    await _service.joinHangout(hangoutId, uid);
  }

  Future<void> leave(String hangoutId, String uid) async {
    await _service.leaveHangout(hangoutId, uid);
  }

  Future<void> cancel(String hangoutId) async {
    await _service.cancelHangout(hangoutId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

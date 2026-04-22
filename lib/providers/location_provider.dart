import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _service;
  
  Position? _currentPosition;
  LocationPermission _permissionStatus = LocationPermission.unableToDetermine;
  bool _isLoading = true;
  StreamSubscription? _subscription;

  LocationProvider(this._service) {
    _init();
  }

  Position? get currentPosition => _currentPosition;
  LocationPermission get permissionStatus => _permissionStatus;
  bool get isLoading => _isLoading;
  bool get hasPermission => 
    _permissionStatus == LocationPermission.always || 
    _permissionStatus == LocationPermission.whileInUse;

  Future<void> _init() async {
    try {
      _permissionStatus = await _service.requestPermission();
      if (hasPermission) {
        _currentPosition = await _service.getCurrentPosition();
        _startListening();
      }
    } catch (e) {
      debugPrint("Location Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startListening() {
    _subscription = _service.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
  }

  Future<void> refreshLocation() async {
    if (hasPermission) {
      _currentPosition = await _service.getCurrentPosition();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/location_provider.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialPosition;

  const LocationPickerScreen({
    super.key,
    this.initialPosition,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng _currentCenter;
  
  bool _isLoadingAddress = false;
  bool _isDragging = false;
  String _currentAddress = "Drop pin at meetup spot";
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.initialPosition ?? const LatLng(20.5937, 78.9629);
    // Initial reverse geocode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locProvider = context.read<LocationProvider>();
      if (widget.initialPosition == null && locProvider.currentPosition != null) {
        final userLatLng = LatLng(
          locProvider.currentPosition!.latitude,
          locProvider.currentPosition!.longitude,
        );
        _animateTo(userLatLng);
      } else {
        _fetchAddress(_currentCenter);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _animateTo(LatLng pos) async {
    _currentCenter = pos;
    if (_controller.isCompleted) {
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(pos, 16));
    }
    _fetchAddress(pos);
  }

  Future<void> _fetchAddress(LatLng position) async {
    setState(() => _isLoadingAddress = true);
    final fallbackAddress = 'Pin at ${position.latitude.toStringAsFixed(4)}°, ${position.longitude.toStringAsFixed(4)}°';
    
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']?.isNotEmpty == true
        ? dotenv.env['GOOGLE_MAPS_API_KEY']!
        : 'AIzaSyCjzOlmp6DXrQy9F0-K1IZqD95TNHx1oSM';
    
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && (data['results'] as List).isNotEmpty) {
          final formatted = data['results'][0]['formatted_address'];
          if (mounted) {
            setState(() {
              _currentAddress = formatted ?? fallbackAddress;
            });
            return;
          }
        }
      }
      if (mounted) setState(() => _currentAddress = fallbackAddress);
    } catch (_) {
      if (mounted) setState(() => _currentAddress = fallbackAddress);
    } finally {
      if (mounted) setState(() => _isLoadingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // 1. Google Map Base
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentCenter,
              zoom: 16,
            ),
            onMapCreated: (controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            onCameraMoveStarted: () {
              setState(() => _isDragging = true);
            },
            onCameraMove: (position) {
              _currentCenter = position.target;
            },
            onCameraIdle: () {
              setState(() => _isDragging = false);
              _debounceTimer?.cancel();
              _debounceTimer = Timer(const Duration(milliseconds: 400), () {
                if (mounted) {
                  _fetchAddress(_currentCenter);
                }
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),

          // 2. Interactive Pin Drop Crosshair in Center
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                transform: Matrix4.translationValues(0, _isDragging ? -16 : 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.trustBlue,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        _isDragging ? 'Move to spot' : 'Drop Pin Here',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.location_on_rounded,
                      size: 52,
                      color: AppColors.vibrantOrange,
                    ),
                    // Shadow dot on ground
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: _isDragging ? 8 : 16,
                      height: _isDragging ? 3 : 6,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Top Navigation & Guidance Header
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(LucideIcons.arrowLeft, color: AppColors.trustBlue, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.mapPin, size: 18, color: AppColors.vibrantOrange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pin exact meeting spot',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. "My Location" Floating Quick-Locate Button
          Positioned(
            right: 20,
            bottom: 220,
            child: Tooltip(
              message: 'Jump to current location',
              child: GestureDetector(
                onTap: () {
                  final pos = locationProvider.currentPosition;
                  if (pos != null) {
                    _animateTo(LatLng(pos.latitude, pos.longitude));
                  } else {
                    locationProvider.refreshLocation();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Acquiring current GPS location...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: AppColors.trustBlue,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),

          // 5. Bottom Selected Location Card
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.trustBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'CONFIRMED PIN',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.trustBlue,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_currentCenter.latitude.toStringAsFixed(4)}, ${_currentCenter.longitude.toStringAsFixed(4)}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _isLoadingAddress
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(
                            color: AppColors.trustBlue,
                            backgroundColor: Color(0xFFF1F5F9),
                          ),
                        )
                      : Text(
                          _currentAddress,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop({
                          'address': _currentAddress,
                          'lat': _currentCenter.latitude,
                          'lng': _currentCenter.longitude,
                          'isPinDrop': true,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.trustBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.check, size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'CONFIRM MEETING SPOT',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.8,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

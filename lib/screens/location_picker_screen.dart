import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../widgets/liquid_glass_card.dart';

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
  LatLng _currentCenter = const LatLng(0, 0); // LatLng actually HAS a const constructor in google_maps_flutter v2+, but the error was somewhere else. Wait, let's just make it not const to be safe.
  
  bool _isLoadingAddress = false;
  String _currentAddress = "Move map to select location";

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.initialPosition ?? const LatLng(20.5937, 78.9629);
  }

  Future<void> _fetchAddress(LatLng position) async {
    setState(() => _isLoadingAddress = true);
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'] as List;
          if (results.isNotEmpty) {
            setState(() {
              _currentAddress = results.first['formatted_address'];
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    } finally {
      setState(() => _isLoadingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition ?? const LatLng(20.5937, 78.9629),
              zoom: 15,
            ),
            onMapCreated: (controller) => _controller.complete(controller),
            onCameraMove: (position) {
              _currentCenter = position.target;
            },
            onCameraIdle: () {
              _fetchAddress(_currentCenter);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          
          // Center Pin
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35.0), // Adjust for pin tip
              child: Icon(
                Icons.location_on,
                size: 50,
                color: AppColors.vibrantOrange,
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: LiquidGlassCard(
                borderRadius: BorderRadius.circular(20),
                opacity: 0.8,
                blur: 10,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(LucideIcons.arrowLeft, color: AppColors.trustBlue),
                ),
              ),
            ),
          ),

          // Bottom Action Card
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: LiquidGlassCard(
              borderRadius: BorderRadius.circular(24),
              opacity: 0.9,
              blur: 15,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Location',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: const Color(0xFF667085)),
                    ),
                    const SizedBox(height: 8),
                    _isLoadingAddress
                        ? const LinearProgressIndicator(color: AppColors.trustBlue)
                        : Text(
                            _currentAddress,
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A)),
                          ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoadingAddress
                            ? null
                            : () {
                                context.pop({
                                  'address': _currentAddress,
                                  'lat': _currentCenter.latitude,
                                  'lng': _currentCenter.longitude,
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.trustBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'CONFIRM LOCATION',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/hangout_model.dart';
import '../providers/hangout_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/map/marker_generator.dart';
import '../widgets/map/hangout_marker_widget.dart';
import '../widgets/liquid_glass_card.dart';
import '../core/theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  bool _isGeneratingMarkers = false;
  String? _lastHangoutListHash;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateMapElements(List<HangoutModel> hangouts) async {
    // Avoid re-generating if list hasn't changed
    final hash = hangouts.map((h) => h.id).join(',');
    if (hash == _lastHangoutListHash || _isGeneratingMarkers) return;
    _lastHangoutListHash = hash;

    setState(() => _isGeneratingMarkers = true);

    final Set<Marker> newMarkers = {};
    final Set<Circle> newCircles = {};

    for (final hangout in hangouts) {
      try {
        final icon = await MarkerGenerator.createCustomMarkerBitmap(
          HangoutMarkerWidget(hangout: hangout),
        );

        newMarkers.add(
          Marker(
            markerId: MarkerId(hangout.id),
            position: LatLng(hangout.meetingZone.latitude, hangout.meetingZone.longitude),
            icon: icon,
            onTap: () => context.push('/hangout/${hangout.id}'),
          ),
        );

        newCircles.add(
          Circle(
            circleId: CircleId('zone_${hangout.id}'),
            center: LatLng(hangout.meetingZone.latitude, hangout.meetingZone.longitude),
            radius: 500, // 500m privacy zone per PRD
            fillColor: AppColors.socialOrange.withValues(alpha: 0.10),
            strokeColor: AppColors.socialOrange.withValues(alpha: 0.45),
            strokeWidth: 2,
          ),
        );
      } catch (e) {
        debugPrint('[MapScreen] Error generating marker for ${hangout.id}: $e');
      }
    }

    if (mounted) {
      setState(() {
        _markers
          ..clear()
          ..addAll(newMarkers);
        _circles
          ..clear()
          ..addAll(newCircles);
        _isGeneratingMarkers = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hangoutProvider = context.watch<HangoutProvider>();
    final locationProvider = context.watch<LocationProvider>();

    // Side effect - trigger marker generation when hangouts change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMapElements(hangoutProvider.hangouts);
    });

    return Scaffold(
      body: Stack(
        children: [
          // High-quality Map Placeholder (Zoomable)
          InteractiveViewer(
            maxScale: 5.0,
            child: Image.asset(
              'assets/images/map_placeholder.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Overlay for Placeholder Info
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Center(
              child: LiquidGlassCard(
                borderRadius: BorderRadius.circular(20),
                opacity: 0.8,
                blur: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '📍 Map Preview (Integration Pending)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.trustBlue,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Glass status chip — simple overlay, BackdropFilter-based (web-safe)
          if (_isGeneratingMarkers)
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.trustBlue),
                          ),
                          SizedBox(width: 10),
                          Text('Finding hangouts near you...', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Action buttons — glass pill on the right side
          Positioned(
            right: 16,
            bottom: 110,
            child: Column(
              children: [
                _glassActionButton(
                  icon: Icons.filter_list_rounded,
                  tooltip: 'Filter',
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _glassActionButton(
                  icon: Icons.my_location_rounded,
                  tooltip: 'My Location',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Interactive Map Integration Coming Soon!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8),
                ],
              ),
              child: Icon(icon, color: AppColors.trustBlue, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

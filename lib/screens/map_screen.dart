import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart' hide ActivityType;
import '../models/hangout_model.dart';
import '../providers/hangout_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/map/marker_generator.dart';
import '../widgets/map/hangout_marker_widget.dart';
import '../core/theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _hangoutMarkers = {};
  final Set<Circle> _circles = {};
  final Map<String, BitmapDescriptor> _markerCache = {};
  
  bool _isGeneratingMarkers = false;
  String? _lastHangoutListHash;
  bool _hasAutoCentered = false;

  ActivityType? _selectedCategory;
  HangoutModel? _selectedHangout;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateMapElements(List<HangoutModel> allHangouts) async {
    final filtered = _selectedCategory == null
        ? allHangouts
        : allHangouts.where((h) => h.type == _selectedCategory).toList();

    final hash = '${_selectedCategory?.name ?? "all"}_' +
        filtered.map((h) => '${h.id}_${h.status.name}_${h.participantIds.length}').join(',');
    
    if (hash == _lastHangoutListHash || _isGeneratingMarkers) return;
    _lastHangoutListHash = hash;

    setState(() => _isGeneratingMarkers = true);

    final Set<Marker> newMarkers = {};
    final Set<Circle> newCircles = {};

    for (final hangout in filtered) {
      try {
        final cacheKey = '${hangout.id}_${hangout.status.name}_${hangout.participantIds.length}';
        BitmapDescriptor? icon = _markerCache[cacheKey];
        if (icon == null) {
          icon = await MarkerGenerator.createCustomMarkerBitmap(
            HangoutMarkerWidget(hangout: hangout),
          );
          _markerCache[cacheKey] = icon;
        }

        newMarkers.add(
          Marker(
            markerId: MarkerId(hangout.id),
            position: LatLng(hangout.meetingZone.latitude, hangout.meetingZone.longitude),
            icon: icon,
            onTap: () {
              setState(() => _selectedHangout = hangout);
              _panToHangout(hangout);
            },
          ),
        );

        newCircles.add(
          Circle(
            circleId: CircleId('zone_${hangout.id}'),
            center: LatLng(hangout.meetingZone.latitude, hangout.meetingZone.longitude),
            radius: 500, // 500m privacy zone
            fillColor: AppColors.vibrantOrange.withValues(alpha: 0.10),
            strokeColor: AppColors.vibrantOrange.withValues(alpha: 0.45),
            strokeWidth: 2,
          ),
        );
      } catch (e) {
        debugPrint('[MapScreen] Error generating marker: $e');
      }
    }

    if (mounted) {
      setState(() {
        _hangoutMarkers
          ..clear()
          ..addAll(newMarkers);
        _circles
          ..clear()
          ..addAll(newCircles);
        _isGeneratingMarkers = false;
      });
    }
  }

  Future<void> _panToHangout(HangoutModel hangout) async {
    if (!_controller.isCompleted) return;
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          hangout.meetingZone.latitude - 0.0025,
          hangout.meetingZone.longitude,
        ),
      ),
    );
  }

  Future<void> _animateToUserLocation(Position position, {double zoom = 15.0}) async {
    if (!_controller.isCompleted) return;
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        zoom,
      ),
    );
  }

  String _calculateDistance(Position? userPos, HangoutModel hangout) {
    if (userPos == null) return 'Nearby';
    final meters = Geolocator.distanceBetween(
      userPos.latitude,
      userPos.longitude,
      hangout.meetingZone.latitude,
      hangout.meetingZone.longitude,
    );
    if (meters < 1000) {
      return '${meters.round()}m away';
    }
    return '${(meters / 1000).toStringAsFixed(1)}km away';
  }

  @override
  Widget build(BuildContext context) {
    final hangoutProvider = context.watch<HangoutProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final userPos = locationProvider.currentPosition;

    // Auto-center camera once when live location first arrives
    if (!_hasAutoCentered && userPos != null) {
      _hasAutoCentered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animateToUserLocation(userPos, zoom: 15.5);
      });
    }

    // Refresh markers on data change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMapElements(hangoutProvider.hangouts);
    });

    final initialPosition = CameraPosition(
      target: LatLng(
        userPos?.latitude ?? 20.5937,
        userPos?.longitude ?? 78.9629,
      ),
      zoom: userPos != null ? 15 : 5,
    );

    // Combine hangout markers with real-time user tracker marker and radar circle
    final allMarkers = Set<Marker>.from(_hangoutMarkers);
    final allCircles = Set<Circle>.from(_circles);

    if (userPos != null) {
      final userLatLng = LatLng(userPos.latitude, userPos.longitude);
      allMarkers.add(
        Marker(
          markerId: const MarkerId('live_user_tracker'),
          position: userLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'You are here (Live Tracker)'),
          zIndexInt: 10,
        ),
      );

      allCircles.add(
        Circle(
          circleId: const CircleId('live_user_radar'),
          center: userLatLng,
          radius: 350, // 350m live proximity radius
          fillColor: AppColors.trustBlue.withValues(alpha: 0.12),
          strokeColor: AppColors.trustBlue.withValues(alpha: 0.50),
          strokeWidth: 2,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // 1. Google Map Base Layer
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialPosition,
            markers: allMarkers,
            circles: allCircles,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            onTap: (_) {
              if (_selectedHangout != null) {
                setState(() => _selectedHangout = null);
              }
            },
          ),

          // 2. Top Header & Category Filter Bar
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Live Location Status Pill
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: userPos != null ? AppColors.emeraldGreen : AppColors.vibrantOrange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  userPos != null ? 'Live GPS Active' : 'Locating you...',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_isGeneratingMarkers)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.trustBlue),
                                ),
                                SizedBox(width: 6),
                                Text('Updating...', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Horizontal Category Filters
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildCategoryChip('🌟 All', null),
                      _buildCategoryChip('☕ Food & Coffee', ActivityType.food),
                      _buildCategoryChip('📚 Study', ActivityType.study),
                      _buildCategoryChip('🎮 Gaming', ActivityType.gaming),
                      _buildCategoryChip('⚽ Sports', ActivityType.sport),
                      _buildCategoryChip('🧭 Explore', ActivityType.explore),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Action Buttons (Right Side)
          Positioned(
            right: 16,
            bottom: _selectedHangout != null ? 240 : 110,
            child: Column(
              children: [
                _glassActionButton(
                  icon: Icons.refresh_rounded,
                  tooltip: 'Refresh Hangouts',
                  onTap: () {
                    setState(() => _lastHangoutListHash = null);
                    _updateMapElements(hangoutProvider.hangouts);
                  },
                ),
                const SizedBox(height: 12),
                _glassActionButton(
                  icon: Icons.my_location_rounded,
                  tooltip: 'Recenter on Me',
                  onTap: () async {
                    if (userPos != null) {
                      _animateToUserLocation(userPos, zoom: 16.0);
                    } else {
                      locationProvider.refreshLocation();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Requesting live location...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // 4. Interactive Hangout Preview Floating Card (Bottom)
          if (_selectedHangout != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 95,
              child: _buildHangoutPreviewCard(_selectedHangout!, userPos),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, ActivityType? type) {
    final isSelected = _selectedCategory == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = type;
          _lastHangoutListHash = null; // force update
        });
        _updateMapElements(context.read<HangoutProvider>().hangouts);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.trustBlue : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? AppColors.trustBlue : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildHangoutPreviewCard(HangoutModel hangout, Position? userPos) {
    final spotsLeft = (hangout.maxParticipants - hangout.participantIds.length).clamp(0, 999);
    final distanceText = _calculateDistance(userPos, hangout);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 8),
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
                  hangout.type.name.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.trustBlue,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '📍 $distanceText',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.emeraldGreen,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _selectedHangout = null),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hangout.title,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.trustBlue.withValues(alpha: 0.15),
                child: Text(
                  hangout.hostName.isNotEmpty ? hangout.hostName[0].toUpperCase() : 'H',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.trustBlue),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                hangout.hostName,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
              Text(
                hangout.hostTrustScore.toStringAsFixed(1),
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const Spacer(),
              Text(
                '$spotsLeft spots left',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: spotsLeft > 0 ? AppColors.vibrantOrange : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                context.push('/hangout/${hangout.id}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.trustBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'VIEW HANGOUT DETAILS',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
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
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
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

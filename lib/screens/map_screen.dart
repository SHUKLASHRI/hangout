import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
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
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {}; // M4-B3: Privacy Circles
  bool _isGeneratingMarkers = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateMapElements(List<HangoutModel> hangouts) async {
    if (_isGeneratingMarkers) return;
    setState(() => _isGeneratingMarkers = true);

    final Set<Marker> newMarkers = {};
    final Set<Circle> newCircles = {};

    for (final hangout in hangouts) {
      // 1. Generate Custom Marker
      final icon = await MarkerGenerator.createCustomMarkerBitmap(
        HangoutMarkerWidget(hangout: hangout),
      );

      newMarkers.add(
        Marker(
          markerId: MarkerId(hangout.id),
          position: LatLng(hangout.meetingZone.latitude, hangout.meetingZone.longitude),
          icon: icon,
          onTap: () {
            context.push('/hangout/${hangout.id}');
          },
        ),
      );

      // 2. Generate Privacy Circle (M4-B3)
      // Visualises "somewhere in this 500m zone"
      newCircles.add(
        Circle(
          circleId: CircleId('zone_${hangout.id}'),
          center: LatLng(hangout.meetingZone.latitude, hangout.meetingZone.longitude),
          radius: 500, // 500m per PRD
          fillColor: AppColors.socialOrange.withValues(alpha: 0.12),
          strokeColor: AppColors.socialOrange.withValues(alpha: 0.5),
          strokeWidth: 2,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers.clear();
        _markers.addAll(newMarkers);
        _circles.clear();
        _circles.addAll(newCircles);
        _isGeneratingMarkers = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hangoutProvider = context.watch<HangoutProvider>();
    final locationProvider = context.watch<LocationProvider>();

    // Update map elements when the hangout list changes
    _updateMapElements(hangoutProvider.hangouts);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                locationProvider.currentPosition?.latitude ?? 0,
                locationProvider.currentPosition?.longitude ?? 0,
              ),
              zoom: 14,
            ),
            markers: _markers,
            circles: _circles, // Privacy circles layer
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          
          if (_isGeneratingMarkers)
            const Positioned(
              top: 50,
              left: 20,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 10),
                      Text("Updating discovery map...", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
            
          Positioned(
            right: 20,
            bottom: 120,
            child: Column(
              children: [
                _mapActionButton(Icons.filter_list_rounded, () {}),
                const SizedBox(height: 16),
                _mapActionButton(Icons.my_location_rounded, () async {
                  final controller = await _controller.future;
                  if (locationProvider.currentPosition != null) {
                    controller.animateCamera(CameraUpdate.newLatLng(
                      LatLng(locationProvider.currentPosition!.latitude, locationProvider.currentPosition!.longitude),
                    ));
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapActionButton(IconData icon, VoidCallback onTap) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: onTap,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.trustBlue,
      elevation: 4,
      child: Icon(icon),
    );
  }
}

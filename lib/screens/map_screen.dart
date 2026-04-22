import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
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

      newCircles.add(
        Circle(
          circleId: CircleId('zone_${hangout.id}'),
          center: LatLng(hangout.meetingZone.latitude, hangout.meetingZone.longitude),
          radius: 500,
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

    _updateMapElements(hangoutProvider.hangouts);

    return LayoutBuilder(
      builder: (context, constraints) {
        return LiquidGlassView(
          backgroundWidget: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                locationProvider.currentPosition?.latitude ?? 0,
                locationProvider.currentPosition?.longitude ?? 0,
              ),
              zoom: 14,
            ),
            markers: _markers,
            circles: _circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          children: [
            // Status Card (Liquid)
            if (_isGeneratingMarkers)
              LiquidGlass(
                width: 200,
                height: 50,
                position: const LiquidGlassAlignPosition(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20, top: 50),
                ),
                magnification: 1.1,
                distortion: 0.1,
                shape: const RoundedRectangleShape(cornerRadius: 12),
                color: Colors.white.withValues(alpha: 0.1),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 10),
                      Text("Updating Map...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

            // Map Action Buttons (Liquid Lenses)
            LiquidGlass(
              width: 56,
              height: 128,
              position: const LiquidGlassAlignPosition(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(right: 20, bottom: 120),
              ),
              magnification: 1.2,
              distortion: 0.2,
              chromaticAberration: 0.008,
              shape: const RoundedRectangleShape(cornerRadius: 28),
              color: Colors.white.withValues(alpha: 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _mapActionButton(Icons.filter_list_rounded, () {}),
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
        );
      },
    );
  }

  Widget _mapActionButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: AppColors.trustBlue),
      onPressed: onTap,
    );
  }
}

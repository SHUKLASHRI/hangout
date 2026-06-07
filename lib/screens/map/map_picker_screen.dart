import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/location_provider.dart';
import '../../core/theme.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final initialPos = LatLng(
      locationProvider.currentPosition?.latitude ?? 0,
      locationProvider.currentPosition?.longitude ?? 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Meeting Point"),
        actions: [
          if (_selectedLocation != null)
            TextButton(
              onPressed: () => Navigator.pop(context, GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude)),
              child: const Text("CONFIRM", style: TextStyle(color: AppColors.vibrantOrange, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: initialPos, zoom: 16),
            onTap: (pos) => setState(() => _selectedLocation = pos),
            myLocationEnabled: true,
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLocation!,
                    )
                  }
                : {},
          ),
          const Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Tap the map to set the exact meeting point. This will only be revealed to users after they join.",
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:glass_kit/glass_kit.dart';
import '../theme/app_theme.dart';
import '../models/seed_data.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'today';
  static const LatLng _bangalore = LatLng(12.9716, 77.5946);

  Set<Marker> _getMarkers() {
    return SEEDED_HANGOUTS.map((hangout) {
      return Marker(
        markerId: MarkerId(hangout.id),
        position: hangout.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange), // Social Orange Pins
        infoWindow: InfoWindow(
          title: hangout.title,
          snippet: '${hangout.category} • ${hangout.time}',
          onTap: () => context.push('/hangout/${hangout.id}'),
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 900;
          
          return Row(
            children: [
              if (isDesktop) _buildSidebar(constraints),
              Expanded(
                child: Stack(
                  children: [
                    // The Google Map
                    GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: _bangalore,
                        zoom: 13,
                      ),
                      markers: _getMarkers(),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),

                    // Floating Header
                    Positioned(
                      top: 40,
                      left: 16,
                      right: 16,
                      child: _buildFloatingHeader(),
                    ),

                    // Bottom Banner (Mobile only or floating on web)
                    if (!isDesktop)
                      Positioned(
                        bottom: 100,
                        left: 16,
                        right: 16,
                        child: _buildGuestBanner(),
                      ),
                    
                    // FAB
                    Positioned(
                      bottom: 30,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: AppColors.secondary,
                        child: const Icon(LucideIcons.plus, size: 30, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSidebar(BoxConstraints constraints) {
    return Container(
      width: 350,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text("Discover Hangouts", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) => _buildHangoutCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHangoutCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: const Text("Strategy Games Night"),
        subtitle: const Text("7:00 PM • 3 Spots left"),
        trailing: const Icon(LucideIcons.chevronRight),
        onTap: () {},
      ),
    );
  }

  Widget _buildFloatingHeader() {
    return Column(
      children: [
        GlassContainer.clearGlass(
          height: 56,
          width: double.infinity,
          borderColor: AppColors.border,
          color: AppColors.surface.withValues(alpha: 0.8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(LucideIcons.search, size: 20, color: AppColors.textSecondary),
                SizedBox(width: 12),
                Text("Search for hangouts...", style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: ['1H', '3H', 'TODAY', 'WEEK'].map((label) {
            final bool isActive = _selectedFilter == label.toLowerCase();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => setState(() => _selectedFilter = label.toLowerCase()),
                child: GlassContainer.clearGlass(
                  height: 36,
                  width: 80,
                  color: isActive ? AppColors.primary : AppColors.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  borderWidth: 1,
                  borderColor: isActive ? AppColors.primary : AppColors.border,
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGuestBanner() {
    return GlassContainer.frostedGlass(
      height: 80,
      width: double.infinity,
      borderRadius: BorderRadius.circular(16),
      borderWidth: 1,
      borderColor: AppColors.border,
      color: AppColors.surface.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Expanded(
              child: Text("Join hangouts and meet new people!", style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            ElevatedButton(
              onPressed: () => context.push('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                minimumSize: const Size(100, 40),
              ),
              child: const Text("Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}

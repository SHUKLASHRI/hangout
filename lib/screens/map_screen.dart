import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  Set<Marker> _getMarkers() {
    return SEEDED_HANGOUTS.map((hangout) {
      return Marker(
        markerId: MarkerId(hangout.id),
        position: hangout.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
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
                      mapToolbarEnabled: false,
                    ),

                    // Floating Header (Search & Filters)
                    Positioned(
                      top: 40,
                      left: 16,
                      right: 16,
                      child: _buildFloatingHeader()
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: -0.2, end: 0, curve: Curves.easeOutBack),
                    ),

                    // Mobile Sliding Panel
                    if (!isDesktop) _buildDraggableSheet(),
                    
                    // FAB (Pulse Animation for "Host")
                    Positioned(
                      bottom: isDesktop ? 32 : 110,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: AppColors.secondary,
                        elevation: 4,
                        child: const Icon(LucideIcons.plus, size: 28, color: Colors.white),
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                       .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds, curve: Curves.easeInOut),
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

  Widget _buildDraggableSheet() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return GlassContainer.frostedGlass(
          height: double.infinity,
          width: double.infinity,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          borderColor: AppColors.border,
          color: AppColors.surface.withValues(alpha: 0.9),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  itemCount: SEEDED_HANGOUTS.length,
                  itemBuilder: (context, index) => _buildHangoutCard(SEEDED_HANGOUTS[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BoxConstraints constraints) {
    return Container(
      width: 380,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 60, 24, 24),
            child: Text(
              "Discover Nearby",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: SEEDED_HANGOUTS.length,
              itemBuilder: (context, index) => _buildHangoutCard(SEEDED_HANGOUTS[index])
                .animate()
                .fadeIn(delay: (100 * index).ms)
                .slideX(begin: -0.1, end: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHangoutCard(hangout) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(LucideIcons.users, color: AppColors.primary),
        ),
        title: Text(hangout.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${hangout.time} • ${hangout.category}", style: const TextStyle(color: AppColors.textSecondary)),
        trailing: const Icon(LucideIcons.chevronRight, size: 18),
        onTap: () => context.push('/hangout/${hangout.id}'),
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
          color: AppColors.surface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(LucideIcons.search, size: 20, color: AppColors.textSecondary),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for activities...",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                VerticalDivider(indent: 12, endIndent: 12),
                Icon(LucideIcons.slidersHorizontal, size: 20, color: AppColors.primary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['NOW', '3H', 'TODAY', 'WEEKEND', 'ALL'].map((label) {
              final bool isActive = _selectedFilter == label.toLowerCase();
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => setState(() => _selectedFilter = label.toLowerCase()),
                  child: GlassContainer.clearGlass(
                    height: 40,
                    width: 90,
                    color: isActive ? AppColors.primary : AppColors.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    borderColor: isActive ? AppColors.primary : AppColors.border,
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../models/hangout_model.dart';
import '../providers/hangout_provider.dart';
import '../widgets/liquid_glass_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<HangoutProvider>(
        builder: (context, provider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 800;
              final int crossAxisCount = isWide ? (constraints.maxWidth > 1200 ? 3 : 2) : 1;

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    expandedHeight: 120,
                    backgroundColor: AppColors.background,
                    flexibleSpace: const FlexibleSpaceBar(
                      title: Text(
                        'Discover Feed',
                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                      titlePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.slidersHorizontal, color: AppColors.trustBlue),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  if (provider.isLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: AppColors.trustBlue)),
                    )
                  else if (provider.hangouts.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.map, size: 64, color: AppColors.textPlaceholder),
                            const SizedBox(height: 16),
                            Text(
                              'No hangouts nearby!',
                              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to create one.',
                              style: GoogleFonts.inter(color: AppColors.textPlaceholder),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(24),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: isWide ? 280 : 160,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final hangout = provider.hangouts[index];
                            return _buildFeedCard(context, hangout, isWide)
                              .animate()
                              .fadeIn(delay: (index * 50).ms, duration: 400.ms)
                              .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic);
                          },
                          childCount: provider.hangouts.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFeedCard(BuildContext context, HangoutModel hangout, bool isWide) {
    return GestureDetector(
      onTap: () => context.push('/hangout/${hangout.id}'),
      child: LiquidGlassCard(
        padding: EdgeInsets.zero,
        color: AppColors.trustBlue,
        child: isWide ? _buildVerticalLayout(hangout) : _buildHorizontalLayout(hangout),
      ),
    );
  }

  Widget _buildVerticalLayout(HangoutModel hangout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.glassBase,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(child: Icon(LucideIcons.image, size: 48, color: AppColors.textPlaceholder)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hangout.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 14, color: AppColors.trustBlue),
                  const SizedBox(width: 4),
                  Text(hangout.type.name.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const Spacer(),
                  Text("${hangout.hostTrustScore} ★", style: const TextStyle(color: AppColors.safetyGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(HangoutModel hangout) {
    final timeString = "${hangout.scheduledAt.hour}:${hangout.scheduledAt.minute.toString().padLeft(2, '0')}";
    
    return Row(
      children: [
        Container(
          width: 120,
          decoration: const BoxDecoration(
            color: AppColors.glassBase,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
          ),
          child: const Center(child: Icon(LucideIcons.image, color: AppColors.textPlaceholder)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hangout.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(timeString, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.socialOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text("Join Now", style: TextStyle(color: AppColors.socialOrange, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    Text('${hangout.participantIds.length}/${hangout.maxParticipants} ', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const CircleAvatar(radius: 12, backgroundColor: AppColors.surfaceElevated, child: Icon(LucideIcons.user, size: 14, color: AppColors.trustBlue)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

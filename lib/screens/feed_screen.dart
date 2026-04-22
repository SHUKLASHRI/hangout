import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/seed_data.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../widgets/glass_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
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
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Discover Feed',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.slidersHorizontal, color: AppColors.trustBlue),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
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
                      final hangout = SEEDED_HANGOUTS[index % SEEDED_HANGOUTS.length];
                      return _buildFeedCard(context, hangout, isWide)
                        .animate()
                        .fadeIn(delay: (index * 50).ms, duration: 400.ms)
                        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic);
                    },
                    childCount: 15, // Demonstration count
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeedCard(BuildContext context, dynamic hangout, bool isWide) {
    return GestureDetector(
      onTap: () => context.push('/hangout/${hangout.id}'),
      child: GlassCard(
        padding: EdgeInsets.zero,
        tintColor: AppColors.trustBlue,
        child: isWide ? _buildVerticalLayout(hangout) : _buildHorizontalLayout(hangout),
      ),
    );
  }

  Widget _buildVerticalLayout(dynamic hangout) {
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
              Text(hangout.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 14, color: AppColors.trustBlue),
                  const SizedBox(width: 4),
                  Text(hangout.category, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const Spacer(),
                  const Text("4.9 ★", style: TextStyle(color: AppColors.safetyGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(dynamic hangout) {
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
                Text(hangout.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(hangout.time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                    const CircleAvatar(radius: 12, child: Icon(LucideIcons.user, size: 14)),
                    const SizedBox(width: -4),
                    const CircleAvatar(radius: 12, backgroundColor: AppColors.surfaceElevated, child: Icon(LucideIcons.user, size: 14)),
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

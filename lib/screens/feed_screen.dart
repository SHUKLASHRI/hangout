import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/seed_data.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

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
                    icon: const Icon(LucideIcons.slidersHorizontal, color: AppColors.primary),
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
    if (isWide) {
      // Desktop vertical card
      return InkWell(
        onTap: () => context.push('/hangout/${hangout.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: const Center(child: Icon(LucideIcons.image, size: 48, color: AppColors.border)),
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
                        const Icon(LucideIcons.mapPin, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(hangout.category, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        const Spacer(),
                        const Text("4.9 ★", style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Mobile horizontal card
      return InkWell(
        onTap: () => context.push('/hangout/${hangout.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                ),
                child: const Center(child: Icon(LucideIcons.image, color: AppColors.border)),
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
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text("Join Now", style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const Spacer(),
                          const CircleAvatar(radius: 12, child: Icon(LucideIcons.user, size: 14)),
                          const SizedBox(width: -4),
                          const CircleAvatar(radius: 12, backgroundColor: AppColors.border, child: Icon(LucideIcons.user, size: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glass_kit/glass_kit.dart';

class HangoutDetailScreen extends StatelessWidget {
  final String id;
  const HangoutDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 900;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          body: isWide ? _buildDesktopLayout(context) : _buildMobileLayout(context),
          bottomNavigationBar: isWide ? null : _buildStickyBottomBar(context),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppColors.primary,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
            child: const BackButton(color: AppColors.textPrimary),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.surface,
              child: const Icon(LucideIcons.image, size: 80, color: AppColors.border),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildMainContent(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left Column: Navigation & Content
        Expanded(
          flex: 3,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                leading: const BackButton(color: AppColors.textPrimary),
                title: const Text("Hangout Details", style: TextStyle(color: AppColors.textPrimary)),
                floating: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(40),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderImage(600),
                      const SizedBox(height: 40),
                      _buildMainContent(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Right Column: Side Panel (Participants & CTA)
        Container(
          width: 400,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(left: BorderSide(color: AppColors.border)),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Host", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildHostCard(),
              const SizedBox(height: 40),
              const Text("Participants", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildParticipantList(),
              const Spacer(),
              _buildStickyBottomBar(context, isFloating: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderImage(double width) {
    return Container(
      height: 350,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(child: Icon(LucideIcons.image, size: 80, color: AppColors.border)),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("STRATEGY GAMES", style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
            const Icon(LucideIcons.shieldCheck, color: AppColors.success, size: 20),
            const SizedBox(width: 4),
            const Text("Verified Host", style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ).animate().fadeIn().slideX(),
        const SizedBox(height: 16),
        const Text(
          "Strategy Night at Third Wave",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            _buildIconInfo(LucideIcons.calendar, "Today, 7:00 PM"),
            _buildIconInfo(LucideIcons.users, "4 / 6 Spots Filled"),
            _buildIconInfo(LucideIcons.mapPin, "Indiranagar, Bangalore"),
          ],
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 40),
        const Text("About this Hangout", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text(
          "Join us for an evening of deep strategy and friendly competition. We usually play Catan or Ticket to Ride. Newcomers are always welcome, we're happy to teach the rules!",
          style: TextStyle(color: AppColors.textSecondary, height: 1.6, fontSize: 16),
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 40),
        _buildLockedLocationCard(),
      ],
    );
  }

  Widget _buildIconInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildLockedLocationCard() {
    return GlassContainer.frostedGlass(
      height: 100,
      width: double.infinity,
      borderRadius: BorderRadius.circular(16),
      borderColor: AppColors.border,
      color: AppColors.surface.withValues(alpha: 0.8),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(LucideIcons.lock, color: AppColors.secondary, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location Hidden", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Exact point revealed after host approval", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().shimmer(delay: 1.seconds, duration: 2.seconds);
  }

  Widget _buildHostCard() {
    return Row(
      children: [
        const CircleAvatar(radius: 24, child: Icon(LucideIcons.user)),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sagar Shukla", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Trust Score: 4.98 ★", style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(LucideIcons.messageCircle, color: AppColors.primary)),
      ],
    );
  }

  Widget _buildParticipantList() {
    return Column(
      children: List.generate(4, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            CircleAvatar(radius: 16, backgroundColor: AppColors.background, child: const Icon(LucideIcons.user, size: 16)),
            const SizedBox(width: 12),
            const Text("Participant Name", style: TextStyle(fontSize: 14)),
          ],
        ),
      )),
    );
  }

  Widget _buildStickyBottomBar(BuildContext context, {bool isFloating = false}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: isFloating ? null : const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          minimumSize: const Size.fromHeight(60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.zap, size: 20),
            SizedBox(width: 12),
            Text("I'M FREE - REQUEST TO JOIN", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
      ).animate().scale(delay: 500.ms, begin: const Offset(0.9, 0.9), curve: Curves.elasticOut),
    );
  }
}

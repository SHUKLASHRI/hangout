import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import '../widgets/liquid_glass_card.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final user = auth.userModel;
          
          if (auth.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.trustBlue));
          }

          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.userX, size: 64, color: AppColors.textPlaceholder),
                  const SizedBox(height: 16),
                  const Text('Not Logged In', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => auth.logout(), // Or navigate to login
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, auth),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildHeader(user),
                      const SizedBox(height: 24),
                      _buildTrustCard(user),
                      const SizedBox(height: 24),
                      _buildStatsGrid(user),
                      const SizedBox(height: 32),
                      _buildActionList(context, auth),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AuthProvider auth) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.background,
      title: Text('My Identity', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.settings, color: AppColors.textSecondary),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeader(UserModel user) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.trustBlue, AppColors.trustBlue.withValues(alpha: 0.3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                radius: 54,
                backgroundColor: AppColors.surfaceElevated,
                backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null ? const Icon(LucideIcons.user, size: 40) : null,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                child: const Icon(LucideIcons.check, color: Colors.white, size: 14),
              ),
            ),
          ],
        ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 16),
        Text(
          user.displayName,
          style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        Text(
          user.campus.isNotEmpty ? user.campus : 'University of Engineering',
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTrustCard(UserModel user) {
    final score = user.trustScore;
    String label = 'Neutral';
    Color color = Colors.orange;
    
    if (score >= 4.5) {
      label = 'Elite Identity';
      color = AppColors.success;
    } else if (score >= 3.5) {
      label = 'Highly Trusted';
      color = AppColors.trustBlue;
    }

    return LiquidGlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(28),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TRUST SCORE', style: GoogleFonts.inter(letterSpacing: 1.5, fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPlaceholder)),
                const SizedBox(height: 4),
                Text(label, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 8),
                Text('Your score is calculated based on attendance and peer reviews.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: score / 5.0,
                  strokeWidth: 8,
                  backgroundColor: AppColors.glassBase,
                  color: color,
                ),
              ),
              Text(
                score.toStringAsFixed(1),
                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0);
  }

  Widget _buildStatsGrid(UserModel user) {
    return Row(
      children: [
        Expanded(child: _buildStatItem('Completed', user.hangsCompleted.toString(), LucideIcons.calendarCheck2, AppColors.trustBlue)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatItem('No-Shows', user.noShows.toString(), LucideIcons.userMinus, Colors.redAccent)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildActionList(BuildContext context, AuthProvider auth) {
    return Column(
      children: [
        _buildActionItem(LucideIcons.user, 'Personal Information', () {}),
        _buildActionItem(LucideIcons.shieldCheck, 'Verification Status', () {}),
        _buildActionItem(LucideIcons.history, 'Hangout History', () {}),
        _buildActionItem(LucideIcons.heart, 'Saved Activities', () {}),
        const SizedBox(height: 24),
        TextButton.icon(
          onPressed: () => auth.logout(),
          icon: const Icon(LucideIcons.logOut, size: 18, color: Colors.redAccent),
          label: Text('SIGN OUT', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.redAccent, letterSpacing: 1)),
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.glassBase, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.trustBlue, size: 20),
        ),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
        trailing: const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}

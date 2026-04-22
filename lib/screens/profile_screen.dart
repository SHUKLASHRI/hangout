import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            tintColor: AppColors.trustBlue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.glassBase,
                  child: Icon(LucideIcons.user, size: 40, color: AppColors.trustBlue),
                ),
                const SizedBox(height: 24),
                const Text("Alex Developer", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.safetyGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Trust Score: 4.9 ★",
                    style: TextStyle(color: AppColors.safetyGreen, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 48),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.logOut, size: 18),
                  label: const Text("SIGN OUT"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    side: const BorderSide(color: AppColors.glassBorder),
                    foregroundColor: AppColors.textSecondary,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

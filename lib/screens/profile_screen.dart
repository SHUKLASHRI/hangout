import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.background,
              child: Icon(LucideIcons.user, size: 40, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            const Text("Alex Developer", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Trust Score: 4.9 ★", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.logOut, size: 18),
              label: const Text("Sign Out"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.border),
              ),
            )
          ],
        ),
      ),
    );
  }
}

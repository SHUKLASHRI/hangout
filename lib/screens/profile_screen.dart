import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../widgets/liquid_glass_card.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Header
              const LiquidGlassCard(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Alex Developer",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Settings Options
              _buildProfileOption(
                icon: LucideIcons.user,
                label: 'Edit Profile',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildProfileOption(
                icon: LucideIcons.shieldCheck,
                label: 'Privacy & Security',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildProfileOption(
                icon: LucideIcons.settings,
                label: 'App Settings',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildProfileOption(
                icon: LucideIcons.lifeBuoy,
                label: 'Help & Support',
                onTap: () {},
              ),
              
              const SizedBox(height: 32),
              
              // Sign Out
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.logOut, size: 18),
                label: const Text("SIGN OUT"),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return LiquidGlassCard(
      borderRadius: 16,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.trustBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.trustBlue, size: 20),
        ),
        title: Text(
          label,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        trailing: const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}

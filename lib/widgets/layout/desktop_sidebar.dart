import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../providers/app_state.dart';

class DesktopSidebar extends StatelessWidget {
  final AppStateProvider state;

  const DesktopSidebar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.trustBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          _buildLogoSection(),
          const Divider(color: Colors.white12, indent: 24, endIndent: 24),
          const SizedBox(height: 8),
          _sidebarItem(context, 0, LucideIcons.map, 'Map Discovery'),
          _sidebarItem(context, 1, LucideIcons.layoutList, 'Social Feed'),
          _sidebarItem(context, 2, LucideIcons.messageSquare, 'Realtime Chat'),
          _sidebarItem(context, 3, LucideIcons.user, 'My Profile'),
          const Spacer(),
          _buildHostButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.handshake_rounded, color: AppColors.vibrantOrange, size: 28),
          ),
          const SizedBox(width: 12),
          const Text(
            'HANGOUT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton.icon(
        onPressed: () => context.push('/create'),
        icon: const Icon(LucideIcons.plus, size: 18),
        label: const Text('Host a Hangout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.vibrantOrange,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _sidebarItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = state.currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.vibrantOrange : Colors.white.withValues(alpha: 0.65),
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.65),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () => context.go(state.getRoutePath(index)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../providers/app_state.dart';
import '../liquid_glass_card.dart';

class MobileNavbar extends StatelessWidget {
  final AppStateProvider state;

  const MobileNavbar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: LiquidGlassCard(
        borderRadius: BorderRadius.circular(45),
        opacity: 0.1,
        blur: 15,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, 0, LucideIcons.house, 'Home'),
              _navItem(context, 1, LucideIcons.search, 'Explore'),
              _buildCenterAction(context),
              _navItem(context, 2, LucideIcons.messageSquare, 'Chat'),
              _navItem(context, 3, LucideIcons.user, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterAction(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFFB923C)]),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF97316).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.plus, color: Colors.white, size: 24),
            onPressed: () => context.push('/create'),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hangout',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF97316),
          ),
        ),
      ],
    );
  }

  Widget _navItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = state.currentIndex == index;
    final color = isSelected ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF);

    return GestureDetector(
      onTap: () => context.go(state.getRoutePath(index)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

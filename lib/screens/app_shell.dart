import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/liquid_glass_card.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final routerState = GoRouterState.of(context);
    state.syncIndexWithRoute(routerState.matchedLocation);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              Row(
                children: [
                  if (isDesktop) _buildSidebar(context, state),
                  Expanded(child: child),
                ],
              ),
              if (!isDesktop)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  right: 20,
                  child: _buildTopRightAlerts(context),
                ),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : _buildGlassNavBar(context, state, constraints),
        );
      },
    );
  }

  Widget _buildTopRightAlerts(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(LucideIcons.bell, color: AppColors.trustBlue),
        onPressed: () {
          // Open notifications
        },
      ),
    );
  }

  Widget _buildGlassNavBar(BuildContext context, AppStateProvider state, BoxConstraints constraints) {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: LiquidGlassCard(
        borderRadius: 45,
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
              _navItem(context, state, 0, LucideIcons.house, 'Home'),
              _navItem(context, state, 1, LucideIcons.search, 'Explore'),
              _buildCenterAction(context),
              _navItem(context, state, 2, LucideIcons.messageSquare, 'Chat'),
              _navItem(context, state, 3, LucideIcons.user, 'Profile'),
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

  Widget _navItem(BuildContext context, AppStateProvider state, int index, IconData icon, String label) {
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

  Widget _buildSidebar(BuildContext context, AppStateProvider state) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.trustBlue,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.handshake_rounded, color: AppColors.socialOrange, size: 28),
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
          ),
          const Divider(color: Colors.white12, indent: 24, endIndent: 24),
          const SizedBox(height: 8),
          _sidebarItem(context, state, 0, LucideIcons.map, 'Map Discovery'),
          _sidebarItem(context, state, 1, LucideIcons.layoutList, 'Social Feed'),
          _sidebarItem(context, state, 2, LucideIcons.messageSquare, 'Realtime Chat'),
          _sidebarItem(context, state, 3, LucideIcons.user, 'My Profile'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/create'),
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text('Host a Hangout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.socialOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sidebarItem(BuildContext context, AppStateProvider state, int index, IconData icon, String label) {
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
          color: isSelected ? AppColors.socialOrange : Colors.white.withValues(alpha: 0.65),
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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';

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
          body: Row(
            children: [
              if (isDesktop) _buildSidebar(context, state),
              Expanded(child: child),
            ],
          ),
          floatingActionButton: isDesktop ? null : _buildFAB(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: isDesktop ? null : _buildGlassNavBar(context, state, constraints),
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: AppColors.socialOrange,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.socialOrange.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(LucideIcons.plus, color: Colors.white, size: 28),
        onPressed: () => context.push('/create'),
      ),
    );
  }

  Widget _buildGlassNavBar(BuildContext context, AppStateProvider state, BoxConstraints constraints) {
    return Container(
      // Fixed height — will never collapse or overflow
      height: 80,
      margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              // Slightly opaque so it always shows even if blur isn't available
              color: AppColors.trustBlue.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(context, state, 0, LucideIcons.map, 'Map'),
                _navItem(context, state, 1, LucideIcons.layoutList, 'Feed'),
                const SizedBox(width: 56), // Spacer for FAB
                _navItem(context, state, 2, LucideIcons.messageSquare, 'Chat'),
                _navItem(context, state, 3, LucideIcons.user, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, AppStateProvider state, int index, IconData icon, String label) {
    final isSelected = state.currentIndex == index;
    return GestureDetector(
      onTap: () => context.go(state.getRoutePath(index)),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.socialOrange.withValues(alpha: 0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.socialOrange : Colors.white.withValues(alpha: 0.55),
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.55),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
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

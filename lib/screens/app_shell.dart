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
    
    // Keep provider in sync with router
    state.syncIndexWithRoute(routerState.matchedLocation);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        return Scaffold(
          body: Row(
            children: [
              if (isDesktop) _buildSidebar(context, state),
              Expanded(child: child),
            ],
          ),
          // M1-B1: The +Create tab triggers a modal, but for the Shell we use a FAB on mobile
          floatingActionButton: isDesktop ? null : _buildFAB(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: isDesktop ? null : _buildGlassBottomNavBar(context, state),
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        color: AppColors.socialOrange,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.socialOrange.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(LucideIcons.plus, color: Colors.white, size: 32),
        onPressed: () => context.push('/create'),
      ),
    );
  }

  Widget _buildGlassBottomNavBar(BuildContext context, AppStateProvider state) {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.trustBlue.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(context, state, 0, LucideIcons.map, 'Map'),
                _navItem(context, state, 1, LucideIcons.layoutList, 'Feed'),
                const SizedBox(width: 40), // Spacer for FAB
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.socialOrange : Colors.white.withValues(alpha: 0.5),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, AppStateProvider state) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: AppColors.trustBlue,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Text(
              'HANGOUT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
          _sidebarItem(context, state, 0, LucideIcons.map, 'Map Discovery'),
          _sidebarItem(context, state, 1, LucideIcons.layoutList, 'Social Feed'),
          _sidebarItem(context, state, 2, LucideIcons.messageSquare, 'Realtime Chat'),
          _sidebarItem(context, state, 3, LucideIcons.user, 'Team Profile'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.plus),
              label: const Text('Host New Hangout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.socialOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
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
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.socialOrange : Colors.white.withValues(alpha: 0.6),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => context.go(state.getRoutePath(index)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
    );
  }
}

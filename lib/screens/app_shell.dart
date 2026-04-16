import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 900;

        return Scaffold(
          body: Row(
            children: [
              if (isDesktop) _buildSidebar(context),
              Expanded(child: child),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : _buildBottomNavBar(context),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'HANGOUT',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          _sidebarItem(context, 'Explore', LucideIcons.map, '/', location == '/'),
          _sidebarItem(context, 'Feed', LucideIcons.layoutList, '/feed', location == '/feed'),
          _sidebarItem(context, 'Chats', LucideIcons.messageSquare, '/chats', location == '/chats'),
          _sidebarItem(context, 'Profile', LucideIcons.user, '/profile', location == '/profile'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text('Host Hangout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(BuildContext context, String label, IconData icon, String path, bool isSelected) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => context.go(path),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location == '/feed') currentIndex = 1;
    if (location == '/chats') currentIndex = 2;
    if (location == '/profile') currentIndex = 3;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/'); break;
            case 1: context.go('/feed'); break;
            case 2: context.go('/chats'); break;
            case 3: context.go('/profile'); break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.map), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.layoutList), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.messageSquare), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
        ],
      ),
    );
  }
}

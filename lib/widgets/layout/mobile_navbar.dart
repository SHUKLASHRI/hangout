import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
      padding: const EdgeInsets.only(
        bottom: AppConstants.spacing4,
        left: AppConstants.spacing4,
        right: AppConstants.spacing4,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Modern Glass Navigation Bar
          LiquidGlassCard(
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
            opacity: 0.08,
            blur: 20,
            color: AppColors.trustBlue,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                border: Border.all(
                  color: AppColors.surfaceElevated.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navItem(context, 0, LucideIcons.house, 'Home'),
                  _navItem(context, 1, LucideIcons.compass, 'Explore'),
                  SizedBox(width: AppConstants.spacing6),
                  _navItem(context, 2, LucideIcons.messageSquare, 'Chat'),
                  _navItem(context, 3, LucideIcons.user, 'Profile'),
                ],
              ),
            ),
          ),
          // Floating Action Button
          Positioned(
            bottom: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vibrantOrange.withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push('/create'),
                  customBorder: const CircleBorder(),
                  child: const Center(
                    child: Icon(
                      LucideIcons.plus,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = state.currentIndex == index;

    return GestureDetector(
      onTap: () => context.go(state.getRoutePath(index)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppConstants.spacing3),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.trustBlue.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.trustBlue : AppColors.textTertiary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.trustBlue : AppColors.textTertiary,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

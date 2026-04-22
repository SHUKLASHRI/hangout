import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Minimum display time for splash animation
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final auth = context.read<AuthProvider>();

    // Wait for Firebase auth state to be determined (max 5 extra seconds)
    int waited = 0;
    while (auth.isLoading && waited < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      waited++;
      if (!mounted) return;
    }

    if (!mounted) return;

    if (!auth.isLoggedIn) {
      context.go('/login');
    } else if (auth.userModel?.onboardingCompleted == false) {
      context.go('/onboarding');
    } else {
      context.go('/map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trustBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: const Icon(
                Icons.handshake_rounded,
                color: AppColors.socialOrange,
                size: 64,
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 800.ms,
              curve: Curves.easeInOut,
            )
            .boxShadow(
              begin: const BoxShadow(color: Colors.transparent),
              end: BoxShadow(
                color: AppColors.socialOrange.withValues(alpha: 0.3),
                blurRadius: 20,
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'HANGOUT',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                letterSpacing: 8,
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.2, end: 0)
            .shimmer(delay: 1200.ms, duration: 1500.ms, color: AppColors.socialOrange.withValues(alpha: 0.5)),

            const SizedBox(height: 8),

            Text(
              'TRUST · SOCIAL · SAFETY',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white54,
                letterSpacing: 2,
              ),
            )
            .animate(delay: 500.ms)
            .fadeIn(duration: 800.ms),
          ],
        ),
      ),
    );
  }
}

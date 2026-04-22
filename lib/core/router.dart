import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/hangout/create_screen.dart';
import '../screens/hangout_detail_screen.dart'; // Added for G15
import '../screens/feed_screen.dart';
import '../screens/map_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/app_shell.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      
      // Auth & Onboarding
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Hangout Core (G14, G15)
      GoRoute(
        path: '/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateHangoutScreen(),
      ),
      GoRoute(
        path: '/hangout/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => HangoutDetailScreen(
          id: state.pathParameters['id']!,
        ),
      ),
      
      // Main App Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/map',
            pageBuilder: (context, state) => _customFadeTransition(
              state,
              const MapScreen(),
            ),
          ),
          GoRoute(
            path: '/feed',
            pageBuilder: (context, state) => _customFadeTransition(
              state,
              const FeedScreen(),
            ),
          ),
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => _customFadeTransition(
              state,
              const ChatScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => _customFadeTransition(
              state,
              const ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );

  static CustomTransitionPage _customFadeTransition(GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }
}

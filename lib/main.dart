import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'screens/app_shell.dart';
import 'screens/map_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/hangout_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HangoutApp());
}

class HangoutApp extends StatelessWidget {
  const HangoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp.router(
        title: 'HANGOUT',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          },
        ),
      ),
    );
  }
}

// Helper for premium page transitions
CustomTransitionPage _buildPageTransition({required Widget child, required GoRouterState state}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _buildPageTransition(
        state: state,
        child: const LoginScreen(),
      ),
    ),

    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildPageTransition(
            state: state,
            child: const MapScreen(),
          ),
        ),
        GoRoute(
          path: '/feed',
          pageBuilder: (context, state) => _buildPageTransition(
            state: state,
            child: const FeedScreen(),
          ),
        ),
        GoRoute(
          path: '/chats',
          pageBuilder: (context, state) => _buildPageTransition(
            state: state,
            child: const ChatScreen(id: 'general'),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => _buildPageTransition(
            state: state,
            child: const ProfileScreen(),
          ),
        ),
      ],
    ),

    GoRoute(
      path: '/hangout/:id',
      pageBuilder: (context, state) => _buildPageTransition(
        state: state,
        child: HangoutDetailScreen(
          id: state.pathParameters['id']!,
        ),
      ),
    ),
  ],
);

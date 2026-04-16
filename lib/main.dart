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
        theme: AppTheme.lightTheme, // Using the new Trust + Social Light Theme
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

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Main App Shell Routes
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          path: '/feed',
          builder: (context, state) => const FeedScreen(),
        ),
        GoRoute(
          path: '/chats',
          builder: (context, state) => const ChatScreen(id: 'general'),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Details Routes (outside shell for full screen focus)
    GoRoute(
      path: '/hangout/:id',
      builder: (context, state) => HangoutDetailScreen(
        id: state.pathParameters['id']!,
      ),
    ),
  ],
);

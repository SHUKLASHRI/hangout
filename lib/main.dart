import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme.dart';
import 'core/router.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/hangout_service.dart';
import 'services/location_service.dart';
import 'services/trust_service.dart';
import 'services/notification_service.dart'; // Added for G18
import 'providers/auth_provider.dart';
import 'providers/app_state.dart';
import 'providers/hangout_provider.dart';
import 'providers/location_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not initialized yet: $e');
  }

  // Core Services
  final authService = AuthService();
  final firestoreService = FirestoreService();
  final hangoutService = HangoutService();
  final locationService = LocationService();
  final trustService = TrustService();
  final notificationService = NotificationService();

  // Initialize Notifications
  await notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        Provider<AuthService>.value(value: authService),
        Provider<FirestoreService>.value(value: firestoreService),
        Provider<HangoutService>.value(value: hangoutService),
        Provider<LocationService>.value(value: locationService),
        Provider<TrustService>.value(value: trustService),
        Provider<NotificationService>.value(value: notificationService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, firestoreService),
        ),
        ChangeNotifierProvider(
          create: (_) => HangoutProvider(hangoutService),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(locationService),
        ),
      ],
      child: const HangoutApp(),
    ),
  );
}

class HangoutApp extends StatelessWidget {
  const HangoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HANGOUT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}

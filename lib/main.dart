import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme.dart';
import 'core/router.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/hangout_service.dart';
import 'services/location_service.dart';
import 'services/trust_service.dart';
import 'services/notification_service.dart';
import 'providers/auth_provider.dart';
import 'providers/app_state.dart';
import 'providers/hangout_provider.dart';
import 'providers/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase — must succeed for auth to work
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCbXKjrR-ru2QQwciyPjbakCj8UNjB7Rfg",
        appId: "1:250263355121:web:c9ecc70294aecba17bb350",
        messagingSenderId: "250263355121",
        projectId: "hangout-72488",
        authDomain: "hangout-72488.firebaseapp.com",
        storageBucket: "hangout-72488.firebasestorage.app",
        databaseURL: "https://hangout-72488-default-rtdb.asia-southeast1.firebasedatabase.app",
        measurementId: "G-H0FWBZNZJQ",
      ),
    );
  } catch (e) {
    debugPrint('[HANGOUT] Firebase init error: $e');
    // App will still launch; auth provider handles the error state gracefully
  }

  // Core Services
  final authService = AuthService();
  final firestoreService = FirestoreService();
  final hangoutService = HangoutService();
  final locationService = LocationService();
  final trustService = TrustService();
  final notificationService = NotificationService();

  // Notifications are NOT supported on Flutter Web — guard here
  if (!kIsWeb) {
    try {
      await notificationService.init();
    } catch (e) {
      debugPrint('[HANGOUT] Notification init error: $e');
    }
  }

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

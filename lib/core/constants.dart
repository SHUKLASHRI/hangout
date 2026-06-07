import 'package:flutter/material.dart';

class AppConstants {
  // Collection Names
  static const String usersCollection = 'users';
  static const String hangoutsCollection = 'hangouts';
  static const String ratingsCollection = 'ratings';
  static const String reportsCollection = 'reports';

  // ============ DESIGN TOKENS ============
  // Radius - Modern rounded corners
  static const double radiusXs = 8.0;
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;
  
  // Spacing - 4px base unit
  static const double spacing1 = 4.0;
  static const double spacing2 = 8.0;
  static const double spacing3 = 12.0;
  static const double spacing4 = 16.0;
  static const double spacing5 = 20.0;
  static const double spacing6 = 24.0;
  static const double spacing8 = 32.0;
  
  // Legacy compatibility
  static const double cardRadius = radiusLg;
  static const double chipRadius = radiusMd;
  static const double fabRadius = radiusMd;
  static const double paddingPage = spacing6;
  
  // ============ ANIMATIONS ============
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration slowAnimation = Duration(milliseconds: 600);
  static const double animFast = 200.0; // ms
  
  // ============ MAP CONSTANTS ============
  static const double checkInRadiusMeters = 200.0;
  static const double zonePrivacyRadiusMeters = 500.0;
  static const double defaultMapZoom = 14.0;
  
  // ============ SHADOWS (Design System) ============
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 1)),
  ];
  
  static const List<BoxShadow> shadowMd = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
  
  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 4)),
  ];
  
  static const List<BoxShadow> shadowXl = [
    BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 8)),
  ];
}

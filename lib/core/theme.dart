import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors (Psychology-driven)
  static const Color trustBlue = Color(0xFF2563EB);    // Primary: Reliability
  static const Color socialOrange = Color(0xFFF97316); // Secondary: Social Energy
  static const Color safetyGreen = Color(0xFF22C55E);  // Success: Positive Outcome
  
  // Surface Colors
  static const Color background = Color(0xFFF3F4F6);
  static const Color surface = Colors.white;
  static const Color surfaceElevated = Color(0xFFE5E7EB);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textPlaceholder = Color(0xFF9CA3AF);
  
  // Liquid Glass Tokens (Tinted Bases)
  static const Color glassBase = Color(0x1AFFFFFF); // 10% white
  static const Color glassBlue = Color(0x1A2563EB); // 10% Blue tint
  static const Color glassOrange = Color(0x1AF97316); // 10% Orange tint
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white

  // Aliases for compatibility
  static const Color primary = trustBlue;
  static const Color secondary = socialOrange;
  static const Color success = safetyGreen;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.trustBlue,
        primary: AppColors.trustBlue,
        secondary: AppColors.socialOrange,
        surface: AppColors.surface,
        error: const Color(0xFFEF4444), // Standard Error
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.socialOrange, // Social Energy as CTA
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

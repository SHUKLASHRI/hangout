import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Modern Brand Palette
  static const Color trustBlue = Color(0xFF1E40AF);    // Deep, trustworthy blue
  static const Color vibrantOrange = Color(0xFFEA6E00); // Energetic orange
  static const Color emeraldGreen = Color(0xFF059669);  // Trust/success indicator
  static const Color brightPurple = Color(0xFF7C3AED);  // Accent/highlights
  
  // Premium Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E40AF), Color(0xFF1E3A8A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFEA6E00), Color(0xFFC2410C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Surface Colors - Refined
  static const Color background = Color(0xFFFAFAFB);
  static const Color surface = Colors.white;
  static const Color surfaceDim = Color(0xFFF3F4F6);
  static const Color surfaceElevated = Color(0xFFE5E7EB);
  
  // Text Colors - Professional
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textPlaceholder = Color(0xFFCBD5E1);
  
  // Semantic Colors
  static const Color success = emeraldGreen;
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = trustBlue;
  
  // Glass Effect Colors
  static const Color glassBase = Color(0x08FFFFFF);
  static const Color glassBlue = Color(0x0D1E40AF);
  static const Color glassOrange = Color(0x0DEA6E00);
  static const Color glassBorder = Color(0x1AFFFFFF);

  // Aliases
  static const Color primary = trustBlue;
  static const Color secondary = vibrantOrange;
  static const Color accent = brightPurple;
}

class AppConstants {
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
  static const double radiusCard = radiusLg;
  static const double radiusChip = radiusMd;
  static const double paddingPage = spacing6;
  static const double animFast = 200.0;
  
  // Shadows
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

class AppTheme {
  static ThemeData get lightTheme {
    const textColorScheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.textPrimary,
      ),
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textTertiary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: AppColors.textTertiary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.trustBlue,
        brightness: Brightness.light,
        primary: AppColors.trustBlue,
        onPrimary: Colors.white,
        secondary: AppColors.vibrantOrange,
        onSecondary: Colors.white,
        tertiary: AppColors.brightPurple,
        onTertiary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      
      // Text Theme with Google Fonts
      textTheme: GoogleFonts.outfitTextTheme(textColorScheme),
      
      // Card Styling
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        shadowColor: const Color(0x1A000000),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.vibrantOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.vibrantOrange.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing6,
            vertical: AppConstants.spacing3,
          ),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.trustBlue,
          side: const BorderSide(color: AppColors.trustBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing6,
            vertical: AppConstants.spacing3,
          ),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.trustBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing4,
            vertical: AppConstants.spacing2,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDim,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing4,
          vertical: AppConstants.spacing3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.surfaceElevated,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.surfaceElevated,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.trustBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textPlaceholder,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // App Bar
      appBarTheme: AppBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
        scrolledUnderElevation: 1,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      
      // Tab Bar
      tabBarTheme: const TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.trustBlue,
            width: 3,
          ),
        ),
        indicatorColor: AppColors.trustBlue,
        labelColor: AppColors.trustBlue,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelColor: AppColors.textTertiary,
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceElevated,
        thickness: 1,
        space: 16,
      ),
      
      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.trustBlue,
        linearMinHeight: 4,
        circularTrackColor: AppColors.surfaceElevated,
      ),
    );
  }
}

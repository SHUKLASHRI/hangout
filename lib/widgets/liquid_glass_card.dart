import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/theme.dart';

/// A premium glassmorphism widget that provides a frosted glass effect
/// with high compatibility across Web and Mobile.
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double blur;
  final double opacity;
  final double borderRadius;
  final Color? borderColor;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.blur = 15.0,
    this.opacity = 0.1,
    this.borderRadius = AppConstants.radiusCard,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Glass Blur layer
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  color: Colors.white.withValues(alpha: opacity),
                ),
              ),
            ),
            
            // Content
            child,
          ],
        ),
      ),
    );
  }
}

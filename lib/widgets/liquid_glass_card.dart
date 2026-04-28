import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/theme.dart';

/// A premium glassmorphism widget that provides a frosted glass effect
/// with high compatibility across Web and Mobile.
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? color;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.blur = 15.0,
    this.opacity = 0.1,
    this.borderRadius,
    this.borderColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(AppConstants.radiusCard);
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: Stack(
          children: [
            // Glass Blur layer
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  color: (color ?? Colors.white).withValues(alpha: opacity),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

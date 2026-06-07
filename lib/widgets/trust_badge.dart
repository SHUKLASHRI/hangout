import 'package:flutter/material.dart';
import '../core/theme.dart';

class TrustBadge extends StatelessWidget {
  final double score;
  final bool showLabel;

  const TrustBadge({
    super.key,
    required this.score,
    this.showLabel = true,
  });

  Color _getScoreColor() {
    if (score >= 4.0) return AppColors.success;
    if (score >= 3.0) return AppColors.vibrantOrange;
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars_rounded, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            score.toStringAsFixed(1),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              'Trust',
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

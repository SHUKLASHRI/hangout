import 'package:flutter/material.dart';
import '../models/hangout_model.dart';
import '../core/theme.dart';

class ActivityChip extends StatelessWidget {
  final ActivityType type;

  const ActivityChip({super.key, required this.type});

  String _getEmoji() {
    switch (type) {
      case ActivityType.food: return '🍕';
      case ActivityType.sport: return '🏸';
      case ActivityType.study: return '📚';
      case ActivityType.explore: return '🗺️';
      case ActivityType.music: return '🎵';
      case ActivityType.gaming: return '🎮';
      default: return '✨';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.trustBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_getEmoji(), style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            type.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColors.trustBlue,
            ),
          ),
        ],
      ),
    );
  }
}

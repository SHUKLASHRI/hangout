import 'package:flutter/material.dart';
import '../../models/hangout_model.dart';
import '../../core/theme.dart';

class HangoutMarkerWidget extends StatelessWidget {
  final HangoutModel hangout;

  const HangoutMarkerWidget({
    super.key,
    required this.hangout,
  });

  String _getEmoji() {
    switch (hangout.type) {
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
    final spotsLeft = hangout.maxParticipants - hangout.participantIds.length;
    final isFull = spotsLeft <= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isFull ? Colors.grey.shade700 : AppColors.socialOrange,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getEmoji(),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isFull ? 'FULL' : '$spotsLeft/${hangout.maxParticipants}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

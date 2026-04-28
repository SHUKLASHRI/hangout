import 'package:flutter/material.dart';
import '../models/hangout_model.dart';
import '../core/theme.dart';
import 'activity_chip.dart';
import 'trust_badge.dart';
import 'liquid_glass_card.dart';

class HangoutCard extends StatelessWidget {
  final HangoutModel hangout;
  final VoidCallback onTap;

  const HangoutCard({
    super.key,
    required this.hangout,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spotsLeft = hangout.maxParticipants - hangout.participantIds.length;
    final isFull = spotsLeft <= 0;

    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassCard(
        padding: const EdgeInsets.all(16),
        color: AppColors.trustBlue, // Base trust for feed items
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActivityChip(type: hangout.type),
                TrustBadge(score: hangout.hostTrustScore),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              hangout.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  _formatTime(hangout.scheduledAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFull ? Colors.grey.shade100 : AppColors.socialOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isFull ? 'FULL' : '$spotsLeft spots left',
                    style: TextStyle(
                      color: isFull ? Colors.grey.shade600 : AppColors.socialOrange,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.surfaceElevated,
                  child: Text(
                    hangout.hostName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Hosted by ${hangout.hostName}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);
    if (difference.inMinutes < 60) return 'In ${difference.inMinutes} mins';
    if (difference.inHours < 24) return 'Today at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    return '${time.day}/${time.month} at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

import 'package:flutter/material.dart';
import '../models/hangout_model.dart';
import '../core/theme.dart';
import 'activity_chip.dart';
import 'trust_badge.dart';
import 'liquid_glass_card.dart';

class HangoutCard extends StatefulWidget {
  final HangoutModel hangout;
  final VoidCallback onTap;

  const HangoutCard({
    super.key,
    required this.hangout,
    required this.onTap,
  });

  @override
  State<HangoutCard> createState() => _HangoutCardState();
}

class _HangoutCardState extends State<HangoutCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final spotsLeft = widget.hangout.maxParticipants - widget.hangout.participantIds.length;
    final isFull = spotsLeft <= 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              boxShadow: _isHovered
                  ? AppConstants.shadowXl
                  : AppConstants.shadowMd,
            ),
            child: LiquidGlassCard(
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              padding: const EdgeInsets.all(AppConstants.spacing5),
              color: AppColors.trustBlue,
              blur: 10,
              opacity: 0.05,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.8),
                      Colors.white.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Activity and Trust Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ActivityChip(type: widget.hangout.type),
                        TrustBadge(score: widget.hangout.hostTrustScore),
                      ],
                    ),
                    SizedBox(height: AppConstants.spacing4),
                    
                    // Hangout Title
                    Text(
                      widget.hangout.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppConstants.spacing2),
                    
                    // Time & Availability Row
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.vibrantOrange,
                        ),
                        SizedBox(width: AppConstants.spacing2),
                        Expanded(
                          child: Text(
                            _formatTime(widget.hangout.scheduledAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: AppConstants.spacing2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacing3,
                            vertical: AppConstants.spacing1,
                          ),
                          decoration: BoxDecoration(
                            color: isFull
                                ? AppColors.danger.withValues(alpha: 0.1)
                                : AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                          ),
                          child: Text(
                            isFull ? '🔴 FULL' : '🟢 $spotsLeft spots',
                            style: TextStyle(
                              color: isFull ? AppColors.danger : AppColors.success,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppConstants.spacing4),
                    
                    // Host Info
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacing3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDim,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              widget.hangout.hostName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: AppConstants.spacing3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hosted by',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                Text(
                                  widget.hangout.hostName,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);
    
    if (difference.inMinutes < 60) {
      return 'In ${difference.inMinutes}m';
    }
    if (difference.inHours < 24) {
      return 'Today at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    if (difference.inDays < 7) {
      return '${_getDayName(time.weekday)} at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    
    return '${time.day}/${time.month} at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}

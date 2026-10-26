import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../models/hangout_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/hangout_provider.dart';
import '../../core/theme.dart';
import '../../core/error_handler.dart';
import '../../widgets/liquid_glass_card.dart';
import '../../widgets/trust_badge.dart';
import '../../widgets/activity_chip.dart';
import 'hangout/rating_screen.dart';

class HangoutDetailScreen extends StatelessWidget {
  final String id;
  const HangoutDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final hangoutProvider = context.watch<HangoutProvider>();
    
    // Find the hangout safely in the local stream
    HangoutModel? hangout;
    for (final h in hangoutProvider.hangouts) {
      if (h.id == id) {
        hangout = h;
        break;
      }
    }

    if (hangout == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.pop(),
          ),
          title: const Text("Hangout Details"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.mapPinOff, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                const Text(
                  "Hangout not found or is no longer active",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text("Go Back"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentUid = auth.userModel?.uid ?? auth.firebaseUser?.uid;
    final isParticipant = currentUid != null && hangout.participantIds.contains(currentUid);
    final isHost = currentUid != null && hangout.hostId == currentUid;
    final rawSpots = hangout.maxParticipants - hangout.participantIds.length;
    final spotsLeft = rawSpots > 0 ? rawSpots : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildImmersiveHeader(context, hangout),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHostSection(hangout),
                  const SizedBox(height: 32),
                  _buildInfoSection(hangout, spotsLeft),
                  const SizedBox(height: 32),
                  _buildDescriptionSection(hangout),
                  const SizedBox(height: 32),
                  _buildLocationRevealSection(hangout, isParticipant || isHost),
                  const SizedBox(height: 32),
                  _buildParticipantSection(hangout),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildActionButton(context, hangout, isParticipant, isHost, currentUid),
    );
  }

  Widget _buildImmersiveHeader(BuildContext context, HangoutModel hangout) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.trustBlue,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.trustBlue,
                AppColors.trustBlue.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActivityChip(type: hangout.type).animate().scale(delay: 200.ms),
                const SizedBox(height: 16),
                Text(
                  hangout.title,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHostSection(HangoutModel hangout) {
    final initial = hangout.hostName.isNotEmpty ? hangout.hostName[0].toUpperCase() : 'H';
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.vibrantOrange.withValues(alpha: 0.1),
            child: Text(initial, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.vibrantOrange)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hangout.hostName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("HOST", style: TextStyle(fontSize: 10, letterSpacing: 1, color: AppColors.textSecondary)),
              ],
            ),
          ),
          TrustBadge(score: hangout.hostTrustScore),
        ],
      ),
    );
  }

  Widget _buildInfoSection(HangoutModel hangout, int spotsLeft) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _infoItem(LucideIcons.calendar, "Time", "${hangout.scheduledAt.hour}:${hangout.scheduledAt.minute.toString().padLeft(2, '0')}"),
        _infoItem(LucideIcons.users, "Spots", "$spotsLeft Left"),
        _infoItem(LucideIcons.shieldCheck, "Trust", "Verified"),
      ],
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.vibrantOrange, size: 24),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDescriptionSection(HangoutModel hangout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("ABOUT THIS HANGOUT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Text(
          hangout.description.isEmpty ? "No description provided." : hangout.description,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildLocationRevealSection(HangoutModel hangout, bool isRevealed) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(20),
      color: isRevealed ? AppColors.success : AppColors.vibrantOrange,
      child: Row(
        children: [
          Icon(
            isRevealed ? LucideIcons.mapPin : LucideIcons.lock,
            color: isRevealed ? AppColors.success : AppColors.vibrantOrange,
            size: 28,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRevealed ? "Meeting Point Revealed" : "Location Hidden",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  isRevealed 
                    ? "See you at the exact location shown on your map."
                    : "Join this hangout to reveal the exact meeting point.",
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantSection(HangoutModel hangout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("PARTICIPANTS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hangout.participantIds.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.surfaceElevated,
                  child: const Icon(LucideIcons.user, size: 16, color: AppColors.textSecondary),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, HangoutModel hangout, bool isParticipant, bool isHost, String? uid) {
    final isExpired = DateTime.now().isAfter(hangout.expiresAt);

    if (isExpired && (isParticipant || isHost)) {
      return _bottomAction("RATE PARTICIPANTS", AppColors.success, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RatingScreen(
              hangout: hangout,
              targetUid: hangout.hostId,
              targetName: hangout.hostName,
            ),
          ),
        );
      });
    }

    if (isHost) {
      return _bottomAction("CANCEL HANGOUT", Colors.red, () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Cancel Hangout?"),
            content: const Text("Are you sure you want to cancel this hangout? All participants will be notified."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("No")),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Yes, Cancel", style: TextStyle(color: Colors.red))),
            ],
          ),
        );

        if (confirm == true && context.mounted) {
          try {
            await context.read<HangoutProvider>().cancel(hangout.id);
            if (context.mounted) {
              ErrorHandler.showSuccess(context, "Hangout cancelled successfully");
              context.pop();
            }
          } catch (e) {
            if (context.mounted) {
              ErrorHandler.showError(context, "Failed to cancel: $e");
            }
          }
        }
      });
    }

    if (isParticipant) {
      return _bottomAction("LEAVE HANGOUT", AppColors.textSecondary, () async {
        if (uid == null) {
          ErrorHandler.showError(context, "Please sign in to leave");
          return;
        }
        try {
          await context.read<HangoutProvider>().leave(hangout.id, uid);
          if (context.mounted) {
            ErrorHandler.showSuccess(context, "You left the hangout");
          }
        } catch (e) {
          if (context.mounted) {
            ErrorHandler.showError(context, "Failed to leave: $e");
          }
        }
      });
    }

    return _bottomAction("JOIN HANGOUT", AppColors.vibrantOrange, () async {
      if (uid == null) {
        ErrorHandler.showError(context, "Please sign in to join this hangout");
        context.push('/login');
        return;
      }
      try {
        await context.read<HangoutProvider>().join(hangout.id, uid);
        if (context.mounted) {
          ErrorHandler.showSuccess(context, "Successfully joined hangout!");
        }
      } catch (e) {
        if (context.mounted) {
          ErrorHandler.showError(context, "Failed to join: $e");
        }
      }
    });
  }

  Widget _bottomAction(String label, Color color, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size.fromHeight(60),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
    );
  }
}

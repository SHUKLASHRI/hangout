import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HangoutDetailScreen extends StatelessWidget {
  final String id;
  const HangoutDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: AppColors.white.withValues(alpha: 0.8),
          child: const BackButton(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image Placeholder
            Container(
              height: 250,
              width: double.infinity,
              color: AppColors.surface,
              child: const Icon(LucideIcons.image, size: 64, color: AppColors.border),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: const Text("BOARD GAMES", style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  const Text("Strategy Night at Third Wave", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                   Row(
                    children: [
                      Icon(LucideIcons.calendar, size: 16, color: AppColors.textSecondary),
                      SizedBox(width: 8),
                      Text("Today, 7:00 PM", style: TextStyle(color: AppColors.textSecondary)),
                      SizedBox(width: 24),
                      Icon(LucideIcons.users, size: 16, color: AppColors.textSecondary),
                      SizedBox(width: 8),
                      Text("4 / 6 Filter", style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text(
                    "Looking for 2 more people to join us for a night of strategy games. We have Settlers of Catan and Ticket to Ride ready to go!",
                    style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  const Text("Meeting Point", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(LucideIcons.lock, size: 20, color: AppColors.secondary),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Join to reveal the exact meeting point",
                            style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                          ),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.white,
          ),
          child: const Text("I'm Free"),
        ),
      ),
    );
  }
}

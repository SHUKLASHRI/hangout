import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Feed', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                  ),
                  child: const Center(child: Icon(LucideIcons.image, color: AppColors.textSecondary)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Weekend Hackathon", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text("Saturday, 10:00 AM", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            const Text("Tech Hub, Downtown", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text("Join", style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

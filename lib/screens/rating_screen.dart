import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RatingScreen extends StatefulWidget {
  final String id;
  const RatingScreen({super.key, required this.id});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Your Experience")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Icon(LucideIcons.user, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text("How was your hangout with Arjun?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Your feedback helps keep HANGOUT safe.", style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? LucideIcons.star : LucideIcons.star,
                    color: index < _rating ? AppColors.primary : AppColors.border,
                    size: 40,
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            const SizedBox(height: 48),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Add a private note about this user (optional)...",
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Submit Rating"),
            ),
          ],
        ),
      ),
    );
  }
}

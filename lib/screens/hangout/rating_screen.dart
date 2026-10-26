import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/hangout_model.dart';
import '../../models/rating_model.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme.dart';
import '../../core/error_handler.dart';
import '../../widgets/liquid_glass_card.dart';

class RatingScreen extends StatefulWidget {
  final HangoutModel hangout;
  final String targetUid;
  final String targetName;

  const RatingScreen({
    super.key,
    required this.hangout,
    required this.targetUid,
    required this.targetName,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_rating == 0) {
      ErrorHandler.showError(context, "Please select a star rating.");
      return;
    }

    final auth = context.read<AuthProvider>();
    final currentUid = auth.firebaseUser?.uid ?? auth.userModel?.uid;
    if (currentUid == null) {
      ErrorHandler.showError(context, "You must be signed in to submit a rating.");
      return;
    }
    if (currentUid == widget.targetUid) {
      ErrorHandler.showError(context, "You cannot rate yourself.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final ratingId = 'r_${DateTime.now().millisecondsSinceEpoch}_$currentUid';
      final ratingModel = RatingModel(
        id: ratingId,
        hangoutId: widget.hangout.id,
        fromUid: currentUid,
        toUid: widget.targetUid,
        score: _rating.toDouble(),
        comment: _commentController.text.trim().isNotEmpty ? _commentController.text.trim() : null,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(ratingId)
          .set(ratingModel.toMap());

      if (mounted) {
        ErrorHandler.showSuccess(context, "Rating submitted for ${widget.targetName}!");
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ErrorHandler.showError(context, "Failed to submit rating: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.targetName.isNotEmpty ? widget.targetName[0].toUpperCase() : 'U';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Rate Your Experience"), backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.surfaceElevated,
              child: Text(initial, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            Text(
              "How was your hangout with ${widget.targetName}?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Regarding: ${widget.hangout.title}",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            
            // Star Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final isSelected = index < _rating;
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isSelected ? AppColors.vibrantOrange : AppColors.textSecondary,
                    size: 48,
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 48),
            
            LiquidGlassCard(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Optional: Leave a public review about your experience...",
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const Spacer(),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.trustBlue,
                minimumSize: const Size.fromHeight(64),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("SUBMIT RATING", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

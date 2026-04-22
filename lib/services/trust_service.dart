import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rating_model.dart';

class TrustService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Recalculates and updates a user's trust score based on their ratings.
  /// Logic: Weighted average where recent ratings matter more (simulated).
  Future<void> recalculateTrust(String uid) async {
    final ratingsSnapshot = await _db.collection('ratings')
        .where('toUid', isEqualTo: uid)
        .get();

    if (ratingsSnapshot.docs.isEmpty) return;

    double totalScore = 0;
    int count = 0;

    for (var doc in ratingsSnapshot.docs) {
      final rating = RatingModel.fromFirestore(doc);
      // In a real scenario, we'd add weight based on recency
      totalScore += rating.score;
      count++;
    }

    final newTrustScore = double.parse((totalScore / count).toStringAsFixed(2));

    await _db.collection('users').doc(uid).update({
      'trustScore': newTrustScore,
      'totalRatings': count,
    });
  }

  /// Applies a penalty for late cancellations (within 1 hour of event)
  Future<void> applyPenalty(String uid, {double penalty = 0.1}) async {
    final userRef = _db.collection('users').doc(uid);
    
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      if (!snapshot.exists) return;

      final currentScore = snapshot.data()?['trustScore'] ?? 4.0;
      final newScore = (currentScore - penalty).clamp(0.0, 5.0);
      
      transaction.update(userRef, {
        'trustScore': double.parse(newScore.toStringAsFixed(2)),
      });
    });
  }

  /// Initialises a new user with the default trust score
  Future<void> initializeTrust(String uid) async {
    await _db.collection('users').doc(uid).update({
      'trustScore': 4.0,
      'totalRatings': 0,
    });
  }
}

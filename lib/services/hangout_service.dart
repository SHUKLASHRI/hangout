import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hangout_model.dart';
import '../core/constants.dart';

class HangoutService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of active hangouts
  Stream<List<HangoutModel>> streamActiveHangouts() {
    return _db.collection(AppConstants.hangoutsCollection)
        .where('status', isEqualTo: HangoutStatus.active.name)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => HangoutModel.fromFirestore(doc)).toList();
    });
  }

  // Create a new hangout (M2-B1)
  Future<void> createHangout(HangoutModel hangout) async {
    await _db.collection(AppConstants.hangoutsCollection).doc(hangout.id).set(hangout.toMap());
  }

  // Atomic Join (M2-B2)
  Future<void> joinHangout(String hangoutId, String uid) async {
    final hangoutRef = _db.collection(AppConstants.hangoutsCollection).doc(hangoutId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(hangoutRef);
      if (!snapshot.exists) throw Exception("Hangout not found");

      final hangout = HangoutModel.fromFirestore(snapshot);
      
      if (hangout.participantIds.length >= hangout.maxParticipants) {
        throw Exception("This hangout is full");
      }
      
      if (hangout.participantIds.contains(uid)) {
        throw Exception("You are already in this hangout");
      }

      final newParticipants = [...hangout.participantIds, uid];
      final newStatus = newParticipants.length >= hangout.maxParticipants 
          ? HangoutStatus.full.name 
          : HangoutStatus.active.name;

      transaction.update(hangoutRef, {
        'participantIds': newParticipants,
        'status': newStatus,
      });
    });
  }

  // Atomic Leave
  Future<void> leaveHangout(String hangoutId, String uid) async {
    final hangoutRef = _db.collection(AppConstants.hangoutsCollection).doc(hangoutId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(hangoutRef);
      if (!snapshot.exists) return;

      final hangout = HangoutModel.fromFirestore(snapshot);
      final newParticipants = hangout.participantIds.where((id) => id != uid).toList();

      transaction.update(hangoutRef, {
        'participantIds': newParticipants,
        'status': HangoutStatus.active.name, // Revert to active if it was full
      });
    });
  }

  // Cancel Hangout (Host Only)
  Future<void> cancelHangout(String hangoutId) async {
    await _db.collection(AppConstants.hangoutsCollection).doc(hangoutId).update({
      'status': HangoutStatus.cancelled.name,
    });
  }
}

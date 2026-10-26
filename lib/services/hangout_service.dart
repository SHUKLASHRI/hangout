import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hangout_model.dart';
import '../models/participation_model.dart';
import '../models/audit_log_model.dart';
import '../core/constants.dart';

class HangoutService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of active hangouts
  Stream<List<HangoutModel>> streamActiveHangouts({int limit = 50}) {
    return _db.collection(AppConstants.hangoutsCollection)
        .where('status', isEqualTo: HangoutStatus.active.name)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      final list = <HangoutModel>[];
      for (final doc in snapshot.docs) {
        try {
          list.add(HangoutModel.fromFirestore(doc));
        } catch (_) {}
      }
      return list;
    });
  }

  // Create a new hangout (M2-B1) with host participation and audit log
  Future<void> createHangout(HangoutModel hangout) async {
    final batch = _db.batch();

    final hangoutRef = _db.collection(AppConstants.hangoutsCollection).doc(hangout.id);
    batch.set(hangoutRef, hangout.toMap());

    // Associative Participation record for host
    final participationRef = _db.collection(AppConstants.participationsCollection)
        .doc('${hangout.id}_${hangout.hostId}');
    final hostParticipation = ParticipationModel(
      id: '${hangout.id}_${hangout.hostId}',
      hangoutId: hangout.id,
      userId: hangout.hostId,
      userDisplayName: hangout.hostName,
      role: ParticipationRole.host,
      status: ParticipationStatus.confirmed,
      joinedAt: DateTime.now(),
    );
    batch.set(participationRef, hostParticipation.toMap());

    // Immutable audit log
    final auditRef = _db.collection(AppConstants.auditLogsCollection).doc();
    final log = AuditLogModel(
      id: auditRef.id,
      action: 'create_hangout',
      actorUid: hangout.hostId,
      targetId: hangout.id,
      metadata: {'title': hangout.title, 'maxParticipants': hangout.maxParticipants},
      timestamp: DateTime.now(),
    );
    batch.set(auditRef, log.toMap());

    await batch.commit();
  }

  // Atomic Join (M2-B2) with OCC transaction
  Future<void> joinHangout(String hangoutId, String uid, {String userDisplayName = 'Participant'}) async {
    final hangoutRef = _db.collection(AppConstants.hangoutsCollection).doc(hangoutId);
    final participationRef = _db.collection(AppConstants.participationsCollection).doc('${hangoutId}_$uid');
    final auditRef = _db.collection(AppConstants.auditLogsCollection).doc();

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

      final participation = ParticipationModel(
        id: '${hangoutId}_$uid',
        hangoutId: hangoutId,
        userId: uid,
        userDisplayName: userDisplayName,
        role: ParticipationRole.attendee,
        status: ParticipationStatus.confirmed,
        joinedAt: DateTime.now(),
      );
      transaction.set(participationRef, participation.toMap());

      final log = AuditLogModel(
        id: auditRef.id,
        action: 'join_hangout',
        actorUid: uid,
        targetId: hangoutId,
        timestamp: DateTime.now(),
      );
      transaction.set(auditRef, log.toMap());
    });
  }

  // Atomic Leave
  Future<void> leaveHangout(String hangoutId, String uid) async {
    final hangoutRef = _db.collection(AppConstants.hangoutsCollection).doc(hangoutId);
    final participationRef = _db.collection(AppConstants.participationsCollection).doc('${hangoutId}_$uid');
    final auditRef = _db.collection(AppConstants.auditLogsCollection).doc();

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(hangoutRef);
      if (!snapshot.exists) return;

      final hangout = HangoutModel.fromFirestore(snapshot);
      final newParticipants = hangout.participantIds.where((id) => id != uid).toList();

      transaction.update(hangoutRef, {
        'participantIds': newParticipants,
        'status': HangoutStatus.active.name,
      });

      transaction.update(participationRef, {
        'status': ParticipationStatus.cancelled.name,
      });

      final log = AuditLogModel(
        id: auditRef.id,
        action: 'leave_hangout',
        actorUid: uid,
        targetId: hangoutId,
        timestamp: DateTime.now(),
      );
      transaction.set(auditRef, log.toMap());
    });
  }

  // Cancel Hangout (Host Only)
  Future<void> cancelHangout(String hangoutId, {String? hostUid}) async {
    final batch = _db.batch();
    final hangoutRef = _db.collection(AppConstants.hangoutsCollection).doc(hangoutId);
    batch.update(hangoutRef, {
      'status': HangoutStatus.cancelled.name,
    });

    if (hostUid != null) {
      final auditRef = _db.collection(AppConstants.auditLogsCollection).doc();
      final log = AuditLogModel(
        id: auditRef.id,
        action: 'cancel_hangout',
        actorUid: hostUid,
        targetId: hangoutId,
        timestamp: DateTime.now(),
      );
      batch.set(auditRef, log.toMap());
    }

    await batch.commit();
  }
}

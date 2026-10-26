import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/hangout_model.dart';
import '../models/user_model.dart';
import '../models/participation_model.dart';
import '../core/constants.dart';

class DatabaseInitService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Checks database connectivity and ensures collections are initialized
  Future<Map<String, dynamic>> checkDatabaseHealth() async {
    try {
      final hangoutsSnap = await _db.collection(AppConstants.hangoutsCollection).limit(1).get();
      return {
        'connected': true,
        'hangoutsCount': hangoutsSnap.size,
        'message': 'Firestore database online and responsive.',
      };
    } catch (e) {
      debugPrint('[DatabaseInitService] Health check error: $e');
      return {
        'connected': false,
        'error': e.toString(),
        'message': 'Failed to communicate with Firestore.',
      };
    }
  }

  /// Seeds initial verified community hangouts if the collection is empty
  Future<void> seedInitialDataIfEmpty() async {
    try {
      final snap = await _db.collection(AppConstants.hangoutsCollection).limit(1).get();
      if (snap.docs.isNotEmpty) {
        debugPrint('[DatabaseInitService] Database already contains data. Skipping seed.');
        return;
      }

      debugPrint('[DatabaseInitService] Empty database detected. Seeding verified starter hangouts...');
      final now = DateTime.now();
      final systemHostUid = 'sys_verified_host_01';

      // 1. Create a verified system host user profile
      final hostUser = UserModel(
        uid: systemHostUid,
        displayName: 'Campus Community Host',
        email: 'community@hangout.app',
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        bio: 'Official campus event organizer and verified community host.',
        interests: ['Coffee', 'Board Games', 'Study Sessions', 'Biking'],
        trustScore: 4.9,
        hangsCompleted: 42,
        noShows: 0,
        campus: 'Central Campus',
        isSuspended: false,
        canCreate: true,
        onboardingCompleted: true,
        createdAt: now.subtract(const Duration(days: 90)),
      );

      await _db.collection(AppConstants.usersCollection).doc(systemHostUid).set(hostUser.toMap());

      // 2. Starter hangouts across categories
      final starterHangouts = [
        HangoutModel(
          id: 'hangout_seed_coffee_chat',
          title: 'Morning Espresso & Tech Chat',
          description: 'Relaxed morning coffee, discussing Flutter, AI projects, and upcoming campus hacks.',
          type: ActivityType.food,
          scheduledAt: now.add(const Duration(hours: 3)),
          expiresAt: now.add(const Duration(hours: 6)),
          hostId: systemHostUid,
          hostName: hostUser.displayName,
          hostTrustScore: hostUser.trustScore,
          meetingPoint: const GeoPoint(37.7749, -122.4194),
          meetingZone: const GeoPoint(37.7749, -122.4194),
          maxParticipants: 6,
          participantIds: [systemHostUid],
          status: HangoutStatus.active,
        ),
        HangoutModel(
          id: 'hangout_seed_study_session',
          title: 'Midterm Study Jam & Boba',
          description: 'Quiet focus session at the library courtyard. Snacks and boba provided!',
          type: ActivityType.study,
          scheduledAt: now.add(const Duration(hours: 7)),
          expiresAt: now.add(const Duration(hours: 11)),
          hostId: systemHostUid,
          hostName: hostUser.displayName,
          hostTrustScore: hostUser.trustScore,
          meetingPoint: const GeoPoint(37.7833, -122.4167),
          meetingZone: const GeoPoint(37.7833, -122.4167),
          maxParticipants: 8,
          participantIds: [systemHostUid],
          status: HangoutStatus.active,
        ),
        HangoutModel(
          id: 'hangout_seed_board_games',
          title: 'Catan & Strategy Board Games',
          description: 'Friendly board games night. Beginners and experts welcome.',
          type: ActivityType.gaming,
          scheduledAt: now.add(const Duration(days: 1, hours: 2)),
          expiresAt: now.add(const Duration(days: 1, hours: 6)),
          hostId: systemHostUid,
          hostName: hostUser.displayName,
          hostTrustScore: hostUser.trustScore,
          meetingPoint: const GeoPoint(37.7690, -122.4467),
          meetingZone: const GeoPoint(37.7690, -122.4467),
          maxParticipants: 5,
          participantIds: [systemHostUid],
          status: HangoutStatus.active,
        ),
      ];

      final batch = _db.batch();
      for (final hangout in starterHangouts) {
        final ref = _db.collection(AppConstants.hangoutsCollection).doc(hangout.id);
        batch.set(ref, hangout.toMap());

        final partRef = _db.collection(AppConstants.participationsCollection).doc('${hangout.id}_$systemHostUid');
        final part = ParticipationModel(
          id: '${hangout.id}_$systemHostUid',
          hangoutId: hangout.id,
          userId: systemHostUid,
          userDisplayName: hostUser.displayName,
          role: ParticipationRole.host,
          status: ParticipationStatus.confirmed,
          joinedAt: now,
        );
        batch.set(partRef, part.toMap());
      }

      await batch.commit();
      debugPrint('[DatabaseInitService] Seeding completed successfully.');
    } catch (e) {
      debugPrint('[DatabaseInitService] Seeding failed: $e');
    }
  }
}

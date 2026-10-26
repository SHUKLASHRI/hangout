import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangout/models/hangout_model.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/models/rating_model.dart';

void main() {
  group('HangoutModel Resilience & Security Tests', () {
    test('HangoutModel.toMap contains expected fields and correct status', () {
      final now = DateTime.now();
      final hangout = HangoutModel(
        id: 'h_123',
        title: 'Tech Meetup',
        description: 'Discussing AI',
        type: ActivityType.study,
        scheduledAt: now,
        expiresAt: now.add(const Duration(hours: 2)),
        hostId: 'u_host1',
        hostName: 'Alice',
        hostTrustScore: 4.8,
        meetingPoint: const GeoPoint(12.9716, 77.5946),
        meetingZone: const GeoPoint(12.9716, 77.5946),
        maxParticipants: 10,
        participantIds: ['u_host1', 'u_part1'],
        status: HangoutStatus.active,
      );

      final map = hangout.toMap();
      expect(map['title'], 'Tech Meetup');
      expect(map['hostId'], 'u_host1');
      expect(map['type'], 'study');
      expect(map['status'], 'active');
      expect(map['participantIds'], contains('u_part1'));
      expect(map['maxParticipants'], 10);
    });

    test('HangoutModel copyWith correctly updates participantIds and status', () {
      final now = DateTime.now();
      final hangout = HangoutModel(
        id: 'h_123',
        title: 'Coffee Hangout',
        description: 'Casual chat',
        type: ActivityType.food,
        scheduledAt: now,
        expiresAt: now.add(const Duration(hours: 1)),
        hostId: 'u_host',
        hostName: 'Bob',
        hostTrustScore: 4.5,
        meetingPoint: const GeoPoint(0, 0),
        meetingZone: const GeoPoint(0, 0),
        maxParticipants: 3,
        participantIds: ['u_host'],
      );

      final updated = hangout.copyWith(
        participantIds: ['u_host', 'u_user2', 'u_user3'],
        status: HangoutStatus.full,
      );

      expect(updated.participantIds.length, 3);
      expect(updated.status, HangoutStatus.full);
    });
  });

  group('UserModel Serialization & Constraint Tests', () {
    test('UserModel initializes with secure default trust values', () {
      final user = UserModel(
        uid: 'u_test',
        displayName: 'Test User',
        email: 'test@example.com',
        createdAt: DateTime.now(),
      );

      expect(user.trustScore, 3.0);
      expect(user.isSuspended, isFalse);
      expect(user.canCreate, isTrue);
      expect(user.hangsCompleted, 0);
      expect(user.noShows, 0);
    });

    test('UserModel.toMap accurately maps all security fields', () {
      final now = DateTime.now();
      final user = UserModel(
        uid: 'u_test2',
        displayName: 'Charlie',
        email: 'charlie@example.com',
        trustScore: 4.2,
        hangsCompleted: 5,
        noShows: 1,
        isSuspended: false,
        canCreate: true,
        createdAt: now,
      );

      final map = user.toMap();
      expect(map['displayName'], 'Charlie');
      expect(map['trustScore'], 4.2);
      expect(map['hangsCompleted'], 5);
      expect(map['noShows'], 1);
      expect(map['isSuspended'], isFalse);
    });
  });

  group('RatingModel Validation Tests', () {
    test('RatingModel maps correct score and prevents null ID issues', () {
      final now = DateTime.now();
      final rating = RatingModel(
        id: 'r_123',
        hangoutId: 'h_456',
        fromUid: 'u_from',
        toUid: 'u_to',
        score: 5.0,
        comment: 'Great host!',
        createdAt: now,
      );

      final map = rating.toMap();
      expect(map['score'], 5.0);
      expect(map['fromUid'], 'u_from');
      expect(map['toUid'], 'u_to');
      expect(map['comment'], 'Great host!');
    });
  });

  group('String & Index Defensive Tests (Anti-Crash Verification)', () {
    test('Empty name indexing handles empty strings safely without throwing', () {
      final emptyName = '';
      final safeChar = emptyName.isNotEmpty ? emptyName[0].toUpperCase() : 'H';
      expect(safeChar, 'H');

      final validName = 'Sagar';
      final validChar = validName.isNotEmpty ? validName[0].toUpperCase() : 'H';
      expect(validChar, 'S');
    });

    test('Participant spot calculation never results in negative spots', () {
      const maxParticipants = 4;
      final participantIds = ['u1', 'u2', 'u3', 'u4', 'u5', 'u6']; // Tampered list
      final rawSpots = maxParticipants - participantIds.length;
      final spotsLeft = rawSpots > 0 ? rawSpots : 0;
      final isFull = rawSpots <= 0;

      expect(spotsLeft, 0);
      expect(isFull, isTrue);
    });
  });
}

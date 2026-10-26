import 'package:cloud_firestore/cloud_firestore.dart';

enum ParticipationStatus { confirmed, cancelled, attended, noShow }
enum ParticipationRole { host, attendee }

class ParticipationModel {
  final String id; // Composite: "${hangoutId}_${userId}"
  final String hangoutId;
  final String userId;
  final String userDisplayName;
  final String? userPhotoUrl;
  final ParticipationRole role;
  final ParticipationStatus status;
  final DateTime joinedAt;

  ParticipationModel({
    required this.id,
    required this.hangoutId,
    required this.userId,
    required this.userDisplayName,
    this.userPhotoUrl,
    this.role = ParticipationRole.attendee,
    this.status = ParticipationStatus.confirmed,
    required this.joinedAt,
  });

  factory ParticipationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final joinedTs = data['joinedAt'];
    return ParticipationModel(
      id: doc.id,
      hangoutId: data['hangoutId']?.toString() ?? '',
      userId: data['userId']?.toString() ?? '',
      userDisplayName: data['userDisplayName']?.toString() ?? 'Participant',
      userPhotoUrl: data['userPhotoUrl']?.toString(),
      role: ParticipationRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => ParticipationRole.attendee,
      ),
      status: ParticipationStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ParticipationStatus.confirmed,
      ),
      joinedAt: joinedTs is Timestamp ? joinedTs.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hangoutId': hangoutId,
      'userId': userId,
      'userDisplayName': userDisplayName,
      'userPhotoUrl': userPhotoUrl,
      'role': role.name,
      'status': status.name,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }
}

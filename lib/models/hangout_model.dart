import 'package:cloud_firestore/cloud_firestore.dart';

enum HangoutStatus { active, full, completed, cancelled }
enum ActivityType { food, sport, study, explore, music, gaming, other }

class HangoutModel {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final DateTime scheduledAt;
  final DateTime expiresAt;
  final String hostId;
  final String hostName;
  final double hostTrustScore;
  final GeoPoint meetingPoint; // Exact location (revealed on approval)
  final GeoPoint meetingZone;  // Approximate location (public)
  final int maxParticipants;
  final List<String> participantIds;
  final List<String> checkedInUids;
  final HangoutStatus status;

  HangoutModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.scheduledAt,
    required this.expiresAt,
    required this.hostId,
    required this.hostName,
    required this.hostTrustScore,
    required this.meetingPoint,
    required this.meetingZone,
    required this.maxParticipants,
    this.participantIds = const [],
    this.checkedInUids = const [],
    this.status = HangoutStatus.active,
  });

  factory HangoutModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HangoutModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: ActivityType.values.firstWhere(
        (e) => e.name == (data['type'] ?? 'other'),
        orElse: () => ActivityType.other,
      ),
      scheduledAt: (data['scheduledAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      hostId: data['hostId'] ?? '',
      hostName: data['hostName'] ?? '',
      hostTrustScore: (data['hostTrustScore'] ?? 0.0).toDouble(),
      meetingPoint: data['meetingPoint'] as GeoPoint,
      meetingZone: data['meetingZone'] as GeoPoint,
      maxParticipants: data['maxParticipants'] ?? 4,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      checkedInUids: List<String>.from(data['checkedInUids'] ?? []),
      status: HangoutStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'active'),
        orElse: () => HangoutStatus.active,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'hostId': hostId,
      'hostName': hostName,
      'hostTrustScore': hostTrustScore,
      'meetingPoint': meetingPoint,
      'meetingZone': meetingZone,
      'maxParticipants': maxParticipants,
      'participantIds': participantIds,
      'checkedInUids': checkedInUids,
      'status': status.name,
    };
  }

  HangoutModel copyWith({
    String? title,
    String? description,
    ActivityType? type,
    DateTime? scheduledAt,
    DateTime? expiresAt,
    List<String>? participantIds,
    List<String>? checkedInUids,
    HangoutStatus? status,
  }) {
    return HangoutModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      expiresAt: expiresAt ?? this.expiresAt,
      hostId: hostId,
      hostName: hostName,
      hostTrustScore: hostTrustScore,
      meetingPoint: meetingPoint,
      meetingZone: meetingZone,
      maxParticipants: maxParticipants,
      participantIds: participantIds ?? this.participantIds,
      checkedInUids: checkedInUids ?? this.checkedInUids,
      status: status ?? this.status,
    );
  }
}

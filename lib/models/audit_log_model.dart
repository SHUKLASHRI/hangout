import 'package:cloud_firestore/cloud_firestore.dart';

class AuditLogModel {
  final String id;
  final String action;
  final String actorUid;
  final String targetId;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  AuditLogModel({
    required this.id,
    required this.action,
    required this.actorUid,
    required this.targetId,
    this.metadata = const {},
    required this.timestamp,
  });

  factory AuditLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final ts = data['timestamp'];
    return AuditLogModel(
      id: doc.id,
      action: data['action']?.toString() ?? '',
      actorUid: data['actorUid']?.toString() ?? '',
      targetId: data['targetId']?.toString() ?? '',
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      timestamp: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'actorUid': actorUid,
      'targetId': targetId,
      'metadata': metadata,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

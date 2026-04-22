import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String id;
  final String hangoutId;
  final String fromUid;
  final String toUid;
  final double score;
  final String? comment;
  final DateTime createdAt;

  RatingModel({
    required this.id,
    required this.hangoutId,
    required this.fromUid,
    required this.toUid,
    required this.score,
    this.comment,
    required this.createdAt,
  });

  factory RatingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RatingModel(
      id: doc.id,
      hangoutId: data['hangoutId'] ?? '',
      fromUid: data['fromUid'] ?? '',
      toUid: data['toUid'] ?? '',
      score: (data['score'] ?? 0.0).toDouble(),
      comment: data['comment'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hangoutId': hangoutId,
      'fromUid': fromUid,
      'toUid': toUid,
      'score': score,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

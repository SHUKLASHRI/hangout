import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? bio;
  final List<String> interests;
  final double trustScore;
  final int hangsCompleted;
  final int noShows;
  final String campus;
  final bool isSuspended;
  final bool canCreate;
  final bool onboardingCompleted;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.bio,
    this.interests = const [],
    this.trustScore = 3.0,
    this.hangsCompleted = 0,
    this.noShows = 0,
    this.campus = '',
    this.isSuspended = false,
    this.canCreate = true,
    this.onboardingCompleted = false,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      interests: List<String>.from(data['interests'] ?? []),
      trustScore: (data['trustScore'] ?? 3.0).toDouble(),
      hangsCompleted: data['hangsCompleted'] ?? 0,
      noShows: data['noShows'] ?? 0,
      campus: data['campus'] ?? '',
      isSuspended: data['isSuspended'] ?? false,
      canCreate: data['canCreate'] ?? true,
      onboardingCompleted: data['onboardingCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'interests': interests,
      'trustScore': trustScore,
      'hangsCompleted': hangsCompleted,
      'noShows': noShows,
      'campus': campus,
      'isSuspended': isSuspended,
      'canCreate': canCreate,
      'onboardingCompleted': onboardingCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? bio,
    List<String>? interests,
    double? trustScore,
    int? hangsCompleted,
    int? noShows,
    String? campus,
    bool? isSuspended,
    bool? canCreate,
    bool? onboardingCompleted,
  }) {
    return UserModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      trustScore: trustScore ?? this.trustScore,
      hangsCompleted: hangsCompleted ?? this.hangsCompleted,
      noShows: noShows ?? this.noShows,
      campus: campus ?? this.campus,
      isSuspended: isSuspended ?? this.isSuspended,
      canCreate: canCreate ?? this.canCreate,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt,
    );
  }
}

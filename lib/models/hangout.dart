import 'package:cloud_firestore/cloud_firestore.dart';

class Hangout {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startTime;
  final DateTime endTime;
  final String hostId;
  final String hostName;
  final double hostRating;
  final LatLng location;
  final String? meetingPoint;
  final int maxParticipants;
  final List<String> participantIds;

  Hangout({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startTime,
    required this.endTime,
    required this.hostId,
    required this.hostName,
    required this.hostRating,
    required this.location,
    this.meetingPoint,
    required this.maxParticipants,
    required this.participantIds,
  });

  factory Hangout.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    GeoPoint geo = data['location']['geopoint'];
    
    return Hangout(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      hostId: data['hostId'] ?? '',
      hostName: data['hostName'] ?? '',
      hostRating: (data['hostRating'] ?? 0).toDouble(),
      location: LatLng(geo.latitude, geo.longitude),
      meetingPoint: data['meetingPoint'],
      maxParticipants: data['maxParticipants'] ?? 0,
      participantIds: List<String>.from(data['participants'] ?? []),
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;
  LatLng(this.latitude, this.longitude);
}

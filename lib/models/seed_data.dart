import 'package:google_maps_flutter/google_maps_flutter.dart';

class HangoutSeed {
  final String id;
  final String title;
  final LatLng position;
  final String category;
  final String time;

  HangoutSeed({
    required this.id,
    required this.title,
    required this.position,
    required this.category,
    required this.time,
  });
}

final List<HangoutSeed> SEEDED_HANGOUTS = [
  HangoutSeed(
    id: '1',
    title: 'Chai + Walk at Cubbon Park',
    position: const LatLng(12.9716, 77.5946),
    category: 'Walks',
    time: '4:00 PM',
  ),
  HangoutSeed(
    id: '2',
    title: 'Board Games at Third Wave',
    position: const LatLng(12.9780, 77.6408),
    category: 'Games',
    time: '7:00 PM',
  ),
  HangoutSeed(
    id: '3',
    title: 'Quick Cricket at HSR',
    position: const LatLng(12.9141, 77.6411),
    category: 'Sports',
    time: '6:30 PM',
  ),
];

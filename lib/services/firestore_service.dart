import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/hangout_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Methods
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Stream<UserModel?> streamUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  // Hangout Methods
  Stream<List<HangoutModel>> streamNearbyHangouts({int limit = 50}) {
    return _db.collection('hangouts')
        .where('status', isEqualTo: 'active')
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
}

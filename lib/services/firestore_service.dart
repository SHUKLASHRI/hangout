import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hangout.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Hangout>> streamHangouts() {
    return _db.collection('hangouts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Hangout.fromFirestore(doc)).toList();
    });
  }

  Future<void> createHangout(Map<String, dynamic> data) async {
    await _db.collection('hangouts').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> joinHangout(String hangoutId, String userId) async {
    await _db.collection('hangouts').doc(hangoutId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }
}

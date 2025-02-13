//// filepath: /d:/Flutter Apps/Mapper/mapper/lib/src/profile_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Expose the FirebaseFirestore instance as a public getter.
  FirebaseFirestore get db => FirebaseFirestore.instance;

  // Create or update a user profile.
  Future<void> setUserProfile({
    required String userId,
    required String username,
    required int xp,
    required int mapsPlayed,
    required int mapsCorrect,
  }) async {
    double ratio = mapsPlayed > 0 ? mapsCorrect / mapsPlayed : 0.0;
    await _db.collection('users').doc(userId).set({
      'username': username,
      'xp': xp,
      'mapsPlayed': mapsPlayed,
      'mapsCorrect': mapsCorrect,
      'ratio': ratio,
    }, SetOptions(merge: true));
  }

  // Get user profile by userId.
  Stream<DocumentSnapshot> getUserProfile(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }

  // Get leaderboard (top 10 by XP).
  Stream<QuerySnapshot> getLeaderboard() {
    return _db
        .collection('users')
        .orderBy('xp', descending: true)
        .limit(10)
        .snapshots();
  }
}
import 'package:firebase_database/firebase_database.dart';

class ProfileService {
  final DatabaseReference _db = FirebaseDatabase.instance.reference();

  // Create or update a user profile.
  Future<void> setUserProfile({
    required String userId,
    required String username,
    required int xp,
    required int mapsPlayed,
    required int mapsCorrect,
  }) async {
    double ratio = mapsPlayed > 0 ? mapsCorrect / mapsPlayed : 0.0;
    await _db.child('users').child(userId).set({
      'username': username,
      'xp': xp,
      'mapsPlayed': mapsPlayed,
      'mapsCorrect': mapsCorrect,
      'ratio': ratio,
    });
  }

  // Get user profile by userId.
  Stream<Event> getUserProfile(String userId) {
    return _db.child('users').child(userId).onValue;
  }

  // Get leaderboard (top 10 by XP).
  Stream<Event> getLeaderboard() {
    return _db
        .child('users')
        .orderByChild('xp')
        .limitToLast(10)
        .onValue;
  }
}
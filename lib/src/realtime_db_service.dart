//// filepath: /d:/Flutter Apps/Mapper/mapper/lib/src/realtime_db_service.dart
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Save or update a user's profile.
  Future<void> setUserProfile({
    required String userId,
    required String username,
    required int xp,
    required int mapsPlayed,
    required int mapsCorrect,
  }) async {
    double ratio = mapsPlayed > 0 ? mapsCorrect / mapsPlayed : 0.0;
    await _dbRef.child('users').child(userId).set({
      'username': username,
      'xp': xp,
      'mapsPlayed': mapsPlayed,
      'mapsCorrect': mapsCorrect,
      'ratio': ratio,
    });
  }

  // Retrieve a user's profile once.
  Future<DataSnapshot> getUserProfile(String userId) async {
    return await _dbRef.child('users').child(userId).get();
  }

  // Stream leaderboard updates (top 10 sorted by XP).
  Query getLeaderboard() {
    return _dbRef.child('users').orderByChild('xp').limitToLast(10);
  }

  // Update stats after a game.
  Future<void> updateUserStats({
    required String userId,
    required bool gameCorrect,
  }) async {
    DataSnapshot snapshot = await _dbRef.child('users').child(userId).get();
    int mapsPlayed = 0;
    int mapsCorrect = 0;
    int xp = 0;

    if (snapshot.exists && snapshot.value != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      mapsPlayed = data['mapsPlayed'] ?? 0;
      mapsCorrect = data['mapsCorrect'] ?? 0;
      xp = data['xp'] ?? 0;
    }

    mapsPlayed++;
    if (gameCorrect) {
      mapsCorrect++;
      xp += 100; // XP reward for correct answer.
    } else {
      xp += 20; // Base XP for playing.
    }

    await setUserProfile(
      userId: userId,
      username: 'UserName', // Replace with actual username.
      xp: xp,
      mapsPlayed: mapsPlayed,
      mapsCorrect: mapsCorrect,
    );
  }
}
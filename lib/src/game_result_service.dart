//// filepath: /d:/Flutter Apps/Mapper/mapper/lib/src/game_result_service.dart
import 'package:firebase_database/firebase_database.dart';
import 'profile_service.dart';

class GameResultService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> updateUserStats({
    required String userId,
    required bool gameCorrect,
  }) async {
    final userRef = _dbRef.child('users').child(userId);

    // Read current values
    final snapshot = await userRef.get();
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
      xp += 100;
    } else {
      xp += 20;
    }

    // Calculate accuracy
    double accuracy = mapsPlayed > 0 ? mapsCorrect / mapsPlayed : 0.0;

    // Update the stats
    await userRef.update({
      'mapsPlayed': mapsPlayed,
      'mapsCorrect': mapsCorrect,
      'xp': xp,
      'ratio': accuracy,
      // Optionally update or keep existing username
    });
  }
}
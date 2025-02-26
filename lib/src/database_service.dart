//// filepath: /D:/Flutter Apps/Mapper/mapper/lib/src/database_service.dart
import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'models.dart';
import 'package:collection/collection.dart'; // Import this for map conversion

Future<Map<String, dynamic>> fetchMapTitles() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('map_titles');
  DatabaseEvent event = await ref.once();

  if (event.snapshot.value != null && event.snapshot.value is Map<Object?, Object?>) {
    return deepMapToStringKey(event.snapshot.value as Map<Object?, Object?>);
  } else {
    throw Exception("Failed to load map titles");
  }
}

/// Recursively converts Map<Object?, Object?> to Map<String, dynamic>
Map<String, dynamic> deepMapToStringKey(Map<Object?, Object?> map) {
  return map.map((key, value) {
    return MapEntry(
      key.toString(), // Convert keys to String
      value is Map<Object?, Object?> ? deepMapToStringKey(value) : value, // Recursively convert nested maps
    );
  });
}


/// Returns a single [GameData] object (the first one from all available).
Future<GameData> fetchGameData() async {
  Map<String, dynamic> mapTitles = await fetchMapTitles();
  Random random = Random();
  int mapIndex = random.nextInt(mapTitles.length);
  String mapKey = 'map_$mapIndex';

  Map<String, dynamic> mapData = mapTitles[mapKey];
  String realTitle = mapData['real_title'];
  List<String> wrongTitles = List<String>.from(mapData['wrong_titles']);

  // Shuffle the choices and determine the correct one
  List<String> allTitles = [realTitle, ...wrongTitles];
  allTitles.shuffle(random);

  List<ChoiceData> choices = allTitles.map((title) {
    return ChoiceData(
      text: title,
      isCorrect: title == realTitle,
    );
  }).toList();

  return GameData(
    svgPath: 'assets/images/svg_maps/$mapKey.svg',
    choices: choices,
  );
}

/// Returns a list of randomly generated [GameData] objects.
/// For a quiz session, we randomly choose 5 images from all available images.
Future<List<GameData>> fetchQuizData() async {
  Map<String, dynamic> mapTitles = await fetchMapTitles();
  Random random = Random();

  List<int> availableImageIds = List.generate(mapTitles.length, (index) => index);
  availableImageIds.shuffle(random);
  List<int> quizImageIds = availableImageIds.take(5).toList();

  List<GameData> games = [];
  for (int id in quizImageIds) {
    String mapKey = 'map_$id';
    Map<String, dynamic> mapData = mapTitles[mapKey];
    String realTitle = mapData['real_title'];
    List<String> wrongTitles = List<String>.from(mapData['wrong_titles']);

    // Shuffle the choices and determine the correct one
    List<String> allTitles = [realTitle, ...wrongTitles];
    allTitles.shuffle(random);

    List<ChoiceData> choices = allTitles.map((title) {
      return ChoiceData(
        text: title,
        isCorrect: title == realTitle,
      );
    }).toList();

    games.add(GameData(
      svgPath: 'assets/images/svg_maps/$mapKey.svg',
      choices: choices,
    ));
  }

  return games;
}
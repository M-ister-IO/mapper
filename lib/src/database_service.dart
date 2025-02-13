//// filepath: /D:/Flutter Apps/Mapper/mapper/lib/src/database_service.dart
import 'dart:async';
import 'dart:math';
import 'models.dart';

/// Returns a single [GameData] object (the first one from all available).
Future<GameData> fetchGameData() async {
  List<GameData> games = await fetchAllGameData();
  return games.first;
}

/// Returns a list of randomly generated [GameData] objects.
Future<List<GameData>> fetchAllGameData() async {
  await Future.delayed(Duration(seconds: 1)); // Simulate network delay
  Random random = Random();
  List<GameData> games = [];
  
  // Generate 5 random game questions
  for (int i = 1; i <= 5; i++) {
    // Randomly choose which option will be correct
    int correctIndex = random.nextInt(4);
    
    // Generate 4 choices with random names
    List<ChoiceData> choices = List.generate(4, (j) {
      return ChoiceData(
        text: 'Option ${i}${String.fromCharCode(65 + j)}', 
        isCorrect: j == correctIndex,
      );
    });
    
    // Use the id (i) as a suffix for the image filename
    games.add(GameData(
      svgPath: 'assets/images/svg_maps/map_$i.svg',
      choices: choices,
    ));
  }
  
  return games;
}

/// Returns a list of randomly generated [GameData] objects.
/// For a quiz session, we randomly choose 5 images from all available images.
Future<List<GameData>> fetchQuizData() async {
  await Future.delayed(Duration(seconds: 1)); // Simulate network delay
  Random random = Random();
  
  // Suppose we have 10 available images in the folder.
  List<int> availableImageIds = List.generate(10, (index) => index + 1);
  // Shuffle and pick 5 unique image ids.
  availableImageIds.shuffle(random);
  List<int> quizImageIds = availableImageIds.take(5).toList();

  List<GameData> games = [];
  for (int id in quizImageIds) {
    // Randomly choose which option will be correct
    int correctIndex = random.nextInt(4);
    
    // Generate 4 choices with random names
    List<ChoiceData> choices = List.generate(4, (j) {
      return ChoiceData(
        text: 'Option ${id}${String.fromCharCode(65 + j)}', 
        isCorrect: j == correctIndex,
      );
    });
    
    // Append the game question using the randomly chosen image id
    games.add(GameData(
      svgPath: 'assets/images/svg_maps/map_$id.svg',
      choices: choices,
    ));
  }
  
  return games;
}
//// filepath: /D:/Flutter Apps/Mapper/mapper/lib/src/models.dart
class GameData {
  final String svgPath;
  final List<ChoiceData> choices;

  GameData({required this.svgPath, required this.choices});
}

class ChoiceData {
  final String text;
  final bool isCorrect;

  ChoiceData({required this.text, required this.isCorrect});
}
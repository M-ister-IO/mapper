import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'database_service.dart';
import 'models.dart';
import 'home_page.dart'; // Import the home page
import 'game_result_service.dart';

class MainGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/svg_maps/map_0.svg',
                height: 500,
                width: 500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ChoiceButton(choice: 'Choice 1', isCorrect: false),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ChoiceButton(choice: 'Choice 2', isCorrect: true),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceButton(choice: 'Choice 3', isCorrect: false),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ChoiceButton(choice: 'Choice 4', isCorrect: false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String choice;
  final bool isCorrect;

  const ChoiceButton({required this.choice, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Makes the button look like a box
      child: ElevatedButton(
        onPressed: () {
          if (isCorrect) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Correct!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                content: Text(
                  'You selected the correct answer.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Incorrect!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                content: Text(
                  'You selected the wrong answer.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        child: Text(choice),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          textStyle:
              Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class MapOfDayPage extends StatefulWidget {
  final String userId;

  MapOfDayPage({required this.userId});

  @override
  _MapOfDayPageState createState() => _MapOfDayPageState();
}

class _MapOfDayPageState extends State<MapOfDayPage> {
  final GameResultService _gameResultService = GameResultService();
  GameData? mapData;
  int? selectedChoiceIndex;
  bool answerChecked = false;

  @override
  void initState() {
    super.initState();
    _loadMapOfDay();
  }

  // Load a single map (of the day) using fetchGameData()
  void _loadMapOfDay() async {
    GameData data = await fetchGameData();
    setState(() {
      mapData = data;
      selectedChoiceIndex = null;
      answerChecked = false;
    });
  }

  void onChoiceSelected(int index) {
    // Prevent re-selection if an answer was already chosen.
    if (answerChecked) return;
    setState(() {
      selectedChoiceIndex = index;
      answerChecked = true;
    });
  }

  void onSeeSummary() async {
    // Determine score: 1 if the selected answer is correct, else 0.
    int score = mapData!.choices[selectedChoiceIndex!].isCorrect ? 1 : 0;

    // Update user stats before navigating to the home page
    await _gameResultService.updateUserStats(
      userId: widget.userId, // Use the actual user ID
      gameCorrect: mapData!.choices[selectedChoiceIndex!].isCorrect,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(userId: widget.userId), // Navigate back to the home page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mapData == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Map of the Day")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Map of the Day"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9, // 90% width
                height: MediaQuery.of(context).size.height * 0.4, // 40% height
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 6),
                  borderRadius: BorderRadius.circular(10),
                ),
                // Clip to enforce rounded corners.
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SvgPicture.asset(
                    mapData!.svgPath,
                    fit: BoxFit.cover, // Ensures the SVG fills the container.
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Options grid similar to the quiz page.
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: mapData!.choices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.5,
                  ),
                  itemBuilder: (context, index) {
                    final choice = mapData!.choices[index];
                    Color buttonColor = Theme.of(context).colorScheme.primary;
                    if (answerChecked && selectedChoiceIndex == index) {
                      buttonColor = choice.isCorrect ? Colors.green : Colors.red;
                    }
                    Color textColor = buttonColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: textColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 18),
                      ),
                      onPressed: () => onChoiceSelected(index),
                      child: Text(choice.text),
                    );
                  },
                ),
                SizedBox(height: 20),
                // Reserve a fixed height for the button area so layout doesn't shift.
                Container(
                  height: 48,
                  child: Center(
                    child: answerChecked
                        ? ElevatedButton(
                            onPressed: onSeeSummary,
                            child: Text("Return Home"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFCCD5AE), // Your accent color
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
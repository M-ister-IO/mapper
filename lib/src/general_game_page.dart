//// filepath: /D:/Flutter Apps/Mapper/mapper/lib/src/general_game_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'database_service.dart';
import 'models.dart';
import 'summary_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'game_result_service.dart';

class GeneralGamePage extends StatefulWidget {
  final String userId;

  GeneralGamePage({required this.userId});

  @override
  _GeneralGamePageState createState() => _GeneralGamePageState();
}

class _GeneralGamePageState extends State<GeneralGamePage> {
  final GameResultService _gameResultService = GameResultService();
  List<GameData>? quizQuestions;
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedChoiceIndex;
  bool answerChecked = false;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  void _loadQuiz() async {
    List<GameData> questions = await fetchQuizData();
    setState(() {
      quizQuestions = questions;
      currentQuestionIndex = 0;
      score = 0;
      selectedChoiceIndex = null;
      answerChecked = false;
    });
  }

  void onChoiceSelected(int index) async {
    if (answerChecked) return;

    setState(() {
      selectedChoiceIndex = index;
      answerChecked = true;
      if (quizQuestions![currentQuestionIndex].choices[index].isCorrect) {
        score++;
      }
    });

    // Update user stats after each question is answered
    await _gameResultService.updateUserStats(
      userId: widget.userId, // Use the actual user ID
      gameCorrect: quizQuestions![currentQuestionIndex].choices[index].isCorrect,
    );
  }

  void onNextQuestion() {
    if (currentQuestionIndex < quizQuestions!.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedChoiceIndex = null;
        answerChecked = false;
      });
    } else {
      // Quiz is over, navigate to the summary page.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SummaryPage(
            totalQuestions: quizQuestions!.length,
            correctAnswers: score,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (quizQuestions == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Quiz")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    GameData currentQuestion = quizQuestions![currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${currentQuestionIndex + 1} of ${quizQuestions!.length}"),
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
                    currentQuestion.svgPath,
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
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: currentQuestion.choices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.5,
                  ),
                  itemBuilder: (context, index) {
                    final choice = currentQuestion.choices[index];
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
                            onPressed: onNextQuestion,
                            child: Text("Next Question"),
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
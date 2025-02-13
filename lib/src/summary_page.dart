//// filepath: /D:/Flutter Apps/Mapper/mapper/lib/src/summary_page.dart
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;

  const SummaryPage({
    Key? key,
    required this.totalQuestions,
    required this.correctAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Summary"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Quiz Completed!",
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 20),
              Text(
                "You answered $correctAnswers out of $totalQuestions correctly.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Restart quiz by navigating back to the quiz page.
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text("Return Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
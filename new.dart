import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryScreen()),
            );
          },
          child: Text('Select Category'),
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Science'),
            subtitle: Text('5 Questions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen(category: 'Science')),
              );
            },
          ),
          ListTile(
            title: Text('History'),
            subtitle: Text('5 Questions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen(category: 'History')),
              );
            },
          ),
          ListTile(
            title: Text('Geography'),
            subtitle: Text('5 Questions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen(category: 'Geography')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String category;

  QuizScreen({required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 1;
  int _score = 0;
  int _timeLeft = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Quiz'),
      ),
      body: Column(
        children: [
          Text('Time left: $_timeLeft seconds'),
          Text('Question $_currentQuestion/5'),
          Text('What is the hardest natural substance on Earth?'),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _score++;
                _currentQuestion++;
              });
            },
            child: Text('A. Gold'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentQuestion++;
              });
            },
            child: Text('B. Iron'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _score++;
                _currentQuestion++;
              });
            },
            child: Text('C. Diamond'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentQuestion++;
              });
            },
            child: Text('D. Platinum'),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;

  ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score: $score/5'),
            Text(score >= 4 ? 'Outstanding!' : 'Try Again!'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
              child: Text('Back to Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
              },
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

This code provides a basic structure for the app. You can expand it by adding more questions, improving the UI, and implementing the timer functionality. Let me know if you need any further assistance!
AI-generated content may be incorrect
You said:

did you add the ui like in the image? i want the same cool feeling

Copilot said:
Copilot

Got it! Let's enhance the UI to match the cool feeling from the PDF. We'll add some styling and layout improvements to make the app visually appealing.

Here's an updated version of the Flutter app with improved UI:

import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 18.0),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz App',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
              },
              child: Text('Select Category'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          CategoryTile(category: 'Science', questions: 5),
          CategoryTile(category: 'History', questions: 5),
          CategoryTile(category: 'Geography', questions: 5),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String category;
  final int questions;

  CategoryTile({required this.category, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(category),
        subtitle: Text('$questions Questions'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizScreen(category: category)),
          );
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String category;

  QuizScreen({required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 1;
  int _score = 0;
  int _timeLeft = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time left: $_timeLeft seconds', style: Theme.of(context).textTheme.bodyText2),
            SizedBox(height: 10),
            Text('Question $_currentQuestion/5', style: Theme.of(context).textTheme.bodyText2),
            SizedBox(height: 20),
            Text(
              'What is the hardest natural substance on Earth?',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20),
            AnswerButton(text: 'A. Gold', onPressed: () => _answerSelected(false)),
            AnswerButton(text: 'B. Iron', onPressed: () => _answerSelected(false)),
            AnswerButton(text: 'C. Diamond', onPressed: () => _answerSelected(true)),
            AnswerButton(text: 'D. Platinum', onPressed: () => _answerSelected(false)),
          ],
        ),
      ),
    );
  }

  void _answerSelected(bool correct) {
    setState(() {
      if (correct) _score++;
      _currentQuestion++;
      if (_currentQuestion > 5) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(score: _score)),
        );
      }
    });
  }
}

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  AnswerButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;

  ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score: $score/5', style: Theme.of(context).textTheme.headline6),
            Text(score >= 4 ? 'Outstanding!' : 'Try Again!', style: Theme.of(context).textTheme.bodyText2),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
              child: Text('Back to Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
              },
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

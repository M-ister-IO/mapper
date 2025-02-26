import 'package:flutter/material.dart';
import 'general_game_page.dart';
import 'friends_page.dart'; // Import FriendsPage from friends_page.dart
import 'user_page.dart';
import 'map_of_the_day.dart';
import 'leaderboard_page.dart'; // Import LeaderboardPage
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final String userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeContent(userId: widget.userId),
      LeaderboardPage(), // Add LeaderboardPage to the list of pages
      FriendsPage(userId: widget.userId), // Use FriendsPage from friends_page.dart
      UserPage(userId: widget.userId),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapper'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard), label: 'Leaderboard', // Add Leaderboard item
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group), label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // Set the color for selected items
        unselectedItemColor: Colors.white, // Set the color for unselected items
        backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensure no movement
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String userId;

  HomeContent({required this.userId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          WelcomeBox(userId: userId),
          SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            physics: NeverScrollableScrollPhysics(),
            children: [
              MapOfDayCard(userId: userId),
              GameCard(
                title: 'Quizz (5 maps)',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GeneralGamePage(userId: userId)),
                  );
                },
              ),
              GameCard(
                title: 'Game Mode 3',
                onTap: () {
                  // Navigation for game mode 3
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WelcomeBox extends StatelessWidget {
  final String userId;

  WelcomeBox({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref('users')
              .child(userId)
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Text("Error loading data");
            }

            Map<dynamic, dynamic> userData = {};
            if (snapshot.data!.snapshot.value != null) {
              userData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            }

            String username = userData['username'] ?? "User";
            int mapsPlayed = userData['mapsPlayed'] ?? 0;
            int xp = userData['xp'] ?? 0;
            double ratio = userData['ratio'] is int
                ? (userData['ratio'] as int).toDouble()
                : (userData['ratio'] ?? 0.0);
            int currentStreak = userData['currentStreak'] ?? 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $username!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.normal, // Adjust font weight
                        letterSpacing: 0.5, // Adjust letter spacing
                      ),
                ),
                SizedBox(height: 10),
                Text(
                  'Here are your stats:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal, // Adjust font weight
                        letterSpacing: 0.5, // Adjust letter spacing
                      ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatBox(label: 'Games Played', value: '$mapsPlayed'),
                    StatBox(
                        label: 'Accuracy',
                        value: '${(ratio * 100).toStringAsFixed(1)}%'),
                    StatBox(label: 'XP', value: '$xp'),
                    StatBox(label: 'Streak', value: '$currentStreak'),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String label;
  final String value;

  const StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.normal, // Adjust font weight
                letterSpacing: 0.5, // Adjust letter spacing
              ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.normal, // Adjust font weight
                letterSpacing: 0.5, // Adjust letter spacing
              ),
        ),
      ],
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? child;

  const GameCard({required this.title, required this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: child ??
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal, // Adjust font weight
                      letterSpacing: 0.5, // Adjust letter spacing
                    ),
              ),
        ),
      ),
    );
  }
}

class MapOfDayCard extends StatefulWidget {
  final String userId;

  MapOfDayCard({required this.userId});

  @override
  _MapOfDayCardState createState() => _MapOfDayCardState();
}

class _MapOfDayCardState extends State<MapOfDayCard> {
  bool _canPlay = false;
  Duration _timeLeft = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkLastPlayed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkLastPlayed() async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users').child(widget.userId);
    DatabaseEvent event = await userRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> userData = event.snapshot.value as Map<dynamic, dynamic>;
      String? lastPlayedDate = userData['lastPlayedDate'];

      if (lastPlayedDate != null) {
        DateTime lastPlayed = DateFormat('yyyy-MM-dd').parse(lastPlayedDate);
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime yesterday = today.subtract(Duration(days: 1));

        if (lastPlayed.isBefore(today)) {
          setState(() {
            _canPlay = true;
          });
        } else {
          DateTime nextPlayTime = today.add(Duration(days: 1));
          setState(() {
            _timeLeft = nextPlayTime.difference(now);
          });
          _startTimer();
        }
      } else {
        setState(() {
          _canPlay = true;
        });
      }
    } else {
      setState(() {
        _canPlay = true;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft = _timeLeft - Duration(seconds: 1);
      });
      if (_timeLeft <= Duration.zero) {
        timer.cancel();
        setState(() {
          _canPlay = true;
        });
      }
    });
  }

  void _onPlay() async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users').child(widget.userId);
    DatabaseEvent event = await userRef.once();
    Map<dynamic, dynamic> userData = event.snapshot.value as Map<dynamic, dynamic>;
    String? lastPlayedDate = userData['lastPlayedDate'];
    int currentStreak = userData['currentStreak'] ?? 0;

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (lastPlayedDate != null) {
      DateTime lastPlayed = DateFormat('yyyy-MM-dd').parse(lastPlayedDate);
      if (lastPlayed.isAtSameMomentAs(yesterday)) {
        currentStreak++;
      } else if (!lastPlayed.isAtSameMomentAs(today)) {
        currentStreak = 1; // Reset streak if not played yesterday
      }
    } else {
      currentStreak = 1; // Start streak if no last played date
    }

    await userRef.update({
      'lastPlayedDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'currentStreak': currentStreak,
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapOfDayPage(userId: widget.userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameCard(
      title: 'Map Of The Day',
      onTap: _canPlay ? () => _onPlay() : () {},
      child: _canPlay
          ? Text('Play Now')
          : Text('Next play available in: ${_timeLeft.inHours}:${(_timeLeft.inMinutes % 60).toString().padLeft(2, '0')}:${(_timeLeft.inSeconds % 60).toString().padLeft(2, '0')}'),
    );
  }
}
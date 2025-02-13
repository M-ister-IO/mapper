import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'auth_page.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Add this package for the semi-circle indicator

class UserPage extends StatelessWidget {
  final String userId;

  UserPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref('users').child(userId).onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Error loading profile"));
          }

          Map<dynamic, dynamic> userData = {};
          if (snapshot.data!.snapshot.value != null) {
            userData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          }

          String username = userData['username'] ?? "User";
          int mapsPlayed = userData['mapsPlayed'] ?? 0;
          int mapsCorrect = userData['mapsCorrect'] ?? 0;
          int xp = userData['xp'] ?? 0;
          int streakCount = userData['currentStreak'] ?? 0;
          double ratio = userData['ratio'] is int
              ? (userData['ratio'] as int).toDouble()
              : (userData['ratio'] ?? 0.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        username[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      username,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Games Played: $mapsPlayed",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Correct Answers: $mapsCorrect",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "XP: $xp",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Streak: $streakCount days",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 80.0,
                          lineWidth: 10.0,
                          animation: true,
                          percent: 1.0,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.pink.shade200, // Use dark pink for the background
                          backgroundColor: Colors.pink.shade200, // Use dark pink for the background
                          startAngle: 180, // Start angle for the semi-circle
                          arcType: ArcType.HALF, // Set the arc type to half
                        ),
                        CircularPercentIndicator(
                          radius: 80.0,
                          lineWidth: 10.0,
                          animation: true,
                          percent: ratio,
                          center: Text(
                            "${(ratio * 100).toStringAsFixed(1)}%",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.purple, // Use purple for the progress
                          backgroundColor: Colors.transparent, // Make the background transparent
                          startAngle: 180, // Start angle for the semi-circle
                          arcType: ArcType.HALF, // Set the arc type to half
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Badges",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Badge 1: Coming Soon",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Badge 2: Coming Soon",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Badge 3: Coming Soon",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


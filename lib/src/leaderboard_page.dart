import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_page.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Streak"),
            Tab(text: "Accuracy"),
            Tab(text: "Maps Played"),
            Tab(text: "XP"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LeaderboardList(orderBy: 'currentStreak'),
          LeaderboardList(orderBy: 'ratio'),
          LeaderboardList(orderBy: 'mapsPlayed'),
          LeaderboardList(orderBy: 'xp'),      
        ],
      ),
    );
  }
}

class LeaderboardList extends StatelessWidget {
  final String orderBy;

  LeaderboardList({required this.orderBy});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('users').orderByChild(orderBy).limitToLast(10).onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text("Error loading leaderboard"));
        }

        Map<dynamic, dynamic> usersData = {};
        if (snapshot.data!.snapshot.value != null) {
          usersData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        }

        List<Map<dynamic, dynamic>> usersList = usersData.entries.map((entry) {
          Map<dynamic, dynamic> user = entry.value;
          user['id'] = entry.key;
          return user;
        }).toList();

        // Sort users by the selected order in descending order
        usersList.sort((a, b) => (b[orderBy] ?? 0).compareTo(a[orderBy] ?? 0));

        return ListView.builder(
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            Map<dynamic, dynamic> user = usersList[index];
            String userId = user['id'];
            String username = user['username'] ?? "Unknown";
            int xp = user['xp'] ?? 0;
            int streak = user['currentStreak'] ?? 0;
            double accuracy = user['ratio'] is int
                ? (user['ratio'] as int).toDouble()
                : (user['ratio'] ?? 0.0);
            int mapsPlayed = user['mapsPlayed'] ?? 0;

            return ListTile(
              leading: CircleAvatar(
                child: Text((index + 1).toString()),
              ),
              title: Text(username),
              subtitle: Text(
                orderBy == 'xp'
                    ? "XP: $xp"
                    : orderBy == 'currentStreak'
                        ? "Streak: $streak days"
                        : orderBy == 'ratio'
                            ? "Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%"
                            : "Maps Played: $mapsPlayed",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage(userId: userId)),
                );
              },
            );
          },
        );
      },
    );
  }
}
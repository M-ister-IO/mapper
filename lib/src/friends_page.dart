import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_page.dart';

class FriendsPage extends StatefulWidget {
  final String userId;

  FriendsPage({required this.userId});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<dynamic, dynamic>> allUsers = [];
  List<Map<dynamic, dynamic>> filteredUsers = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  void _loadAllUsers() async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
    DatabaseEvent event = await usersRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> usersData = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        allUsers = usersData.entries.map((entry) {
          Map<dynamic, dynamic> user = entry.value;
          user['id'] = entry.key;
          return user;
        }).toList();
        filteredUsers = allUsers.where((user) => user['id'] != widget.userId).toList();
      });
    }
  }

  void _filterUsers(String query) {
    List<Map<dynamic, dynamic>> results = [];
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredUsers = allUsers.where((user) => user['id'] != widget.userId).toList();
      });
    } else {
      setState(() {
        isSearching = true;
        results = allUsers.where((user) {
          String username = user['username'] ?? '';
          return username.toLowerCase().contains(query.toLowerCase());
        }).toList();
        filteredUsers = results.where((user) => user['id'] != widget.userId).toList();
      });
    }
  }

  void _acceptFriendRequest(String friendshipId) async {
    DatabaseReference friendshipRef = FirebaseDatabase.instance.ref('friendships/$friendshipId');
    await friendshipRef.update({'status': 'accepted'});
  }

  void _declineFriendRequest(String friendshipId) async {
    DatabaseReference friendshipRef = FirebaseDatabase.instance.ref('friendships/$friendshipId');
    await friendshipRef.remove();
  }

  void _removeFriend(String friendshipId) async {
    DatabaseReference friendshipRef = FirebaseDatabase.instance.ref('friendships/$friendshipId');
    await friendshipRef.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search Users",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _filterUsers('');
                  },
                ),
              ),
              onChanged: (query) {
                _filterUsers(query);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance.ref('friendships').onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: Text("Error loading friends"));
                }

                Map<dynamic, dynamic> friendsData = {};
                if (snapshot.data!.snapshot.value != null) {
                  friendsData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                }

                List<String> friendsIds = friendsData.entries.where((entry) {
                  return entry.value['status'] == 'accepted' && (entry.value['user1'] == widget.userId || entry.value['user2'] == widget.userId);
                }).map((entry) {
                  return entry.value['user1'] == widget.userId ? entry.value['user2'] as String : entry.value['user1'] as String;
                }).toList().cast<String>();

                List<String> pendingRequests = friendsData.entries.where((entry) {
                  return entry.value['status'] == 'pending' && entry.value['user2'] == widget.userId;
                }).map((entry) {
                  return entry.value['user1'] as String;
                }).toList().cast<String>();

                List<String> sentRequests = friendsData.entries.where((entry) {
                  return entry.value['status'] == 'pending' && entry.value['user1'] == widget.userId;
                }).map((entry) {
                  return entry.value['user2'] as String;
                }).toList().cast<String>();

                List<Map<dynamic, dynamic>> displayList = isSearching
                    ? filteredUsers
                    : allUsers.where((user) {
                        return friendsIds.contains(user['id']) || pendingRequests.contains(user['id']) || sentRequests.contains(user['id']);
                      }).toList();

                return ListView.builder(
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    Map<dynamic, dynamic> user = displayList[index];
                    String userId = user['id'];
                    String username = user['username'] ?? "Unknown";

                    bool isFriend = friendsIds.contains(userId);
                    bool isPending = pendingRequests.contains(userId);
                    bool isSent = sentRequests.contains(userId);

                    return ListTile(
                      title: Text(username),
                      trailing: isFriend
                          ? IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () async {
                                String friendshipId = friendsData.entries.firstWhere((entry) {
                                  return (entry.value['user1'] == widget.userId && entry.value['user2'] == userId) ||
                                         (entry.value['user1'] == userId && entry.value['user2'] == widget.userId);
                                }).key;
                                _removeFriend(friendshipId);
                              },
                            )
                          : isPending
                              ? SizedBox(
                                  width: 200, // Adjusted width to prevent consuming entire tile width
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(child: Text("Invite Received")),
                                      IconButton(
                                        icon: Icon(Icons.check, color: Colors.green),
                                        onPressed: () async {
                                          String friendshipId = friendsData.entries.firstWhere((entry) {
                                            return entry.value['user1'] == userId && entry.value['user2'] == widget.userId;
                                          }).key;
                                          _acceptFriendRequest(friendshipId);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close, color: Colors.red),
                                        onPressed: () async {
                                          String friendshipId = friendsData.entries.firstWhere((entry) {
                                            return entry.value['user1'] == userId && entry.value['user2'] == widget.userId;
                                          }).key;
                                          _declineFriendRequest(friendshipId);
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : isSent
                                  ? Text("Invite Sent")
                                  : IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () async {
                                        DatabaseReference friendshipsRef = FirebaseDatabase.instance.ref('friendships');
                                        await friendshipsRef.push().set({
                                          'user1': widget.userId,
                                          'user2': userId,
                                          'status': 'pending'
                                        });
                                      },
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
            ),
          ),
        ],
      ),
    );
  }
}
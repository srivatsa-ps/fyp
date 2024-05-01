import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/components/drawer.dart';
import 'package:fyp/pages/profile_page.dart';

import 'landing_page.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserScore> _leaderboard = [];

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .orderBy('tries',
            descending: false) // Fetch with ascending order for lower tries
        .limit(10)
        .get();

    List<UserScore> loadedLeaderboard = [];
    for (var document in snapshot.docs) {
      var data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        loadedLeaderboard.add(UserScore(
          name: data['username'] ?? 'Anonymous',
          tries:
              data['tries'] as int? ?? 0, // Use 'tries' instead of 'bestScore'
        ));
      }
    }

    setState(() {
      _leaderboard = loadedLeaderboard;
    });
  }

  void goToHomePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  void goToleaderboard() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeaderboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            text: TextSpan(
                text: "Leader",
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: " Board",
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold))
            ])),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onHomeTap: goToHomePage,
        onLeaderboardTap: goToleaderboard,
      ),
      body: _leaderboard.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: index == 0
                              ? Colors.amber
                              : index == 1
                                  ? Colors.grey
                                  : index == 2
                                      ? Colors.brown
                                      : Colors.white,
                          width: 3.0,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      _leaderboard[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Tries: ${_leaderboard[index].tries}'), // Display tries instead of best score
                  ),
                );
              },
            ),
    );
  }
}

class UserScore {
  final String name;
  final int tries; // Change from 'score' to 'tries'

  UserScore(
      {required this.name,
      required this.tries}); // Change from 'score' to 'tries'
}

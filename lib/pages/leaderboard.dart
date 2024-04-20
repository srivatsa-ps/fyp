import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        .orderBy('bestScore',
            descending: false) // Fetch with ascending order for lower scores
        .limit(10)
        .get();

    List<UserScore> loadedLeaderboard = [];
    for (var document in snapshot.docs) {
      var data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        loadedLeaderboard.add(UserScore(
          name: data['username'] ?? 'Anonymous',
          score: data['bestScore'] as int? ?? 0,
        ));
      }
    }

    setState(() {
      _leaderboard = loadedLeaderboard;
    });
  }

  Widget rankIcon(int rank) {
    // Function to return appropriate icon for rank
    switch (rank) {
      case 0:
        return Icon(Icons.star, color: Colors.yellow[700], size: 30); // Gold
      case 1:
        return Icon(Icons.star_half,
            color: Colors.grey[350], size: 30); // Silver
      case 2:
        return Icon(Icons.star_border,
            color: Colors.brown[600], size: 30); // Bronze
      default:
        return SizedBox(); // Empty box for ranks below top 3
    }
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
                    subtitle: Text('Best Score: ${_leaderboard[index].score}'),
                    trailing: rankIcon(index),
                  ),
                );
              },
            ),
    );
  }
}

class UserScore {
  final String name;
  final int score;

  UserScore({required this.name, required this.score});
}

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
        .orderBy('bestScore')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: _leaderboard.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shadowColor: Colors.blueGrey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                    trailing: Icon(Icons.star, color: Colors.amber),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
    );
  }
}

class UserScore {
  final String name;
  final int score;

  UserScore({required this.name, required this.score});
}

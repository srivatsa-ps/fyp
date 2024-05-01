import 'package:flutter/material.dart';
import 'package:fyp/Games/LineGameMain.dart';
import 'package:fyp/Games/MemGameCateg.dart';
import 'package:fyp/Games/MemGameMain.dart';
import 'package:fyp/Games/ShapeGameMain.dart';
import 'package:fyp/Games/matchingGame.dart';
import '../components/drawer.dart';
import '../pages/landing_page.dart';
import '../pages/leaderboard.dart';
import '../pages/profile_page.dart';

class GamesListPage extends StatefulWidget {
  @override
  State<GamesListPage> createState() => _GamesListPageState();
}

class _GamesListPageState extends State<GamesListPage> {
  final List<Map<String, dynamic>> games = [
    {'title': 'Memory Game', 'widget': CategorySelectionPage()},
    {'title': 'Bubble Game', 'widget': BubblePopGame()},
    {'title': 'Tracing Game', 'widget': CategorySelectionPagetwo()},
    {'title': 'Matching Game', 'widget': ColorMatchGame()},
  ];

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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        // title: Text(
        //   'Games List',
        // ),
        // centerTitle: true,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onHomeTap: goToHomePage,
        onLeaderboardTap: goToleaderboard,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 100,
          ),
          Text(
            'Choose a Game',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => games[index]['widget'],
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey[400],
                    elevation: 8.0,
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            games[index]['title'],
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Icon(
                            Icons.videogame_asset,
                            color: Colors.grey[900],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

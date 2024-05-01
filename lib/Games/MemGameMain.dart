import 'package:flutter/material.dart';
import 'package:fyp/Games/info_card.dart';
import 'package:fyp/components/game_drawer.dart';
import 'package:fyp/Games/gamesmain.dart';
import 'package:fyp/pages/landing_page.dart';
import 'package:fyp/pages/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Game {
  List<String>? gameImg;
  final hiddenCardPath = 'assets/hidden.png';
  List<Map<int, String>> matchCheck = [];
  List<String> cardsList = [];

  void initGame(String category) {
    List<String> imagePaths = getCategoryImages(category);
    cardsList = List.from(imagePaths)..addAll(imagePaths);
    cardsList.shuffle();
    gameImg = List.generate(cardsList.length, (index) => hiddenCardPath);
    matchCheck = [];
  }

  List<String> getCategoryImages(String category) {
    String basePath = 'images/';
    switch (category.toLowerCase()) {
      case 'vegetables':
        return [
          '$basePath/potato.png',
          '$basePath/onion.png',
          '$basePath/carrot.png',
          '$basePath/tomato.png'
        ];
      case 'animals':
        return [
          '$basePath/cat.png',
          '$basePath/dog.png',
          '$basePath/lion.png',
          '$basePath/tiger.png'
        ];
      case 'birds':
        return [
          '$basePath/crow.png',
          '$basePath/pigeon.png',
          '$basePath/peacock.png',
          '$basePath/parrot.png'
        ];
      default:
        return [
          '$basePath/apple.png',
          '$basePath/banana.png',
          '$basePath/grapes.png',
          '$basePath/mango.png'
        ];
    }
  }
}

class MemHomeScreen extends StatefulWidget {
  final String category;
  const MemHomeScreen({Key? key, required this.category}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MemHomeScreen> {
  TextStyle whiteText = TextStyle(color: Colors.white);
  Game _game = Game();
  int tries = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _game.initGame(widget.category);
  }

  void restartGame() {
    setState(() {
      _game.initGame(widget.category);
      tries = 0;
      score = 0;
    });
  }

  void updateFirebaseWithScore() {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    FirebaseFirestore.instance.collection('users').doc(currentUserEmail).set({
      'bestScore': score,
      'tries': tries, // Add tries to store in Firebase
    }, SetOptions(merge: true));
  }

  void goToHomePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void goToGamePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GamesListPage()));
  }

  void goToLeaderboard() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LeaderboardPage()));
  }

  void showPauseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[500],
          title: Text("M E N U"),
          content: Text("Game is Paused. What would you like to do?"),
          actions: <Widget>[
            TextButton(
              child: Text("Restart", style: TextStyle(color: Colors.grey[900])),
              onPressed: () {
                restartGame();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey[900])),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Quit", style: TextStyle(color: Colors.grey[900])),
              onPressed: () {
                updateFirebaseWithScore();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GamesListPage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.pause, color: Colors.white),
              onPressed: showPauseDialog,
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: MyGameDrawer(
        onHomeTap: goToHomePage,
        onGameTap: goToGamePage,
        onLeaderboardTap: goToLeaderboard,
      ),
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Memory Game",
              style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              info_card("Tries", "$tries"),
              info_card("Score", "$score"),
            ],
          ),
          SizedBox(height: 24.0),
          Expanded(
            child: GridView.builder(
                itemCount: _game.gameImg!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                padding: EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_game.gameImg![index] == _game.hiddenCardPath) {
                          tries++;
                          _game.gameImg![index] = _game.cardsList[index];
                          _game.matchCheck.add({index: _game.cardsList[index]});
                          if (_game.matchCheck.length == 2) {
                            Future.delayed(Duration(milliseconds: 500), () {
                              checkMatch();
                            });
                          }
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFB46A),
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(_game.gameImg![index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  void checkMatch() {
    if (_game.matchCheck[0].values.first == _game.matchCheck[1].values.first &&
        _game.matchCheck[0].keys.first != _game.matchCheck[1].keys.first) {
      score += 100;
      _game.matchCheck.clear();
      if (score == 400) {
        showPauseDialog();
      }
    } else {
      _game.gameImg![_game.matchCheck[0].keys.first] = _game.hiddenCardPath;
      _game.gameImg![_game.matchCheck[1].keys.first] = _game.hiddenCardPath;
      _game.matchCheck.clear();
    }
    setState(() {});
  }
}

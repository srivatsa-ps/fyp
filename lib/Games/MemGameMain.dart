import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Games/info_card.dart';
import 'package:fyp/components/game_drawer.dart';
// Adjust the import path as necessary
import 'package:fyp/Games/gamesmain.dart';
import 'package:fyp/Games/games_util.dart';
import 'package:fyp/pages/landing_page.dart'; // Adjust the import path as necessary


class MemHomeScreen extends StatefulWidget {
  const MemHomeScreen({Key? key}) : super(key: key);

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
    _game.initGame();
  }

  void restartGame() {
    setState(() {
      _game.initGame();
      tries = 0;
      score = 0;
    });
  }

  void goToHomePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }


  void goToGamePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamesListPage()),
    );
  }
  void showPauseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[500],
          title: Text("M E N U"),
          content:
              Text("Game is Paused. What would you like to do?"),
          actions: <Widget>[
            TextButton(
              child: Text("Restart",style: TextStyle(color: Colors.grey[900]),),
              onPressed: () {
                restartGame();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel",style: TextStyle(color: Colors.grey[900]),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Quit",style: TextStyle(color: Colors.grey[900]),),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GamesListPage())); // Adjust this as needed for your app
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
      drawer: MyGameDrawer(onHomeTap: goToHomePage,
      onGameTap: goToGamePage,),
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
                color: Colors.white,
              ),
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
                        tries++;
                        _game.gameImg![index] = _game.cards_list[index];
                        _game.matchCheck.add({index: _game.cards_list[index]});
                      });
                      if (_game.matchCheck.length == 2) {
                        if (_game.matchCheck[0].values.first ==
                            _game.matchCheck[1].values.first) {
                          score += 100;
                          _game.matchCheck.clear();
                          // Only show pause dialog when the score reaches 400
                          if (score == 400) {
                            Future.delayed(
                                Duration(seconds: 1), showPauseDialog);
                          }
                        } else {
                          Future.delayed(Duration(milliseconds: 500), () {
                            setState(() {
                              _game.gameImg![_game.matchCheck[0].keys.first] =
                                  _game.hiddenCardpath;
                              _game.gameImg![_game.matchCheck[1].keys.first] =
                                  _game.hiddenCardpath;
                              _game.matchCheck.clear();
                            });
                          });
                        }
                      }
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
}

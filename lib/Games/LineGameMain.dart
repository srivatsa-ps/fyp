import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fyp/components/game_drawer.dart';
import '../pages/landing_page.dart';
import '../pages/leaderboard.dart';
import 'gamesmain.dart';

enum Category { numbers, alphabets }

// void main() {
//   runApp(MaterialApp(home: CategorySelectionPage()));
// }

class CategorySelectionPagetwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Category'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Numbers'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NumberTracingApp(category: Category.numbers)),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Alphabets'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NumberTracingApp(category: Category.alphabets)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NumberTracingApp extends StatefulWidget {
  final Category category;

  NumberTracingApp({required this.category});

  @override
  State<NumberTracingApp> createState() => _NumberTracingAppState();
}

class _NumberTracingAppState extends State<NumberTracingApp> {
  late Random random;
  late String randomValue; // Changed to string to handle numbers and letters
  late List<DrawingArea> points;

  @override
  void initState() {
    super.initState();
    random = Random();
    randomValue = '';
    points = [];
    _resetGame(); // Initialize the game state
  }

  void _resetGame() {
    setState(() {
      if (widget.category == Category.numbers) {
        randomValue = random.nextInt(10).toString(); // Numbers 0-9
      } else {
        randomValue =
            String.fromCharCode(random.nextInt(26) + 65); // Letters A-Z
      }
      points.clear();
    });
  }

  void goToHomePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void goToLeaderboard() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeaderboardPage()),
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
          content: Text("Game is Paused. What would you like to do?",
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child:
                  Text("Restart", style: TextStyle(color: Colors.deepPurple)),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.deepPurple)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Quit", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Navigate back to the previous screen
              },
            ),
          ],
        );
      },
    );
  }
  // Remaining methods including goToHomePage, goToLeaderboard, goToGamePage, showPauseDialog are unchanged

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: Colors.lightBlue.shade50,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue.shade300,
          centerTitle: true,
          title: IconButton(
            icon: Icon(Icons.pause_circle_filled, color: Colors.white),
            onPressed: showPauseDialog,
            tooltip: 'Pause Game',
          ),
        ),
        drawer: MyGameDrawer(
          onHomeTap: goToHomePage,
          onGameTap: goToGamePage,
          onLeaderboardTap: goToLeaderboard,
        ),
        body: SafeArea(
          child: NumberTracingPage(category: widget.category),
        ),
      ),
    );
  }
}

class NumberTracingPage extends StatefulWidget {
  final Category category;

  NumberTracingPage({required this.category});

  @override
  _NumberTracingPageState createState() => _NumberTracingPageState();
}

class _NumberTracingPageState extends State<NumberTracingPage> {
  Random random = Random();
  String randomValue = ''; // Holds either a number or a letter
  List<DrawingArea> points = [];
  Color selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      if (widget.category == Category.numbers) {
        randomValue = random.nextInt(10).toString();
      } else {
        randomValue = String.fromCharCode(random.nextInt(26) + 65);
      }
      points.clear();
    });
  }

  void _updateColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: GestureDetector(
              onTap: _resetGame,
              child: Text(
                '$randomValue',
                style: TextStyle(
                    fontSize: 150,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
          ),
        ),
        Divider(height: 2.0, color: Colors.grey[800]),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade100, Colors.blue.shade400],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _colorButton(Colors.red),
                      _colorButton(Colors.blue),
                      _colorButton(Colors.green),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: _resetGame,
                        color: Colors.black,
                        tooltip: 'Clear Drawing',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LineDraw(
                    points: points,
                    onPointsUpdate: (updatedPoints) {
                      setState(() {
                        points = updatedPoints;
                      });
                    },
                    selectedColor: selectedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _colorButton(Color color) {
    return IconButton(
      icon: Icon(Icons.color_lens),
      onPressed: () => _updateColor(color),
      color: color,
      tooltip: 'Change Color to ${color.toString()}',
    );
  }
}

class LineDraw extends StatefulWidget {
  final List<DrawingArea> points;
  final Function(List<DrawingArea>) onPointsUpdate;
  final Color selectedColor;

  LineDraw(
      {required this.points,
      required this.onPointsUpdate,
      required this.selectedColor});

  @override
  _LineDrawState createState() => _LineDrawState();
}

class _LineDrawState extends State<LineDraw> {
  void _updatePoints(DrawingArea newPoint) {
    widget.onPointsUpdate(List.from(widget.points)..add(newPoint));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        _updatePoints(DrawingArea(
          point: details.localPosition,
          areaPaint: Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..color = widget.selectedColor
            ..strokeWidth = 2.0,
        ));
      },
      onPanUpdate: (details) {
        _updatePoints(DrawingArea(
          point: details.localPosition,
          areaPaint: Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..color = widget.selectedColor
            ..strokeWidth = 2.0,
        ));
      },
      onPanEnd: (details) {
        _updatePoints(DrawingArea(
          point: Offset.zero,
          areaPaint: Paint(),
        ));
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: MyCustomPainter(points: widget.points),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  List<DrawingArea> points;

  MyCustomPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null &&
          points[i + 1] != null &&
          points[i].point != Offset.zero &&
          points[i + 1].point != Offset.zero) {
        canvas.drawLine(
          points[i].point,
          points[i + 1].point,
          points[i].areaPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({required this.point, required this.areaPaint});
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fyp/components/game_drawer.dart';
import '../pages/landing_page.dart';
import 'gamesmain.dart';

class NumberTracingApp extends StatefulWidget {
  @override
  State<NumberTracingApp> createState() => _NumberTracingAppState();
}

class _NumberTracingAppState extends State<NumberTracingApp> {
  late Random random;
  late int randomNumber;
  late List<DrawingArea> points;

  @override
  void initState() {
    super.initState();
    random = Random();
    randomNumber = 0;
    points = [];
    _resetGame(); // Initialize the game state
  }

  void _resetGame() {
    setState(() {
      randomNumber = random.nextInt(10);
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
          title: Text("MENU"),
          content: Text("Game is Paused. What would you like to do?"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Restart",
                style: TextStyle(color: Colors.grey[900]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[900]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Quit",
                style: TextStyle(color: Colors.grey[900]),
              ),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightBlue.shade100,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue.shade300,
          centerTitle: true,
          title: IconButton(
            icon: Icon(Icons.pause_circle_filled, color: Colors.white),
            onPressed: showPauseDialog,
          ),
        ),
          drawer: MyGameDrawer(onHomeTap: goToHomePage,
            onGameTap: goToGamePage,),
        body: SafeArea(
          child: NumberTracingPage(),
        ),
      ),
    );
  }
}

class NumberTracingPage extends StatefulWidget {
  @override
  _NumberTracingPageState createState() => _NumberTracingPageState();
}

class _NumberTracingPageState extends State<NumberTracingPage> {
  Random random = Random();
  int randomNumber = 0;
  List<DrawingArea> points = [];

  void _resetGame() {
    setState(() {
      randomNumber = random.nextInt(10);
      points.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _resetGame();
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
                '$randomNumber',
                style: TextStyle(fontSize: 150, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: LineDraw(
            points: points,
            onPointsUpdate: (updatedPoints) {
              setState(() {
                points = updatedPoints;
              });
            },
          ),
        ),
      ],
    );
  }
}

class LineDraw extends StatefulWidget {
  final List<DrawingArea> points;
  final Function(List<DrawingArea>) onPointsUpdate;

  LineDraw({required this.points, required this.onPointsUpdate});

  @override
  _LineDrawState createState() => _LineDrawState();
}

class _LineDrawState extends State<LineDraw> {
  Color selectedColor = Colors.black;

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
            ..color = selectedColor
            ..strokeWidth = 2.0,
        ));
      },
      onPanUpdate: (details) {
        _updatePoints(DrawingArea(
          point: details.localPosition,
          areaPaint: Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..color = selectedColor
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

import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(NumberTracingApp());
}

class NumberTracingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightBlue.shade100, // Light color background
        appBar: AppBar(
          backgroundColor:
              Colors.lightBlue.shade300, // Match AppBar theme with app
          centerTitle: true, // Center the title or in this case, the IconButton
          title: IconButton(
            icon: Icon(Icons.pause_circle_filled, color: Colors.white),
            onPressed: () {
              // Accessing the context to show the dialog, this needs to call showPauseDialog from NumberTracingPage
              // This action is simulated here as direct access to showPauseDialog isn't straightforward due to context
              // You would typically use a state management solution or callbacks to handle this
            },
          ),
        ),
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

  void resetGame() {
    setState(() {
      randomNumber = random.nextInt(10);
      points.clear();
    });
  }

  void showPauseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Options"),
          content: Text("What would you like to do?"),
          actions: <Widget>[
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Resume"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Quit"),
              onPressed: () {
                // Assuming Navigator.pushReplacement or similar to navigate away
                // This is a placeholder action
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    resetGame();
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
              onTap: resetGame,
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

  void updatePoints(DrawingArea newPoint) {
    widget.onPointsUpdate(List.from(widget.points)..add(newPoint));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        updatePoints(DrawingArea(
            point: details.localPosition,
            areaPaint: Paint()
              ..strokeCap = StrokeCap.round
              ..isAntiAlias = true
              ..color = selectedColor
              ..strokeWidth = 2.0));
      },
      onPanUpdate: (details) {
        updatePoints(DrawingArea(
            point: details.localPosition,
            areaPaint: Paint()
              ..strokeCap = StrokeCap.round
              ..isAntiAlias = true
              ..color = selectedColor
              ..strokeWidth = 2.0));
      },
      onPanEnd: (details) {
        updatePoints(DrawingArea(point: Offset.zero, areaPaint: Paint()));
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
            points[i].point, points[i + 1].point, points[i].areaPaint);
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

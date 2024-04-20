import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(BubblePopGame());
}

class BubblePopGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble Pop Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline6: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Colors.white70),
        ),
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  List<Bubble> bubbles = [];
  int nextNumber = 1;
  final int totalBubbles = 10;
  final random = Random();
  final List<AnimationController> _controllers = [];
  Stopwatch stopwatch = Stopwatch();
  String bestTime = "None";
  Timer? _timer;

  void resetGame() {
    setState(() {
      nextNumber = 1;
      bubbles.clear();
      _controllers.forEach((controller) => controller.dispose());
      _controllers.clear();
      stopwatch.reset();
      stopwatch.stop();
      initializeGame();
    });
  }

  void startStopwatch() {
    if (!stopwatch.isRunning) {
      stopwatch.start();
      _timer =
          Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
    }
  }

  void checkStopwatch() {
    if (nextNumber > totalBubbles) {
      stopwatch.stop();
      String currentTime = _formattedTime(stopwatch.elapsedMilliseconds);
      if (bestTime == "None" ||
          stopwatch.elapsedMilliseconds < _timeToMs(bestTime)) {
        bestTime = currentTime;
      }
      resetGame();
      _showVictoryDialog();
    }
  }

  String _formattedTime(int milliseconds) {
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  int _timeToMs(String formattedTime) {
    var parts = formattedTime.split(':');
    return int.parse(parts[0]) * 60000 + int.parse(parts[1]) * 1000;
  }

  void initializeGame() {
    for (int i = 0; i < totalBubbles; i++) {
      final controller = AnimationController(
        duration: const Duration(seconds: 25),
        vsync: this,
      );
      _controllers.add(controller);
      double initialX = random.nextDouble();
      double initialY = random.nextDouble();
      bubbles.add(Bubble(
        number: i + 1,
        x: initialX,
        y: initialY,
        vx: (random.nextBool() ? 1 : -1) * 0.0001,
        vy: (random.nextBool() ? 1 : -1) * 0.0001,
        controller: controller,
      ));
      controller.addListener(updateBubblePosition);
      controller.repeat();
    }
  }

  void updateBubblePosition() {
    for (var i = 0; i < bubbles.length; i++) {
      Bubble bubble = bubbles[i];
      double newX = bubble.x + bubble.vx;
      double newY = bubble.y + bubble.vy;
      if (newX < 0 || newX > 1) {
        bubble.vx = -bubble.vx;
        newX = max(0, min(newX, 1));
      }
      if (newY < 0 || newY > 1) {
        bubble.vy = -bubble.vy;
        newY = max(0, min(newY, 1));
      }
      setState(() {
        bubble.x = newX;
        bubble.y = newY;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _timer?.cancel();
    super.dispose();
  }

  void checkBubble(int number) {
    if (number == nextNumber) {
      if (nextNumber == 1) startStopwatch();
      setState(() {
        bubbles.removeWhere((b) => b.number == number);
        nextNumber++;
      });
      checkStopwatch();
    } else {
      resetGame();
      _showFailureDialog();
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Congratulations!'),
        content:
            Text('You popped all the bubbles in order! Best Time: $bestTime'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Oops!'),
        content: Text('Wrong order! Try again!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Restart'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Quit to Main Menu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bubble Pop Game'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: stopwatch.isRunning
                  ? Text(
                      _formattedTime(stopwatch.elapsedMilliseconds),
                      style: TextStyle(fontSize: 20),
                    )
                  : Text("00:00", style: TextStyle(fontSize: 20)),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.indigo.shade400],
          ),
        ),
        child: Stack(
          children: bubbles
              .map(
                (bubble) => Positioned(
                  left: bubble.x * MediaQuery.of(context).size.width,
                  top: bubble.y * MediaQuery.of(context).size.height,
                  child: GestureDetector(
                    onTap: () => checkBubble(bubble.number),
                    child: BubbleWidget(number: bubble.number),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class Bubble {
  final int number;
  double x, y, vx, vy;
  AnimationController controller;

  Bubble({
    required this.number,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.controller,
  });
}

class BubbleWidget extends StatelessWidget {
  final int number;

  BubbleWidget({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.blue.shade500, Colors.blue.shade900],
          center: Alignment(0.0, 0.0),
          radius: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

import 'gamesmain.dart';

void main() {
  runApp(ColorMatchGame());
}

class ColorMatchGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<ColorItem> items;
  late List<IconData> icons;
  late List<Color> uniqueColors; // List to hold unique and randomized colors
  late List<Color>
      secondColumnColors; // Additional list for second column with shuffled order
  int correctMatches = 0; // Track correct matches to determine game completion

  @override
  void initState() {
    super.initState();
    icons = [
      Icons.home,
      Icons.star,
      Icons.lightbulb,
      Icons.music_note,
      Icons.pets,
      Icons.favorite,
      Icons.cake,
      Icons.landscape,
      Icons.build,
      Icons.visibility
    ];
    resetGame();
  }

  void resetGame() {
    correctMatches = 0;
    Set<Color> colorSet = {};
    while (colorSet.length < 6) {
      colorSet.add(Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    }
    uniqueColors = colorSet.toList();
    uniqueColors.shuffle(); // Randomize the order of the colors each time
    items = List.generate(6, (index) {
      final color = uniqueColors[index];
      final icon = icons[Random().nextInt(icons.length)];
      return ColorItem(color: color, icon: icon, isVisible: true);
    });

    // Generate a shuffled list of colors for the second column
    secondColumnColors = List.from(uniqueColors)..shuffle();
    secondColumnColors
        .shuffle(); // Shuffle the order of colors in the second column
  }

  void checkGameCompletion() {
    if (correctMatches == items.length) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You matched all colors correctly!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GamesListPage()));
              },
              child: Text('Quit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(resetGame);
              },
              child: Text('Restart'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Match the Colors Game')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade800],
          ),
        ),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items
                    .map((item) => Draggable<ColorItem>(
                          data: item,
                          child: item.isVisible
                              ? ColorIconBox(item: item)
                              : Container(),
                          feedback: ColorIconBox(item: item, isDragging: true),
                          childWhenDragging: Container(),
                          onDragCompleted: () {
                            setState(() {
                              item.isVisible = false;
                            });
                          },
                        ))
                    .toList(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: secondColumnColors
                    .map((color) => DragTarget<ColorItem>(
                          onWillAccept: (receivedItem) => true,
                          onAccept: (receivedItem) {
                            if (receivedItem.color == color) {
                              setState(() {
                                correctMatches++;
                                checkGameCompletion();
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Incorrect!'),
                                  content: Text(
                                      'You have mismatched the colors. Game will restart.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(resetGame);
                                      },
                                      child: Text('Restart'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          builder: (context, candidateData, rejectedData) =>
                              Container(
                            width: 70, // Reduced size for the second column
                            height: 70, // Reduced size for the second column
                            color: color,
                            margin: EdgeInsets.all(10),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorItem {
  final Color color;
  final IconData icon;
  bool isVisible;

  ColorItem({required this.color, required this.icon, this.isVisible = true});
}

class ColorIconBox extends StatelessWidget {
  final ColorItem item;
  final bool isDragging;

  ColorIconBox({required this.item, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          item.icon,
          size: 40,
          color: Colors.white,
        ),
      ),
      margin: EdgeInsets.all(10),
    );
  }
}

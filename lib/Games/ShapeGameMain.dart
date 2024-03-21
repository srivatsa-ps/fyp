import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/Games/gamesmain.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ShapegameData.dart'; // Make sure this path is correct

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DragPicture(),
    );
  }
}

class DragPicture extends StatefulWidget {
  @override
  _DragPictureState createState() => _DragPictureState();
}

class _DragPictureState extends State<DragPicture> {
  List<bool> _isDone = [false, false, false];
  List<bool> elementState = [false, false, false];
  double itemSize = 70;
  double newSize = 70;

  // Reset game to its initial state
  void restartGame() {
    setState(() {
      _isDone = [false, false, false]; // Reset to initial state
      elementState = [false, false, false]; // Reset to initial state
      newSize = 70; // Reset size if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
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
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              buildGameBoard(),
              buildDraggableItemsContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGameBoard() {
    return Container(
      width: 500,
      height: 180,
      decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage("assets/images/board3.png"))),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: itemlist
                .map((item) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: DragTarget<Itemdata>(
                        onWillAccept: (data) => data?.name == item.name,
                        onAccept: (e) {
                          setState(() {
                            _isDone[itemlist.indexOf(e)] = true;
                            elementState[itemlist.indexOf(e)] = true;
                          });
                        },
                        builder: (BuildContext context, List incoming,
                            List rejected) {
                          return _isDone[itemlist.indexOf(item)]
                              ? Container(
                                  height: newSize,
                                  width: newSize,
                                  child: SvgPicture.asset(item.address),
                                )
                              : Container(
                                  height: itemSize,
                                  width: itemSize,
                                  child: SvgPicture.asset(item.address,
                                      color: Colors.black45),
                                );
                        },
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildDraggableItemsContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 500,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.black87.withOpacity(0.7),
            border:
                Border.all(color: Colors.black54.withOpacity(0.8), width: 3)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Wrap(
              children: itemlist
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Draggable<Itemdata>(
                          data: e,
                          onDragStarted: () {
                            setState(() {
                              newSize = 80;
                            });
                          },
                          childWhenDragging: Container(
                            height: itemSize,
                            width: itemSize,
                          ),
                          feedback: Container(
                            height: itemSize,
                            width: itemSize,
                            child: SvgPicture.asset(e.address),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: elementState[itemlist.indexOf(e)]
                                ? Container(
                                    width: itemSize,
                                    height: itemSize,
                                  )
                                : Container(
                                    height: itemSize,
                                    width: itemSize,
                                    child: SvgPicture.asset(e.address),
                                  ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
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
                restartGame(); // Call restartGame when Restart is pressed
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Just close the dialog
              },
            ),
            TextButton(
              child: Text("Quit"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GamesListPage())); // Adjust this as needed for your app structure
              },
            ),
          ],
        );
      },
    );
  }
}

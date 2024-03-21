import 'package:flutter/material.dart';
import 'package:fyp/Games/LineGameMain.dart';
import 'package:fyp/Games/MemGameMain.dart';
import 'package:fyp/Games/ShapeGameMain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Games List',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Color(0xFF1A1A1A),
        cardColor: Color(0xFF2A2A2A),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white70),
        ),
      ),
      home: GamesListPage(),
    );
  }
}

class GamesListPage extends StatelessWidget {
  final List<Map<String, dynamic>> games = [
    {'title': 'Memory Game', 'widget': MemHomeScreen()},
    {'title': 'Shape Game', 'widget': DragPicture()},
    {'title': 'Line Game', 'widget': NumberTracingApp()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games List'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8.0,
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(
                games[index]['title'],
                style: TextStyle(
                    fontSize: 24.0, color: Theme.of(context).primaryColor),
              ),
              trailing: Icon(Icons.videogame_asset,
                  color: Theme.of(context).primaryColor),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => games[index]['widget']),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

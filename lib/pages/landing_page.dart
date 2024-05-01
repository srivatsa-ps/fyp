import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/Games/gamesmain.dart';
import 'package:fyp/pages/forum.dart';
import 'package:fyp/pages/leaderboard.dart';
import 'package:fyp/pages/quotes.dart';

import '../auth/auth.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? currentUser;

  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    // Navigate back to AuthPage by popping the navigation stack
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final email = currentUser?.email ?? '';
    final name = email.split('@').first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Change app bar color
        title: Text(
          'Welcome $name',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('No user data found'),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          if (userData.isEmpty) {
            return Center(
              child: Text('No user data found'),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome ${userData['username']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                CircleAvatar(
                  backgroundColor: Colors.yellow,
                  radius: 60.0,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
                SizedBox(height: 40.0),
                // Customized Buttons
                _buildButton(
                  context,
                  'Discussion Forum',
                  Forum(),
                ),
                SizedBox(height: 20.0),
                _buildButton(
                  context,
                  'Play Games',
                  GamesListPage(),
                ),
                SizedBox(height: 20.0),
                _buildButton(
                  context,
                  'Leaderboard',
                  LeaderboardPage(),
                ),
                SizedBox(height: 20.0),
                _buildButton(
                  context,
                  'Quote for the day',
                  QuotePage(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Customized Button Widget
  Widget _buildButton(BuildContext context, String text, Widget route) {
    return GestureDetector(
      onTap: () {
        try {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        } catch (e) {
          print('Error navigating to $text page: $e');
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

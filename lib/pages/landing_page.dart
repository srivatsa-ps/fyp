import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/Games/gamesmain.dart';
import 'package:fyp/pages/forum.dart';
import 'package:fyp/pages/leaderboard.dart';

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
        automaticallyImplyLeading: false,
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
                GestureDetector(
                  onTap: () {
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forum()),
                      );
                    } catch (e) {
                      print('Error navigating to Forum page: $e');
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Discussion Forum',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GamesListPage()),
                      );
                    } catch (e) {
                      print('Error navigating to Forum page: $e');
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Play Games',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaderboardPage()),
                      );
                    } catch (e) {
                      print('Error navigating to Leaderboard page: $e');
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Leaderboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Add your GestureDetector widgets here
              ],
            ),
          );
        },
      ),
    );
  }
}

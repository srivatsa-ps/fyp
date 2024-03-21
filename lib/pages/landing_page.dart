import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fyp/habit_tracker/pages/habit_tracker.dart';
import 'package:fyp/pages/forum.dart'; // Import your Forum page here

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? currentUser;

  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    // Navigate to login or landing page after sign out
  }

  final userCollection = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser; // Initialize currentUser here
  }

  @override
  Widget build(BuildContext context) {
    final email = currentUser?.email ?? '';
    final name = email.split('@').first;

    return Scaffold(
      appBar: AppBar(
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
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
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
                    backgroundColor: Colors.yellow, // Placeholder color
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
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
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
                      // Add functionality for Play Games button
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
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
                      // try {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => HabitTracker()),
                      //   );
                      // } catch (e) {
                      //   print('Error navigating to Habit tracking page: $e');
                      // }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Track your progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Return a progress indicator or placeholder widget if snapshot doesn't have data
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/pages/forum.dart'; // Import your Forum page here

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late User? currentUser;
  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    // Navigate to login or landing page after sign out

  }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome $name',
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
                    MaterialPageRoute(builder: (context) => const Forum()),
                  );
                } catch (e) {
                  print('Error navigating to Forum page: $e');
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                // Add functionality for Leaderboard button
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
          ],
        ),
      ),
    );
  }
}

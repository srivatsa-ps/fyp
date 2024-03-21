// forum.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/drawer.dart';
import 'package:fyp/components/forum_post.dart';
import 'package:fyp/components/text_field.dart';
import 'package:fyp/pages/landing_page.dart';
import 'package:fyp/pages/profile_page.dart';

import '../helper/helper_methods.dart';

class Forum extends StatefulWidget {
  const Forum({Key? key}) : super(key: key);

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final textController = TextEditingController();

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("user posts").add(
        {
          'UserEmail': currentUser!.email,
          'message': textController.text,
          'TimeStamp': Timestamp.now(),
          'Likes': [],
        },
      );
    }
    textController.text = '';
  }

  void goToHomePage() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Discussion Forum',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[700],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onHomeTap: goToHomePage,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return ForumPost(
                          message: post['message'],
                          user: post['UserEmail'],
                          postID: post.id,
                          time: formatData(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: +${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Create your post',
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

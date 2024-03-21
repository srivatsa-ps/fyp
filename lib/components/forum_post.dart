import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/helper_methods.dart';
import 'comment.dart';
import 'delete_button.dart';
import 'like_button.dart';
import 'comment_button.dart';
class ForumPost extends StatefulWidget {
  final String message;
  final String user;
  final String postID;
  final String time;
  ForumPost({
    required this.message,
    required this.user,
    required this.postID,
    required this.time,
  });
  @override
  State<ForumPost> createState() => _ForumPostState();
}
class _ForumPostState extends State<ForumPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  List<String> likes = [];
  @override
  void initState() {
    super.initState();
    fetchLikes();
  }
  void fetchLikes() async {
    DocumentSnapshot<Map<String, dynamic>> postSnapshot = await FirebaseFirestore.instance
        .collection('user posts')
        .doc(widget.postID)
        .get();

    if (postSnapshot.exists) {
      setState(() {
        likes = List<String>.from(postSnapshot.data()!['Likes'] ?? []);
        isLiked = likes.contains(currentUser.email!);
      });
    }
  }
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likes.add(currentUser.email!);
      } else {
        likes.remove(currentUser.email!);
      }
    });

    DocumentReference postRef =
    FirebaseFirestore.instance.collection('user posts').doc(widget.postID);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email!])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email!])
      });
    }
  }
  void addComment(String commentText) {
    print('Adding comment: $commentText');
    print('Current user: ${currentUser.email}');
    print('Post ID: ${widget.postID}');

    FirebaseFirestore.instance
        .collection('user posts')
        .doc(widget.postID)
        .collection('comments')
        .add({
      "commenttext": commentText,
      "commentedby": currentUser.email,
      "commenttime": Timestamp.now()
    })
        .then((value) {
      print('Comment added successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    })
        .catchError((error) {
      print('Error adding comment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add comment'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add comment',
          style: TextStyle(color: Colors.grey[900]),
        ),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey),
            hintText: "Add a new comment",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String commentText = _commentTextController.text.trim();
              if (commentText.isNotEmpty) {
                addComment(commentText);
                _commentTextController.clear();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a comment'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text('Post'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete post?'),
        content: Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
              onPressed: () async {
                // Delete comments first
                await FirebaseFirestore.instance
                    .collection('user posts')
                    .doc(widget.postID)
                    .collection('comments')
                    .get()
                    .then((querySnapshot) {
                  querySnapshot.docs.forEach((doc) async {
                    await doc.reference.delete();
                  });
                });

                // Delete post
                await FirebaseFirestore.instance
                    .collection('user posts')
                    .doc(widget.postID)
                    .delete()
                    .then((value) {
                  print('Post deleted successfully');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Post deleted successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                })
                    .catchError((error) {
                  print('Failed to delete post: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete post'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: Text('Delete')),
        ],
      ),
    );
  }

  final _commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      SizedBox(width: 20),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Expanded(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 4),
        Text(widget.message,
          softWrap: true,),
        SizedBox(height: 10),
        Row(
        children: [
        Text(
        widget.user,
        style: TextStyle(color: Colors.grey[400]),
        ),
        Text(
        "-",
        style: TextStyle(color: Colors.grey[400]),
        ),
        Text(
        widget.time,
        style: TextStyle(color: Colors.grey[400]),
        )
        ],
        ),
        SizedBox(height: 10),
        ],
        ),
      ),
      if (widget.user == currentUser.email) DeleteButton(onTap: deletePost),
      ],
      ),
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Column(
      children: [
      LikeButton(isLiked: isLiked, onTap: toggleLike),
      SizedBox(height: 5),
      Text(
      likes.length.toString(),
      style: TextStyle(color: Colors.grey),
      ),
      ],
      ),
      SizedBox(height:5),
        Column(
          children: [
            CommentButton(ontap: showCommentDialog),
            SizedBox(height: 5),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user posts")
                  .doc(widget.postID)
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                int commentCount = snapshot.data!.docs.length;
                return Text(
                  commentCount.toString(),
                  style: TextStyle(color: Colors.grey),
                );
              },
            ),
          ],
        ),
      ],
      ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("user posts")
              .doc(widget.postID)
              .collection('comments')
              .orderBy('commenttime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((doc) {
                final commentData = doc.data() as Map<String, dynamic>;
                return Comment(
                  user: commentData['commentedby'],
                  text: commentData['commenttext'],
                  time: formatData(commentData['commenttime']),
                );
              }).toList(),
            );
          },
        )
      ],
      ),
      ),
    );
  }
}


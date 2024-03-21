//
// import '../helper/helper_methods.dart';
// import 'comment.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fyp/components/comment_button.dart';
// import 'package:fyp/components/like_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// class ForumPost extends StatefulWidget {
//   final String message;
//   final String user;
//   final String postID;
//   final String time;
//   final List<String> likes;
//
//   // final String time;
//   const ForumPost({super.key,
//     required this.message,
//     required this.user,
//     required this.postID,
//     required this.likes,
//     required this.time
//     // required this.time
//   });
//
//   @override
//   State<ForumPost> createState() => _ForumPostState();
// }
//
// class _ForumPostState extends State<ForumPost> {
//   //user
//   final currentUser=FirebaseAuth.instance.currentUser!;
//   bool isLiked=false;
//   final _commentTextController= TextEditingController();
//
//   @override
//   void initState(){
//     super.initState();
//     isLiked=widget.likes.contains(currentUser.email);
//
//   }
//   //toggle
//   void toggleLike(){
//     setState(() {
//       isLiked=!isLiked;
//     });
//     //access the document
//     DocumentReference postRef=
//     FirebaseFirestore.instance.collection('user posts').doc(widget.postID);
//
//     if(isLiked){
//       postRef.update({
//         'Likes':FieldValue.arrayUnion([currentUser.email])
//       });
//     }
//     else{
//       postRef.update({
//         'Likes':FieldValue.arrayRemove([currentUser.email])
//       });
//     }
//   }
//   //add comment
//   void addComment(String commentText){
//     FirebaseFirestore.instance.collection('user posts')
//         .doc(widget.postID)
//         .collection('comments').add({
//       "commenttext":commentText,
//       "commentedby":currentUser.email,
//       "commenttime":Timestamp.now()
//     });
//   }
//
//   //show dialog
//   void showCommentDialog(){
//     showDialog(context: context,
//         builder: (context)=>AlertDialog(
//           title: Text('Add comment',
//               style:TextStyle(
//                   color: Colors.grey[900]
//               )),
//           content: TextField(
//             controller: _commentTextController,
//             decoration: InputDecoration(
//               hintStyle: TextStyle(color: Colors.grey),
//               hintText: "Add a new comment",
//             ),
//           ),
//           actions: [
//             //save button
//             TextButton(
//                 onPressed:()
//                 { if(_commentTextController.text !=''){
//                   addComment(_commentTextController.text);
//                   _commentTextController.clear();
//                   Navigator.pop(context);
//                 }
//
//                 },
//                 child: Text('Post')),
//
//             //cancel button
//             TextButton(onPressed:(){
//               Navigator.pop(context);
//               _commentTextController.clear();
//             },
//                 child:
//                 Text('Cancel')),
//           ],
//
//         ));
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8)),
//       margin: EdgeInsets.only(top: 25,left: 25,right: 25),
//       padding: EdgeInsets.all(25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(width: 20,),
//           Column(
//             //forum post
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 4,),
//               //message
//               Text(widget.message),
//               SizedBox(height: 10,),
//               //user
//               Row(
//                 children: [
//                   Text(widget.user,
//                     style: TextStyle(
//                         color: Colors.grey[400]
//                     ),),
//                   Text("-",style: TextStyle(
//                       color: Colors.grey[400]
//                   ),),
//                   Text(widget.time,style: TextStyle(
//                       color: Colors.grey[400]
//                   ),)
//                 ],
//               ),
//               SizedBox(height: 10,)
//             ],
//           ),
//           //buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               //like
//               Column(
//                 children: [
//                   LikeButton(isLiked: isLiked, onTap:toggleLike),
//                   SizedBox(height: 5,),
//                   //like count
//                   Text(
//                       widget.likes.length.toString(),
//                       style:TextStyle(color: Colors.grey)),
//                 ],
//               ),
//
//               SizedBox(height: 5,),
//               //comments
//               Column(
//                 children: [
//                   CommentButton(ontap: showCommentDialog),
//                   SizedBox(height: 5,),
//                   //like count
//                   Text(
//                       widget.likes.length.toString(),
//                       style:TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ],
//           ),
//           //comments under the post
//           StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance
//               .collection("user posts")
//               .doc(widget.postID)
//               .collection('comments')
//               .orderBy('commenttime',descending: true)
//               .snapshots(),
//             builder:(context,snapshot){
//               //show loading circle
//               if(!snapshot.hasData){
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//
//               return ListView(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 children:snapshot.data!.docs.map((doc){
//                   //get the comment
//                   final commentData= doc.data() as Map<String,dynamic>;
//
//                   //return comment
//                   return Comment(
//                       user: commentData['commentedby'],
//                       text: commentData['commenttext'],
//                       time: formatData(commentData['commenttime']));
//                 }).toList(),
//               );
//             },)
//         ],
//       ),
//     );
//   }
// }

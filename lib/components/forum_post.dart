import 'package:flutter/material.dart';

class ForumPost extends StatelessWidget {
  final String message;
  final String user;
  // final String time;
  const ForumPost({super.key,
  required this.message,
  required this.user,
  // required this.time
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25,left: 25,right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            decoration:
            BoxDecoration(shape: BoxShape.circle,color: Colors.grey[400]),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.person),
          ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user,
              style: TextStyle(color: Colors.grey[500]),),
              SizedBox(height: 25,),
              Text(message),
            ],
          )
        ],
      ),
    );
  }
}

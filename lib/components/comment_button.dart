import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final void Function()? ontap;
  const CommentButton({super.key,
  required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:ontap,
      child: Icon(
        Icons.comment,
        color:Colors.grey,
      ),


    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser=FirebaseAuth.instance.currentUser!;
  //all users
  final userCollection=FirebaseFirestore.instance.collection('users');

  //edit field
  Future<void> editField(String field) async{

    String newValue='';
    await showDialog(context: context,
        builder: (context)=>AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Edit '+field,
          style: TextStyle(
            color: Colors.white,
          ),),
          content: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new ${field}",
                  hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value){
              newValue=value;
            },
          ),
          actions: [
            //cancel button
            TextButton(onPressed:()=>Navigator.pop(context), child: Text('Cancel',
              style: TextStyle(
                color: Colors.white
              ),)),
            //save button
            TextButton(onPressed:()=>Navigator.of(context).pop(newValue),
                child: Text('Save',
              style: TextStyle(
                  color: Colors.white
              ),)),
          ],
        )
        );
    //update in firestore
    if(newValue.trim().length>0){
      //only update if there's some value
      await userCollection.doc(currentUser.email).update({field:newValue});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Profile Page',
        style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Colors.grey[700],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .snapshots()
          , builder:(context,snapshot){
            if(snapshot.hasData){
              final userData= snapshot.data!.data() as Map<String,dynamic>;

              return ListView(
                children: [
                  SizedBox(height: 50,),
                  //profile pic
                  Icon(Icons.person,
                      size:72),
                  //email
                  Text(currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),),
                  SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text('My details',style: TextStyle(color: Colors.grey[700]),),
                  ),

                  //username
                  MyTextBox(text: userData['username'], sectionName: 'Username',
                    onPressed: ()=>editField('username'),),
                  SizedBox(height: 25,),
                  //bio
                  MyTextBox(text: userData['bio'], sectionName: 'Bio',
                    onPressed: ()=>editField('bio'),),
                ],
              );
            } else if(snapshot.hasError){
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            }
            return Center(child: CircularProgressIndicator());
      }
      )
    );
  }
}

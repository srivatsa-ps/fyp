import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/text_field.dart';
import 'package:fyp/components/button.dart';
class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key,
  required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController= TextEditingController();
  final passwordTextController= TextEditingController();

  void login() async{
    showDialog(context: context,
        builder: (context)=>const Center(
          child: CircularProgressIndicator(),
        ),);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);


        Navigator.pop(context);
    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }
  void displayMessage(String message){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(message),
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                //logo
                SizedBox(height: 25,),
                //welcome back
                Text('Welcome back',
                  style:TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ) ,),

                SizedBox(height: 25,),
                //email textfield
                MyTextField(controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false),
                SizedBox(height: 25,),
                //password textfield
                MyTextField(controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true),
                //sign in  button
                SizedBox(height: 25,),
                MyButton(onTap:login, text: 'Login'),
                //register page
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not registered yet?',
                      style:TextStyle(
                        color: Colors.grey[700],
                      ) ,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('  Register now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

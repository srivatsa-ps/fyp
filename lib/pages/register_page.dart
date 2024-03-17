import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/text_field.dart';
import 'package:fyp/components/button.dart';
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key,
  required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    final emailTextController= TextEditingController();
    final passwordTextController= TextEditingController();
    final confirmPasswordTextController = TextEditingController();
    void register()async{
      showDialog(context: context,
        builder: (context)=>const Center(
          child: CircularProgressIndicator(),
        ),);
      if(passwordTextController.text != confirmPasswordTextController.text){
        Navigator.pop(context);
        displayMessage("Passwords don't match");
      }
      try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      if(context.mounted) Navigator.pop(context);
      }
      on FirebaseAuthException catch(e){
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50,),
                  //logo
                  //welcome back
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Let us create an account',
                      style:TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                      ) ,),
                  ),
                  SizedBox(height: 25,),
                  //email textfield
                  MyTextField(controller: emailTextController,
                      hintText: 'Email',
                      obscureText: false),
                  SizedBox(height: 20,),
                  //password textfield
                  MyTextField(controller: passwordTextController,
                      hintText: 'Password',
                      obscureText: true),
                  //sign in  button
                  SizedBox(height: 20,),
                  MyTextField(controller: confirmPasswordTextController,
                      hintText: "Enter Password again",
                      obscureText: true),
                  SizedBox(height: 20,),
                  MyButton(onTap:register, text: 'Register'),
                  //register page
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                        style:TextStyle(
                          color: Colors.grey[700],
                        ) ,),
                      GestureDetector(
                        onTap:widget.onTap,
                        child: Text('  Login now',
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


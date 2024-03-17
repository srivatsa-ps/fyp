import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/auth/login_or_register.dart';
import 'package:fyp/pages/landing_page.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder(
          stream:FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot){
            if(snapshot.hasData){
              return const HomePage();
            }
            else{
              return const LoginOrRegister();
            }
      },),
    );
  }
}

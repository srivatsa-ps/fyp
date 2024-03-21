import 'package:flutter/material.dart';
import 'package:fyp/auth/auth.dart';
import 'package:fyp/auth/login_or_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp/firebase_options.dart';
import 'package:fyp/pages/login_page.dart';
import 'package:fyp/pages/register_page.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}


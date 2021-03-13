import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodio/screens/home_screen.dart';
import 'package:foodio/screens/onboarding_screen.dart';
import 'package:foodio/screens/register_screen.dart';
import 'package:foodio/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
      ),
      home: SplashScreen(),
    );
  }
}

// Splash screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset("images/logo.png"),
              ),
              Text(
                "Foodio",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// start 06:59
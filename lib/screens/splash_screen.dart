import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/screens/welcome_screen.dart';

import 'Home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash-screen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Nav _nav = Nav();
  Timer _timer;
  @override
  void initState() {
    _timer = Timer(
      Duration(seconds: 3),
      () {
        FirebaseAuth.instance.authStateChanges().listen((User user) {
          if (user == null) {
            Navigator.pushReplacementNamed(context, WelcomeScreen.id);
          } else {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.dispose();
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

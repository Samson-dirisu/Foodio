import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/providers/auth_provider.dart';
import 'package:foodio/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "home-screen";
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    Nav _nav = Nav();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              onPressed: () {
                authProvider.error = '';
                FirebaseAuth.instance.signOut().then(
                      (value) => _nav.pushReplacement(
                        context: context,
                        destination: WelcomeScreen(),
                      ),
                    );
              },
              child: Text("real Sign out"),
            ),
            RaisedButton(
              onPressed: () {
                _nav.push(context: context, destination: WelcomeScreen());
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/providers/auth_provider.dart';
import 'package:foodio/providers/location_provider.dart';
import 'package:foodio/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // variables
  Nav _nav = Nav();

  @override
  Widget build(BuildContext context) {
    //providers
    final authProvider = Provider.of<AuthProvider>(context);
    final _locationProvider = Provider.of<LocationProvider>(context);

    // load location stored in Share Preferences
    _locationProvider.getPrefs();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: Container(),
        title: FlatButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_locationProvider.location ?? "Address not set",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white)),
              Icon(Icons.edit_outlined, color: Colors.white),
            ],
          ),
          onPressed: null,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(Icons.account_circle_outlined, color: Colors.white),
              onPressed: () {},
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
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

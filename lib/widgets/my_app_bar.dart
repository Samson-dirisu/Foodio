import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/providers/app_provider.dart';
import 'package:foodio/providers/location_provider.dart';
import 'package:foodio/screens/map_screen.dart';
import 'package:foodio/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Nav _nav = Nav();

  @override
  Widget build(BuildContext context) {
    final _locationProvider = Provider.of<LocationProvider>(context);
    final _appProvider = Provider.of<AppProvider>(context);

    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: FlatButton(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(_locationProvider.location ?? "Address not set ",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                Icon(Icons.edit_outlined, color: Colors.white, size: 15),
              ],
            ),
            Flexible(
              child: Text(
                _locationProvider.address ?? "Not set",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          _locationProvider.getCurrenPosition().then((position) {
            if (position != null) {
              if (_locationProvider.permissionAllowed) {
                _nav.push(context: context, destination: MapScreen());
              } else {
                print("i can't move");
              }
            } else {
              print("access denied");
            }
          });
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.power_settings_new, color: Colors.white),
          onPressed: () {
            _auth.signOut();
            _nav.pushReplacement(
              context: context,
              destination: WelcomeScreen(),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle_outlined, color: Colors.white),
          onPressed: () {},
        )
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
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
    );
  }
}

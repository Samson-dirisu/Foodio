import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/providers/auth_provider.dart';
import 'package:foodio/screens/Home/top_pick_store.dart';
import 'package:foodio/screens/welcome_screen.dart';
import 'package:foodio/widgets/dot_indicator.dart';
import 'package:foodio/widgets/image_slider.dart';
import 'package:foodio/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Nav _nav = Nav();

  @override
  Widget build(BuildContext context) {
    //providers
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSlider(),
          Container(
            height: 300,
            child: TopPickStore(),
          ),
        ],
      ),
    );
  }
}

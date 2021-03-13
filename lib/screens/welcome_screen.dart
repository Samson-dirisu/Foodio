import 'package:flutter/material.dart';
import 'package:foodio/screens/onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  void showBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              children: [
                Divider(color: Colors.black, indent: 1),
                Text("Login", style: TextStyle(fontSize: 25)),
                SizedBox(height: 10.0),
                Text(
                  "Enter your phone number to process",
                  style: TextStyle(fontSize: 12.0),
                ),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    prefixText: "+234",
                    labelText: "10, digit mobile number",
                  ),
                  autofocus: true,
                ),
                SizedBox(height: 10.0),
                FlatButton(
                  onPressed: () {},
                  child: Text("Enter Phone Number"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(child: OnboardingScreen()),
                Text('Ready to order from your nearest shop',
                    style: TextStyle(color: Colors.grey)),
                SizedBox(height: 20),
                FlatButton(
                    onPressed: () {},
                    child: Text(
                      "SET DELIVERY LOCATION",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.deepOrangeAccent),
                SizedBox(height: 20),
                FlatButton(
                  onPressed: () {
                    showBottomSheet(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already a Customer ? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0.0,
              top: 10.0,
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  "Skip",
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

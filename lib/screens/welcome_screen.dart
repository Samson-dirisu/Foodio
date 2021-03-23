import 'package:flutter/material.dart';
import 'package:foodio/providers/auth_provider.dart';
import 'package:foodio/providers/location_provider.dart';
import 'package:foodio/widgets/onboarding_screen.dart';
import 'package:provider/provider.dart';

import 'map_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome-screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    // method to build bottom sheet
    void showBottomSheet(BuildContext context) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 10,
                          child: Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            authProvider.error == "Invalid OTP" ? true : false,
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                "${authProvider.error}",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12.0),
                              ),
                              SizedBox(height: 3),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Enter your phone number to process",
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          prefixText: "+234  ",
                          labelText: "10, digit mobile number",
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        onChanged: (value) {
                          if (value.length == 10) {
                            myState(() {
                              _validPhoneNumber = true;
                            });
                          } else {
                            myState(() {
                              _validPhoneNumber = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: _validPhoneNumber ? false : true,
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                color: _validPhoneNumber
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                child: authProvider.loading
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white))
                                    : Text(
                                        _validPhoneNumber
                                            ? "CONTINUE"
                                            : "ENTER YOUR PHONE NUMBER",
                                        style: TextStyle(color: Colors.white)),

                                // onpressed function
                                onPressed: () async {
                                  myState(() {
                                    authProvider.loading = true;
                                  });

                                  String number =
                                      "+234${_phoneNumberController.text}";
                                  await authProvider
                                      .verifyPhone(
                                    context: context,
                                    number: number,
                                  )
                                      .then((value) {
                                    _phoneNumberController.clear();
                                  });
                                  myState(() {
                                    authProvider.loading = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ).whenComplete(() {
        setState(() {
          authProvider.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

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
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                          onPressed: () async {
                            setState(() {
                              locationData.loading = true;
                            });
                            await locationData.getCurrenPosition();
                            if (locationData.permissionAllowed) {
                              Navigator.pushReplacementNamed(
                                  context, MapScreen.id);
                              setState(() {
                                locationData.loading = false;
                              });
                            } else {
                              print("permission denied");
                              setState(() {
                                locationData.loading = true;
                              });
                            }
                            authProvider.getCurrentUser();
                          },
                          child: locationData.loading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : Text(
                                  "SET DELIVERY LOCATION",
                                  style: TextStyle(color: Colors.white),
                                ), 
                                color: Theme.of(context).primaryColor,),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      authProvider.screen = 'login';
                    });
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
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

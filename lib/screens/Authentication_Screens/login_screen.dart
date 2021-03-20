import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/providers/auth_provider.dart';
import 'package:foodio/providers/location_provider.dart';
import 'package:foodio/screens/Home/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();
  Nav _nav = Nav();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: SafeArea(
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
                visible: authProvider.error == "Invalid OTP" ? true : false,
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "${authProvider.error}",
                        style: TextStyle(color: Colors.red, fontSize: 12.0),
                      ),
                      SizedBox(height: 3),
                    ],
                  ),
                ),
              ),
              Text(
                "Login",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                    setState(() {
                      _validPhoneNumber = true;
                    });
                  } else {
                    setState(() {
                      _validPhoneNumber = false;
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber ? false : true,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          color: _validPhoneNumber
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          child: authProvider.loading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white))
                              : Text(
                                  _validPhoneNumber
                                      ? "CONTINUE"
                                      : "ENTER YOUR PHONE NUMBER",
                                  style: TextStyle(color: Colors.white)),

                          // onpressed function
                          onPressed: () async {
                            setState(() {
                              authProvider.loading = true;
                            });

                            String number =
                                "+234${_phoneNumberController.text}";
                            await authProvider
                                .verifyPhone(
                              context: context,
                              number: _phoneNumberController.text,
                              latitude: locationData.latitude,
                              longitude: locationData.longitude,
                              address: locationData.selectedAddress.addressLine,
                            )
                                .then((value) {
                              _phoneNumberController.clear();
                              _nav.pushReplacement(
                                context: context,
                                destination: HomeScreen(),
                              );
                            });
                            setState(() {
                              authProvider.loading = false;
                            });
                          },
                        ),
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
  }
}

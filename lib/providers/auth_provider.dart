import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/providers/location_provider.dart';
import 'package:foodio/screens/Home/home_screen.dart';
import 'package:foodio/services/user_service.dart';

class AuthProvider with ChangeNotifier {
  LocationProvider locationData = LocationProvider();
  String smsOtp;
  String verificationId;
  String error = "";
  bool loading = false;
  String screen;
  double latitude;
  double longitude;
  String address;

  // Private variables;
  User _user;
  Nav _nav = Nav();
  bool _isLoggedIn = false;
  UserServices _userServices = UserServices();
  FirebaseAuth _auth = FirebaseAuth.instance;

  // getters
  bool get isLoggedIn => _isLoggedIn;
  User get user => _user;

  // function to verify if OTP and phone number matches the one in firebase
  Future<void> verifyPhone({
    BuildContext context,
    String number,
  }) async {
    this.loading = true;
    notifyListeners();

    // verification complete
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    // verification failed
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      print(e.code);
      this.loading = false;
      this.error = e.toString();
      notifyListeners();
    };

    // send OTP
    final PhoneCodeSent smsOtpsend = (String verId, int resendToken) async {
      this.verificationId = verId;

      // dialog box to enter received OTP SMS
      smsOtpDialog(context, number);
    };
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpsend,
        codeAutoRetrievalTimeout: (String veriId) {
          this.verificationId = veriId;
          notifyListeners();
        },
      );
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  // dialog to recieve OTP
  Future smsOtpDialog(BuildContext context, String number) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Verification Code"),
              SizedBox(height: 6),
              Text(
                "Enter 6 digit OTP received as SMS",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          content: Container(
            height: 85,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value) {
                this.smsOtp = value;
              },
            ),
          ),
          actions: [
            FlatButton(
              child: Text("Done"),
              onPressed: () async {
                try {
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: smsOtp,
                  );

                  final User user =
                      (await _auth.signInWithCredential(phoneAuthCredential))
                          .user;
                  if (user != null) {
                    this.loading = false;
                    notifyListeners();

                    _userServices.getUserById(user.uid).then((snapshot) {
                      // User already exists
                      if (snapshot.exists) {
                        if (this.screen == 'Login') {
                          _nav.pushReplacement(
                            context: context,
                            destination: HomeScreen(),
                          );
                        } else {
                          updateUser(id: user.uid, number: user.phoneNumber);
                          _nav.pushReplacement(
                            context: context,
                            destination: HomeScreen(),
                          );
                        }
                      } else {
                        // user does not exists and needs to be created
                        _createUser(id: user.uid, number: user.phoneNumber);

                        _nav.pushReplacement(
                          context: context,
                          destination: HomeScreen(),
                        );
                      }
                    });
                  } else {
                    print("login failed");
                  }
                } catch (e) {
                  this.error = "invalid OTP";
                  this.loading = false;
                  notifyListeners();
                  print(e.toString());
                  _nav.pop(context);
                }
              },
            ),
          ],
        );
      },
    ).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  // function that would create user by calling userservices method creatUser
  void _createUser({String id, String number}) async {
    await _userServices.createUser({
      "id": id,
      "number": number,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "address": this.address,
    });
  }

  //function to update user data by calling updateUserData method from
  // userservice
  void updateUser({String id, String number}) async {
    await _userServices.updataUserData({
      "id": id,
      "number": number,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "address": this.address,
    });
    this.loading = false;
    notifyListeners();
  }

  // function resposible for getting current user to the provider
  void getCurrentUser() {
    User user = _auth.currentUser;
    if (user != null) {
      _isLoggedIn = true;
      this._user = user;
      notifyListeners();
    } else {
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  //check if user is logged in when viewing map, if not he would denied access
  void isPermitted() {
    if (_user.uid == null) {
      _isLoggedIn = false;
      notifyListeners();
    } else {
      _isLoggedIn = true;
      notifyListeners();
    }
  }
}

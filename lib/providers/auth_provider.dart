import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/screens/Home/home_screen.dart';
import 'package:foodio/services/user_service.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Nav _nav = Nav();
  String smsOtp;
  String verificationId;
  String error = "";
  UserServices _userServices = UserServices();
  bool loading = false;
  bool _isLoggedIn = false;
  User _user;

  // getters
  bool get isLoggedIn => _isLoggedIn;
  User get user => _user;

  // function to verify if OTP and phone number matches the one in firebase
Future<void> verifyPhone({BuildContext context, String number, double latitude, double longitude, String address,}) async {
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

      // dialog to enter received OTP SMS
      smsOtpDialog(context, number, latitude, longitude, address);
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
      ;
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  // dialog to recieve OTP
  Future<bool> smsOtpDialog(BuildContext context, String number, double latitude, double longitude, String address) {
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

                  /**  create user data in firestore after user successfully registered,
                   * navigate to home screen after Login
                  */
                  if (user != null) {
                    _createUser(uid: user.uid, number: user.phoneNumber);
                    // Nav.pop(context: context);

                    // don't want to come back to welcome screen after Logged in
                    _nav.pushReplacement(
                        context: context, destination: HomeScreen());
                  } else {
                    print('login failed');
                  }
                } catch (e) {
                  this.error = "invalid OTP";
                  notifyListeners();
                  print(e.toString());
                  _nav.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  // function that would create user by calling userservices method creatUser
  void _createUser({
    String uid,
    String number,
    double latitude,
    double longitude,
    String address,
  }) async {
    await _userServices.createUser({
      "id": uid,
      "number": number,
      "address": address,
      "location": GeoPoint(latitude, longitude),
    });
  }

  /** function to update user data by calling updateUserData method from 
   * userservice 
  */
  void updateUser({
    String uid,
    String number,
    double latitude,
    double longitude,
    String address,
  }) async {
    await _userServices.updataUserData({
      "id": uid,
      "number": number,
      "address": address,
      "location": GeoPoint(latitude, longitude),
    });
  }

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
}

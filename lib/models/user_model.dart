import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = "number";
  static const ID = "id";
  static const LATITUDE = "latitude";
  static const LONGITUDE = "longitude";
  static const ADDRESS = "address";

  String _number;
  String _id;
  String _address;
  double _latitude;
  double _longitude;

  // getters
  String get number => _number;
  String get id => _id;
  String get address => _address;
  double get latitude => _latitude;
  double get longitude => _longitude;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    _number = data[NUMBER];
    _id = data[ID];
    _address = data[ADDRESS];
    _latitude = data[LATITUDE];
    _longitude = data[LONGITUDE];
  }
}

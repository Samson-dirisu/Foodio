import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/screens/welcome_screen.dart';
import 'package:foodio/services/user_service.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double latitude;
  double longitude;
  double _userLatitude = 0.0;
  double _userLongitude = 0.0;
  bool permissionAllowed = false;
  bool loading = false;
  var selectedAddress;
  double vendorDistance = 8;
  LatLng currentLocation;
  GoogleMapController mapController;

  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  Nav _nav = Nav();

  // private variables
  String _location;
  String _address;
  bool _locating = false;

  // Getters
  String get location => this._location;
  String get address => this._address;
  double get userLatitude => this._userLatitude;
  double get userLongitude => this._userLongitude;
  bool get locating => _locating;

  // constructor
  LocationProvider() {
    getPrefs();
  }

  Future<Position> getCurrenPositionfromDB() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (position != null) {
        this.latitude = position.latitude;
        this.longitude = position.longitude;

        final coordinates = new Coordinates(this.latitude, this.longitude);
        final addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        this.selectedAddress = addresses.first;
        this.permissionAllowed = true;
        notifyListeners();
      }
      return position;
    } catch (e) {
      return null;
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    final coordinates = new Coordinates(this.latitude, this.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selectedAddress = addresses.first;
    notifyListeners();
    print(
        "${this.selectedAddress.featureName} : ${this.selectedAddress.addressLine}");
  }

  // function responsible for storing location to Shared Preferences
  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble("latitude", this.latitude);
    prefs.setDouble("longitude", this.longitude);
    prefs.setString("address", this.selectedAddress.addressLine);
    prefs.setString("location", this.selectedAddress.featureName);
  }

  // function to get data stored in Share Preferences
  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString("location");
    String address = prefs.getString("address");
    this._location = location;
    this._address = address;
    notifyListeners();
  }

  // Get current position
  void getCurrentPosition() {
    currentLocation = LatLng(latitude, longitude);
    notifyListeners();
  }

  // Oncreated
  void onCreated(GoogleMapController controller) {
    mapController = controller;
    notifyListeners();
  }

  // Update _locating to true of false;
  void updateLocating(bool val) {
    _locating = val;
    notifyListeners();
  }

  // Function to get latlng from firestore
  Future<bool> getLatLng() {
    return _userServices.getUserById(user.uid).then((snapshot) {
      if (snapshot.data()['id'] != null) {
        _userLatitude = snapshot.data()['latitude'];
        _userLongitude = snapshot.data()['longitude'];
        print("$_userLatitude user latitude");
        return true;
      } else {
        print("Error");
        return false;
      }
    });
  }

  // function to get LatLng of vendors from firestore
  void getVendorsLatLng(AsyncSnapshot<QuerySnapshot> snapshot) {
    List shopDistance = [];
    for (int i = 0; i < snapshot.data.docs.length; i++) {
      var distance = Geolocator.distanceBetween(
          this._userLatitude,
          this._userLongitude,
          snapshot.data.docs[i]['location'].latitude,
          snapshot.data.docs[i]['location'].longitude);
      print(
          "na im e be this ${snapshot.data.docs[i]['location'].latitude} ${snapshot.data.docs[i]['location'].longitude}");
      var distanceKm = distance / 1000;
      shopDistance.add(distanceKm);
    }
  }

  // Function to get distance between user and vendors
  String getDistance(location) {
    getLatLng().then((value) {
      double distance = Geolocator.distanceBetween(
        _userLatitude,
        userLongitude,
        location.latitude,
        location.longitude,
      );
      print("$_userLatitude user real lat");
      double distanceKm = distance / 1000;
      print("the real distance $distanceKm");
      vendorDistance = distanceKm;
    });
    return vendorDistance.toStringAsFixed(2);
  }
}

// Geolocator is correct
// i can't fetch data from _userLatitude and Lat

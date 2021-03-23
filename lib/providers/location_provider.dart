import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double latitude;
  double longitude;
  bool permissionAllowed = false;
  bool loading = false;
  var selectedAddress;
  String _location;

  // Getters
  String get location =>this._location;

  Future<void> getCurrenPosition() async {
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
    } else {
      print(" permision not allowed");
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

  // function responsible for storing location to local storage
  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble("latitude", this.latitude);
    prefs.setDouble("longitude", this.longitude);
    prefs.setString("address", this.selectedAddress.addressLine);
    prefs.setString("location", this.selectedAddress.featureName);
  }

  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String location = prefs.getString("location");
    this._location = location;
    notifyListeners();
  }
}

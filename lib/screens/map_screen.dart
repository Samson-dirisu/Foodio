import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:foodio/helper/navigator.dart';
import 'package:foodio/providers/auth_provider.dart';
import 'package:foodio/providers/location_provider.dart';
import 'package:foodio/screens/Home/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'Authentication_Screens/login_screen.dart';

class MapScreen extends StatefulWidget {
  static const String id = "map-screen";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation;
  GoogleMapController _mapController;
  bool _locating = false;
  Nav _nav = Nav();

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: currentLocation, zoom: 14.4746),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _locating = true;
                });
                locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  _locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 40),
                child: Image.asset("images/marker.png"),
              ),
            ),
            Center(
              child: SpinKitPulse(
                color: Colors.black54,
                size: 100.0,
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 230,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    _locating
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor))
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextButton.icon(
                        label: Flexible(
                          child: Text(
                            _locating
                                ? "loading..."
                                : locationData.selectedAddress.featureName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        icon: Icon(
                          Icons.location_searching,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        locationData.selectedAddress.addressLine,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: AbsorbPointer(
                          absorbing: _locating ? true : false,
                          child: FlatButton(
                            color: _locating
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                            child: Text(
                              "Confirm Location",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              // save address in Shared Preferences
                              locationData.savePrefs();
                              
                              // check if user is logged in
                              if (authProvider.isLoggedIn == false) {
                                _nav.push(
                                  context: context,
                                  destination: LoginScreen(),
                                );
                              }
                               // if not logged in, save lat, lng and address to variables
                               else {
                                 locationData.getPrefs();
                                setState(() {
                                  authProvider.latitude = locationData.latitude;
                                  authProvider.longitude =
                                      locationData.longitude;
                                  authProvider.address =
                                      locationData.selectedAddress.addressLine;
                                });
                                authProvider.updateUser(
                                  id: authProvider.user.uid,
                                  number: authProvider.user.phoneNumber,
                                );
                                //     .then(
                                //   (value) {
                                //     if (value) {
                                //       _nav.push(
                                //         context: context,
                                //         destination: HomeScreen(),
                                //       );
                                //     }
                                //   },
                                // );

                                // get location stored in Shared Preferences
                                locationData.getPrefs();
                                _nav.push(
                                    context: context,
                                    destination: HomeScreen());
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

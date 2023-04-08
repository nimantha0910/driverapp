import 'dart:async';
import 'dart:convert';
import 'dart:developer';
//import 'dart:html';

import 'package:driverapp/AllScreens/registrationScreen.dart';
import 'package:driverapp/configMaps.dart';
import 'package:driverapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.0,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  //const ProfileTabPage({super.key});
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  late GoogleMapController newGoogleMapController;

  late Position currentPosition;

  var geoLocator = Geolocator();

  String driverStatusText = "Offline Now - Go Online ";
  Color driverStatusColor = Colors.black;
  bool isDriverAvailable = false;

  void locatePosition() async {
    //log('satarted calling the function');
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;
      LatLng latLatPosition = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition =
          new CameraPosition(target: latLatPosition, zoom: 14);
      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      //log('running ');

      // String address =
      //     await AssistantMethods.searchCoordinateAddress(position, context);
      // print("This is your address : " + address);
      //log('address');
      //log(address);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);

            setState(() {
              newGoogleMapController = controller;
            });

            locatePosition();
          },
        ),

        //online offline driver container
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),

        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: driverStatusColor, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    if (isDriverAvailable != true) {
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();

                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatusText = "Online Now";
                        isDriverAvailable = true;
                      });

                      displayToastMessage("You are Online Now.", context);
                    } else {
                      makeDriverOfflineNow();
                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = "Offline Now - Go Online ";
                        isDriverAvailable = false;
                      });

                      displayToastMessage("You are Offline Now.", context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          driverStatusText,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 26.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void makeDriverOnlineNow() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;
      FirebaseAuth auth = FirebaseAuth.instance;
      log(auth.currentUser!.uid);
      const url =
          'https://rider-app-29f66-default-rtdb.firebaseio.com/availableDrivers.json';
      var data = {
        "uid": auth.currentUser!.uid,
        "longitude": currentPosition.longitude,
        "latitude": currentPosition.latitude
      };
      await http.post(Uri.parse(url), body: json.encode(data));
      Geofire.initialize("availableDrivers");
      log(auth.currentUser!.uid +
          currentPosition.longitude.toString() +
          currentPosition.latitude.toString());
      Geofire.setLocation(auth.currentUser!.uid, currentPosition.latitude,
          currentPosition.longitude);

      rideRequestRef.onValue.listen((event) {});
    } catch (e) {
      log(e.toString());
    }
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentfirebaseUser!.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOfflineNow() {
    Geofire.removeLocation(currentfirebaseUser!.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    //rideRequestRef = null;
  }
}

//import 'dart:js';

import 'dart:developer';
//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:driverapp/Assistants/requestAssistant.dart';
import 'package:driverapp/DataHandler/appData.dart';
import 'package:driverapp/Models/address.dart';
import 'package:driverapp/Models/allUsers.dart';
import 'package:driverapp/Models/directionDetails.dart';
import 'package:driverapp/configMaps.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = " ";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);
    log(response.toString());

    if (response != "failed") {
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][2]["long_name"];
      st4 = response["results"][0]["address_components"][3]["long_name"];
      placeAddress = st2 + ", " + st3 + ", " + st4;

      log(position.latitude.toString() + position.longitude.toString());
      Address userPickUpAddress = new Address(
          placeFormattedAddress: "",
          placeName: "",
          placeId: "",
          latitude: position.latitude,
          longitude: position.longitude);
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails(
        distanceValue: 0,
        durationValue: 0,
        distanceText: "",
        durationText: "",
        encodedPoints: "");

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];

    // directionDetails.distanceValue =
    //     double.parse(res["routes"][0]["legs"][0]["distance"]["value"]);

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];

    // directionDetails.durationValue =
    //     double.parse(res["routes"][0]["legs"][0]["duration"]["text"]);

    return directionDetails;
  }

  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String? userId = firebaseUser?.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId!);

    // async methods should return a future
    Future<void> getCurrentOnLineUserInfo() async {
      firebaseUser = await FirebaseAuth.instance.currentUser;
      String userId = firebaseUser!.uid;
      DatabaseReference reference =
          FirebaseDatabase.instance.ref().child("user").child(userId);

      final snapshot =
          await reference.get(); // you should use await on async methods
      if (snapshot!.value != null) {
        userCurrentInfo = Users.fromSnapshot(snapshot);
      }
      ;
    }
  }
}

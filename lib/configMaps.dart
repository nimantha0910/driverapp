import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:driverapp/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyC-dPEeTK3Kt1mxUiu3kgZOP2ZICbKqu1w";

User? firebaseUser;
Users? userCurrentInfo;
User? currentfirebaseUser;
StreamSubscription<Position>? homeTabPageStreamSubscription;

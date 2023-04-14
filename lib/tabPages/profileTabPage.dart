// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:driverapp/AllScreens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileTabPage extends StatefulWidget {
  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  var drivers = [];
  var filterDriver = [];
  bool isLoading = false;
  @override
  void initState() {
    getAllDriverDetails();
    // TODO: implement initState
    super.initState();
  }

  //const ProfileTabPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60.0,
                    ),
                    Text(
                      filterDriver[0]['name'],
                      style: TextStyle(color: Colors.white, fontSize: 36),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Car-park Owner',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 3.0,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                filterDriver[0]['phone'],
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                filterDriver[0]['email'],
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 180.0,
                    ),
                    InkWell(
                      onTap: () async {
                        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                        await firebaseAuth.signOut();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => loginScreen(),
                        ));
                      },
                      child: Container(
                        width: 250.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Sign out',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future getAllDriverDetails() async {
    log('message');
    setState(() {
      isLoading = true;
    });
    try {
// Print the data of the snapshot
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      late http.Response response;

      const url =
          'https://rider-app-29f66-default-rtdb.firebaseio.com/driver.json';
      response = await http.get(Uri.parse(url));
      Map body = json.decode(response.body);
      body.forEach((key, value) {
        log(key.toString());
        value['key'] = key;
        drivers.add(value);
      });

      for (var item in drivers) {
        if (firebaseAuth.currentUser!.email == item['email']) {
          filterDriver.add(item);
        }
      }
      setState(() {
        isLoading = false;
      });

      log(filterDriver[0].toString());
    } catch (e) {
      log(e.toString());
    }
  }
}

// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyNotification extends StatefulWidget {
  const MyNotification({super.key});

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  var drivers = [];
  bool isLoading = false;
  @override
  void initState() {
    getAllDriverDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notifications'),
        centerTitle: true,
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => new AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  content: Builder(
                                    builder: (context) {
                                      // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                      var height =
                                          MediaQuery.of(context).size.height;
                                      var width =
                                          MediaQuery.of(context).size.width;

                                      return Container(
                                        height: height - 450,
                                        width: width - 400,
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/images/istockphoto-1326924480-612x612.jpg',
                                              width: 100,
                                              height: 80,
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            const Text(
                                              "New Driver Request!",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 60.0,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.home_outlined,
                                                  size: 16,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                    drivers[index]
                                                        ['pickup_address'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.account_circle_rounded,
                                                  size: 16,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Text(
                                                  drivers[0]['userDetails'][0]
                                                      ['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 40.0,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 5.0,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    String driverKey =
                                                        drivers[index]['key'];
                                                    FirebaseDatabase.instance
                                                        .reference()
                                                        .child("Ride Request")
                                                        .child(driverKey)
                                                        .update({
                                                      "driver_id": 'cancel',
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        'CANCEL',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    //update userData
                                                    String driverKey =
                                                        drivers[index]['key'];
                                                    FirebaseDatabase.instance
                                                        .reference()
                                                        .child("Ride Request")
                                                        .child(driverKey)
                                                        .update({
                                                      "driver_id": 'accepting',
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      color: Colors.green,
                                                      border: Border.all(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        'ACCEPT',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 140.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Driver name',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    drivers[0]['userDetails'][0]['name'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Location',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      drivers[index]['pickup_address'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Status',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      drivers[index]['driver_id'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
    );
  }

  Future getAllDriverDetails() async {
    log('message');
    setState(() {
      isLoading = true;
    });
    try {
// Print the data of the snapshot

      late http.Response response;

      const url =
          'https://rider-app-29f66-default-rtdb.firebaseio.com/Ride Request.json';
      response = await http.get(Uri.parse(url));
      Map body = json.decode(response.body);
      body.forEach((key, value) {
        log(key.toString());
        value['key'] = key;
        drivers.add(value);
      });
      setState(() {
        isLoading = false;
      });

      log(drivers[0].toString());
    } catch (e) {
      log(e.toString());
    }
  }
}

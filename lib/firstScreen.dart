// ignore: file_names
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:rccarapp/carScreen.dart';

class firstScreen extends StatefulWidget {
  const firstScreen({super.key});

  @override
  State<firstScreen> createState() => _firstScreenState();
}

class _firstScreenState extends State<firstScreen> {
  TextEditingController device_ip = TextEditingController();

  Future writeData(String DeviceID, String userip) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.100:8000/writeRequest"),
        body: {"DeviceID": DeviceID, "UserIp": userip});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  String dropdownvalue = 'Car 1';
  var items = [
    'Car 1',
    'Car 2',
    'Car 3',
    'Car 4',
    'Car 5',
    'Car 6',
    'Car 7',
    'Car 8'
  ];

  TextEditingController myip = TextEditingController();
  late Timer mytimer2;
  void timerfunction() {
    mytimer2 = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        printIps();
        mytimer2.cancel();
      });
    });
  }

  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        myip.text = addr.address;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    timerfunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Connection")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Device Ip address',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(
                myip.text,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: device_ip,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Device Ip address',
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Choose your Car',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButton(
                      underline: Container(),
                      style: const TextStyle(
                          //te
                          color: Colors.black, //Font color
                          fontSize: 18 //font size on dropdown button
                          ),
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                            value: items, child: Text(items));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Connect'),
                onPressed: () {
                  // writeData(dropdownvalue, myip.text);

                  if (device_ip.text == "") {
                    Fluttertoast.showToast(
                        msg: "Invalid",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    List<String> myst = device_ip.text.split('.');
                    List<int> numbers = myst.map(int.parse).toList();
                    Uint8List rawAddress;
                    rawAddress = Uint8List.fromList(numbers);

                    if (rawAddress.length < 4) {
                      Fluttertoast.showToast(
                          msg: "Invalid",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => carScreen(
                                  rawAddress: rawAddress,
                                )),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

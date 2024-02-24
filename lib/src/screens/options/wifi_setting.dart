// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:esptouch_smartconfig/esptouch_smartconfig.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/functions/task_route_page.dart';

class WifiPage extends StatefulWidget {
  final String ssid;
  final String bssid;

  const WifiPage({required this.ssid, required this.bssid, Key? key})
      : super(key: key);

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  bool isBroad = true;
  TextEditingController password = TextEditingController();
  TextEditingController deviceCount = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('Agregar Dispositivo'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "SSID:",
                        style: TextStyle(fontSize: 14, color: mainColor)),
                    TextSpan(
                        text: widget.ssid,
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ])),
                  SizedBox(
                    height: 6,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "BSSID:",
                        style: TextStyle(fontSize: 14, color: mainColor)),
                    TextSpan(
                        text: widget.bssid,
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ])),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    controller: password,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        labelText: "Password:",
                        suffixIcon:
                            Icon(Icons.remove_red_eye, color: Colors.grey),
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: mainColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: deviceCount,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        labelText: "DeviceCount:",
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: mainColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.black),
                        )),
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                          groupValue: isBroad,
                          value: true,
                          activeColor: mainColor,
                          onChanged: (bool? value) {
                            setState(() {
                              isBroad = value!;
                            });
                          }),
                      Text("BroadCast"),
                      SizedBox(width: 6),
                      Radio<bool>(
                          groupValue: isBroad,
                          value: false,
                          activeColor: mainColor,
                          onChanged: (bool? value) {
                            setState(() {
                              isBroad = value!;
                            });
                          }),
                      Text("MultiCast"),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Set<ESPTouchResult> result = await Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => TaskRoute(
                                    widget.ssid,
                                    widget.bssid,
                                    password.text,
                                    deviceCount.text,
                                    isBroad)));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) => mainColor)),
                      child: Text("CONFIRM")),
                ],
              ),
            ),
          ),
        ));
  }
}

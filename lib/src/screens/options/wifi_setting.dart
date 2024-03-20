// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_build_context_synchronously
import 'package:aquavista/src/functions/setting_functions.dart';
import 'package:flutter/material.dart';

import 'package:wifi_iot/wifi_iot.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/util/snackbar.dart';
import 'package:aquavista/src/screens/options/select_device_wifi.dart';

class WifiPage extends StatefulWidget {
  final String ssid;
  final String bssid;

  const WifiPage({required this.ssid, required this.bssid, Key? key})
      : super(key: key);

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  bool _obscureText = true;
  NetworkSecurity security = NetworkSecurity.WPA;
  TextEditingController password = TextEditingController();
  List<String> securiList = <String>[
    'WPA',
    'WEP',
    'NONE',
  ];
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
                    obscureText: _obscureText,
                    controller: password,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        labelText: "Contraseña:",
                        suffixIcon: SizedBox(
                          height: 20,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon((_obscureText)
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined)),
                        ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Seguridad: '),
                      DropdownButton<String>(
                        hint: Text(security.name),
                        items: securiList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            switch (val) {
                              case 'WPA':
                                security = NetworkSecurity.WPA;
                                break;
                              case 'WEP':
                                security = NetworkSecurity.WEP;
                                break;
                              default:
                                security = NetworkSecurity.NONE;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        // print('>>>>>>>>>>>>>>>>>.. ${security.name}');
                        // print('>>>>>>>>>>>>>>>>>.. ${password.text}');

                        // bool resp = await tryConecction(
                        //     widget.ssid, widget.bssid, password.text, security);

                        if (password.text.length >= 6) {
                          List<WifiNetwork> networks =
                              await enableDevices() ?? [];
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SelectDevice(
                                    widget.ssid,
                                    widget.bssid,
                                    password.text,
                                    networks,
                                  )));
                        } else {
                          snackBarAlert(
                              text: 'Contraseña no Valida',
                              context: context,
                              color: Colors.red);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) => mainColor)),
                      child: Text("Validar")),
                ],
              ),
            ),
          ),
        ));
  }
}

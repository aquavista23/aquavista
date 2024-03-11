// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, use_build_context_synchronously

import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/functions/dialogs_functions.dart';
import 'package:aquavista/src/functions/setting_functions.dart';
import 'package:aquavista/src/screens/options/check_conection.dart';

class SelectDevice extends StatefulWidget {
  const SelectDevice(this.ssid, this.bssid, this.password, {Key? key})
      : super(key: key);
  final String ssid;
  final String bssid;
  final String password;
  @override
  State<StatefulWidget> createState() {
    return SelectDeviceState();
  }
}

class SelectDeviceState extends State<SelectDevice> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  int getRandomInt() {
    final random = Random();
    return random.nextInt(99999);
  }

  Widget waitingState(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(mainColor),
          ),
          SizedBox(height: 16),
          Text(
            'Buscando Dispositivos',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget error(BuildContext context, String s) {
    return Center(
      child: Text(
        s,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget noneState(BuildContext context) {
    return Center(
        child: Text(
      'None',
      style: TextStyle(fontSize: 24),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.of(context).pop(_results);
        //     }),
        backgroundColor: mainColor,
        title: Text(
          'Agregar Dispositivo',
        ),
      ),
      body: StreamBuilder<List<WifiNetwork>>(
        stream: searcDevices(),
        builder: (context, AsyncSnapshot<List<WifiNetwork>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(backgroundColor: Colors.red),
            );
          }
          if (snapshot.hasError) {
            return error(context, 'Error in StreamBuilder');
          }
          if (snapshot.data!.isNotEmpty) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    if (snapshot.data![index].ssid != null) {
                      String validator = getRandomInt().toString();
                      await tryConecction(snapshot.data![index].ssid!);
                      String? ipAddres = await getWifiIp();
                      debugPrint('>>>>>>>>>>>>>:  http://$ipAddres:80/');
                      http.Response? response = await http
                          .post(Uri.parse('http://$ipAddres:80/config'),
                              headers: {
                                "Content-Type":
                                    "application/json;charSet=UTF-8",
                              },
                              body: jsonEncode({
                                'ssid': widget.ssid,
                                'password': widget.password,
                                'user_id': currentUser!.uid,
                                'token': validator.padRight(5, '0'),
                              }))
                          .then((onResponse) {
                        print('>>>>>>>>> ${onResponse.body}');
                      });
                      // print('<<<<<<<<<<<<<<<<<<<<<<<< ${response?.statusCode}');
                      // if (response?.statusCode == 200) {
                      //   print("account created succesfully");
                      // } else {
                      //   print('failed');
                      // }
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckConecction(
                                  validator: validator.padRight(5, '0'),
                                )),
                      );
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data![index].ssid ?? '<Desconocido>'),
                          Text(
                            'Estado de Red: ${levelSignal(snapshot.data![index].level ?? -100)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                children: [
                  Icon(Icons.warning_amber_rounded),
                  Text('No hay Redes Disponibles')
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

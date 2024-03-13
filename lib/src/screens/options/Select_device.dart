// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, use_build_context_synchronously

import 'dart:math';
// import 'dart:convert';
import 'package:app_settings/app_settings.dart';
import 'package:aquavista/src/util/dialogs.dart';
// import 'package:aquavista/src/util/snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;

import 'package:wifi_iot/wifi_iot.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/functions/dialogs_functions.dart';
import 'package:aquavista/src/functions/setting_functions.dart';

// import 'package:aquavista/src/screens/options/check_conection.dart';

class SelectDevice extends StatefulWidget {
  const SelectDevice(this.ssid, this.bssid, this.password, this.networks,
      {Key? key})

      : super(key: key);
  final String ssid;
  final String bssid;
  final String password;
  final List<WifiNetwork> networks;

  @override
  State<StatefulWidget> createState() {
    return SelectDeviceState();
  }
}

class SelectDeviceState extends State<SelectDevice> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final _firebaseMessaging = FirebaseMessaging.instance;

  bool isScanning = true;
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
          final allNetworks = snapshot.data ?? widget.networks;

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(backgroundColor: Colors.red),
            );
          }
          if (snapshot.hasError) {
            return error(context, 'Error in StreamBuilder');
          }
          if (allNetworks.isNotEmpty) {
            return ListView.separated(
              itemCount: allNetworks.length,

              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    if (allNetworks[index].ssid != null) {
                      debugPrint(
                          ">>>>>>>>>>>>>> ${allNetworks[index].ssid!}, ");
                      await AppSettings.openWIFISettings(asAnotherTask: true);
                      String validator = getRandomInt().toString();
                      await confirmWiFiIoT(
                        context,
                        allNetworks[index].ssid!,
                        await _firebaseMessaging.getToken(),
                        allNetworks[index].ssid!,
                        widget.bssid,
                        widget.password,
                        currentUser!.uid,
                        validator,
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
                          Text(allNetworks[index].ssid ?? '<Desconocido>'),
                          Text(
                            'Estado de Red: ${levelSignal(allNetworks[index].level ?? -100)}',

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

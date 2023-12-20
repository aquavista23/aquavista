// import 'dart:html';

import 'package:aquavista/src/functions/setting_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:aquavista/src/util/style.dart';
import 'package:flutter/services.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: textWithStroke(
              text: 'Ajustes',
              textColor: logoImageColor,
              strokeColor: Colors.black),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            buttonSetting('Editar Perfil', Icons.person, () async {}),
            const SizedBox(
              height: 10.0,
            ),
            buttonSetting('Agregar Dispositivo', Icons.add, () async {
              final connect = Connectivity();
              late ConnectivityResult result;
              // Platform messages may fail, so we use a try/catch PlatformException.
              try {
                result = await connect.checkConnectivity();
              } on PlatformException catch (e) {
                print('Couldn\'t check connectivity status ${e.toString()}');
                return;
              }
              print('???????????/ ${result.name}');
              if (true) {
                print('>>>>>>>>>>>>> ${await getWifiName()}');
                print('>>>>>>>>>>>>> ${await getWifiSSID()}');
                print('>>>>>>>>>>>>> ${await getWifiSignalLevel()}');
                print('>>>>>>>>>>>>> ${await getWifiIp()}');
              }
              // List<WifiNetwork?> lts = await getWifiList() ?? [];
              // for (var v = 0; v < lts.length; v++) {
              //   print('>>>>>>>>>>>>> ${lts[v]?.password}');
              // }
            }),
            const SizedBox(
              height: 10.0,
            ),
            buttonSetting('Reestablecer', Icons.restart_alt, () async {})
          ],
        ));
  }
}

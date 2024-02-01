// import 'dart:html';

// ignore_for_file: use_build_context_synchronously

import 'package:aquavista/src/functions/setting_functions.dart';
import 'package:aquavista/src/screens/options/share_devices.dart';
import 'package:aquavista/src/screens/options/wifi_setting.dart';
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
              String ssid = '';
              String bssid = '';
              // Platform messages may fail, so we use a try/catch PlatformException.
              try {
                result = await connect.checkConnectivity();
              } on PlatformException catch (e) {
                print('Couldn\'t check connectivity status ${e.toString()}');
                return;
              }
              ssid = await getWifiName() ?? '';
              bssid = await getWifiSSID() ?? '';
              // print('???????????/ ${result.name}');
              // if (true) {
              //   print('>>>>>>>>>>>>> getWifiName: $ssid');
              //   print('>>>>>>>>>>>>> getWifiSSID: $bssid');
              //   print(
              //       '>>>>>>>>>>>>> getWifiSignalLevel: ${await getWifiSignalLevel()}');
              //   print('>>>>>>>>>>>>> getWifiIp: ${await getWifiIp()}');
              // }

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WifiPage(ssid: ssid, bssid: bssid)),
              );

              // print(
              //     '>>>>>>>>>>>>> testEsp(): ${testEsp(await getWifiName(), await getWifiSSID(), 'DURAN1995')}');
              // // List<WifiNetwork?> lts = await getWifiList() ?? [];
              // // for (var v = 0; v < lts.length; v++) {
              // //   print('>>>>>>>>>>>>> ${lts[v]?.password}');
              // // }
            }),
            const SizedBox(
              height: 10.0,
            ),
            buttonSetting('Compartir', Icons.share_outlined, () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShareDevices()),
              );
            }),
            const SizedBox(
              height: 10.0,
            ),
            buttonSetting('Reestablecer', Icons.restart_alt, () async {})
          ],
        ));
  }
}

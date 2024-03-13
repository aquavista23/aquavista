// ignore_for_file: deprecated_member_use

// import 'package:esp_smartconfig/esp_smartconfig.dart';
// import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';

Future<bool> isConnected() async {
  try {
    {
      return await WiFiForIoTPlugin.isConnected();
    }
  } on Exception catch (_) {
    return false;
  }
}

Future<String?> getWifiName() async {
  try {
    {
      return await WiFiForIoTPlugin.getSSID();
    }
  } on Exception catch (_) {
    return '';
  }
}

Future<String?> getWifiBSSID() async {
  try {
    return await WiFiForIoTPlugin.getBSSID();
  } on Exception catch (_) {
    return '';
  }
}

Future<int?> getWifiSignalLevel() async {
  try {
    return await WiFiForIoTPlugin.getCurrentSignalStrength();
  } on Exception catch (_) {
    return -100;
  }
}

Future<String?> getWifiIp() async {
  try {
    return await WiFiForIoTPlugin.getIP();
  } on Exception catch (_) {
    return '';
  }
}

// Future<String?> getWifiSegurity() async {
//   try {
//     return await WiFiForIoTPlugin.;
//   } on Exception catch (_) {
//     return '';
//   }
// }

Future<bool> tryConecction(
  String ssid,
  String bssid,
) async {
  try {
    {
      bool res = await WiFiForIoTPlugin.connect(
        ssid,
        bssid: bssid,
        // security: NetworkSecurity.WPA,

      );
      await WiFiForIoTPlugin.forceWifiUsage(true);
      return res;
    }
  } on Exception catch (_) {
    return false;
  }
}

Future<List<WifiNetwork>?> enableDevices() async {
  try {
    {
      return await WiFiForIoTPlugin.loadWifiList();
    }
  } on Exception catch (_) {
    return null;
  }
}

Stream<List<WifiNetwork>>? searcDevices() {
  try {
    {
      return WiFiForIoTPlugin.onWifiScanResultReady;
    }
  } on Exception catch (_) {
    return null;
  }
}

// Future<void> testEsp(String? ssid, String? bssid, String pass) async {
//   // logging.level = LogLevel.debug;
//   try {
//     final provisioner = Provisioner.espTouchV2();

//     print("pre listener!");
//     provisioner.listen((response) {
//       print("pre listener!!");
//       // log.info("\n"
//       //     "\n------------------------------------------------------------------------\n"
//       print("Device (${response.ipAddressText}) is connected to WiFi!");
//       //     "\n------------------------------------------------------------------------\n");
//     }, onError: (e) {
//       print(e.toString());
//     });

//     //   await provisioner.start(ProvisioningRequest.fromStrings(
//     //     ssid: ssid ?? '',
//     //     bssid: bssid ?? '',
//     //     password: pass,
//     //   ));
//     provisioner.stop();
//     //   await Future.delayed(const Duration(seconds: 10));
//   } catch (e, s) {
//     print('${e.toString()} ??? ${s.toString()}');
//     // log.error(e, s);
//   }

//   exit(0);
// }

// Future<bool> getWifiAccess(String wifiSSID, String wifiPass) async =>
//     await WiFiForIoTPlugin.connect(wifiSSID, password: wifiPass);

// Future<List<WifiNetwork?>?> getWifiList() async {
//   try {
//     return await WiFiForIoTPlugin.loadWifiList();
//   } on Exception catch (_) {
//     return null;
//   }
// }

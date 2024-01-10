// ignore_for_file: deprecated_member_use

// import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:network_info_plus/network_info_plus.dart';

final NetworkInfo info = NetworkInfo();
Future<String?> getWifiName() async {
  try {
    {
      return await info.getWifiName();
    }
  } on Exception catch (_) {
    return '';
  }
}

Future<String?> getWifiSSID() async {
  try {
    return await info.getWifiBSSID();
  } on Exception catch (_) {
    return '';
  }
}

Future<String?> getWifiSignalLevel() async {
  try {
    return await info.getWifiBroadcast();
  } on Exception catch (_) {
    return '';
  }
}

Future<String?> getWifiIp() async {
  try {
    return await info.getWifiIP();
  } on Exception catch (_) {
    return '';
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

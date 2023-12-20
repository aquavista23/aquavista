// ignore_for_file: deprecated_member_use
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

// Future<bool> getWifiAccess(String wifiSSID, String wifiPass) async =>
//     await WiFiForIoTPlugin.connect(wifiSSID, password: wifiPass);

// Future<List<WifiNetwork?>?> getWifiList() async {
//   try {
//     return await WiFiForIoTPlugin.loadWifiList();
//   } on Exception catch (_) {
//     return null;
//   }
// }

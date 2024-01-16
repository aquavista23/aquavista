import 'package:aquavista/src/util/style.dart';

List<Map<String, dynamic>> mapDateOrder(List<Map<String, dynamic>>? maps) {
  maps!.sort((a, b) {
    return DateTime.parse(a["fecha"]).compareTo(DateTime.parse(b["fecha"]));
  });
  print(maps);
  return maps;
}

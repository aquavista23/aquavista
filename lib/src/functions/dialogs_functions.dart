String levelSignal(int level) {
  String result = '';
  if (level >= -50) {
    result = 'Excelente';
  } else if (level <= -51 && level >= -60) {
    result = 'Bueno';
  } else if (level <= -61 && level >= -70) {
    result = 'Regular';
  } else if (level <= -71 && level >= -85) {
    result = 'Mala';
  } else {
    result = 'Muy Mala';
  }
  return result;
}

String nameWIFI(String ssid) {
  String result = '';
  if (ssid.length > 15) {
    result = ssid.substring(1, 15);
  } else {
    result = ssid;
  }
  return result;
}

import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';

ButtonStyle buttonStyle({required double radium}) {
  return ElevatedButton.styleFrom(
    primary: mainColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radium),
    ),
  );
}

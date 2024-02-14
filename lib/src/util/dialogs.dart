// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';

Widget alertDialogCustomize(
    {double? height, required Widget child, Color? color}) {
  height = (height != null) ? height : 350;
  return Dialog(
    backgroundColor: (color == null) ? Colors.white : color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Container(
      height: height,
      width: 250.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
      child: Column(
        children: [
          Container(
            height: (height * 14.5) / 100,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: (color == null) ? mainColor : color),
          ),
          Container(height: (height * 85.5) / 100, child: child),
        ],
      ),
    ),
  );
}

Future<void> transactionFailed(
        BuildContext context, String title, String error) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext mainContext) => alertDialogCustomize(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 5),
                Center(
                  child: ListTile(
                    title: const Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 50,
                    ),
                    subtitle: Text(
                      error,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  child: ElevatedButton(
                    style: buttonStyle(radium: 30.0),
                    child: const Text(
                      "Ok",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.of(mainContext).pop(false),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

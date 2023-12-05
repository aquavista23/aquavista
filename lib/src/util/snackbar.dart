import 'package:flutter/material.dart';

ScaffoldMessengerState snackBarWithIcon({
  required BuildContext context,
  required String text,
  required Color color,
  required IconData icon,
}) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text),
              Icon(icon),
            ],
          ),
          backgroundColor: color,
        ),
      );

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar({
  required BuildContext context,
  required String text,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(text),
        const CircularProgressIndicator(),
      ],
    )));

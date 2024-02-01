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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarAlert({
  required String text,
  required BuildContext context,
  required Color color,
}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
        )),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 20.0),
    backgroundColor: Colors.black.withOpacity(0.5),
    duration: const Duration(milliseconds: 1500),
  ));
}

import 'package:flutter/material.dart';

Future<bool> showGenDialog({
  required BuildContext context,
  required String text,
}) async {
  bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Cerrar Sesión'),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Si'),
        ),
      ],
    ),
  );
  if (result != null) {
    return result;
  } else {
    return false;
  }
}

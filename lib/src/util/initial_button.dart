import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';

import 'package:aquavista/src/util/elevatedbuttoshape.dart';

class InitialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const InitialButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle(radium: 30.0),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: logoImageColor),
      ),
    );
  }
}

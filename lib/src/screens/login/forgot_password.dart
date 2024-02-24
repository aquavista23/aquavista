// ignore_for_file: unnecessary_null_comparison

import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';

import 'package:aquavista/src/repository/user_repository.dart';
import 'package:aquavista/src/screens/forgot/forgot_screen.dart';

class ForgotPasswordButton extends StatelessWidget {
  final UserRepository _userRepository;

  const ForgotPasswordButton({Key? key, required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: textWithStroke(
          text: 'Olvide mi Contraseña',
          textColor: logoImageColor,
          strokeColor: mainColor,
          textSize: 16),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ForgotScreen(
            userRepository: _userRepository,
          );
        }));
      },
    );
  }
}

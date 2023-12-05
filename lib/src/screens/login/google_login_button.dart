import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aquavista/src/util/snackbar.dart';
import 'package:aquavista/src/bloc/login_bloc/bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleAuthButton(
      text: 'Iniciar Con Google',
      onPressed: () {
        snackBar(context: context, text: 'Loggin in...');

        BlocProvider.of<LoginBloc>(context).add(LoginWithGooglePressed());
      },
      style: AuthButtonStyle(buttonColor: mainColor, borderRadius: 30.0),
    );
  }
}

//imports:
// ignore_for_file: unnecessary_null_comparison
import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aquavista/src/screens/login/login_form.dart';
import 'package:aquavista/src/bloc/login_bloc/bloc.dart';
import 'package:aquavista/src/repository/user_repository.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const LoginScreen({Key? key, required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: textWithStroke(
            text: 'Login', textColor: mainColor, strokeColor: logoImageColor),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/water_top.png"),
              fit: BoxFit.scaleDown,
              opacity: 0.2,
              alignment: Alignment.topCenter),
        ),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/water.png"),
                fit: BoxFit.scaleDown,
                opacity: 0.25,
                alignment: Alignment.bottomCenter),
          ),
          child: BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(userRepository: _userRepository),
            child: LoginForm(userRepository: _userRepository),
          ),
        ),
      ),
    );
  }
}

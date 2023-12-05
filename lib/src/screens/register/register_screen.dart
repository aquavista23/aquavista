// ignore_for_file: unnecessary_null_comparison
import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aquavista/src/bloc/register_bloc/bloc.dart';
import 'package:aquavista/src/screens/register/register_form.dart';
import 'package:aquavista/src/repository/user_repository.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const RegisterScreen({Key? key, required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: textWithStroke(
            text: 'Registrar',
            textColor: mainColor,
            strokeColor: logoImageColor),
      ),
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
          child: Center(
            child: BlocProvider<RegisterBloc>(
              create: (context) =>
                  RegisterBloc(userRepository: _userRepository),
              child: const RegisterForm(),
            ),
          ),
        ),
      ),
    );
  }
}

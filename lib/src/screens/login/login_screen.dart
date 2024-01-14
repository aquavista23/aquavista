//imports:
// ignore_for_file: unnecessary_null_comparison
import 'package:aquavista/src/util/permission.dart';
import 'package:aquavista/src/util/snackbar.dart';
import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aquavista/src/screens/login/login_form.dart';
import 'package:aquavista/src/bloc/login_bloc/bloc.dart';
import 'package:aquavista/src/repository/user_repository.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginScreen({Key? key, required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool permisos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Login'),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/water.png"),
              fit: BoxFit.scaleDown,
              opacity: 0.25,
              alignment: Alignment.bottomCenter),
        ),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/water_top.png"),
                fit: BoxFit.scaleDown,
                opacity: 0.2,
                alignment: Alignment.topCenter),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: FutureBuilder(
                        future: checkPermissions(context),
                        initialData: false,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          permisos = snapshot.data;
                          return Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                tooltip: 'Estado de Permisos',
                                icon: (permisos)
                                    ? const Icon(
                                        Icons.check_circle_outline_sharp)
                                    : const Icon(Icons.do_disturb_alt_outlined),
                                color: (permisos) ? Colors.green : Colors.red,
                                onPressed: () async {
                                  if (permisos) {
                                    snackBar(
                                      context: context,
                                      text: 'Permisos Otorgados',
                                    );
                                  } else {
                                    setState(() async {
                                      permisos =
                                          await checkPermissions(context);
                                    });
                                  }
                                }),
                          );
                        },
                      ),
                    ),
                    Container()
                  ],
                ),
              ),
              BlocProvider<LoginBloc>(
                create: (context) =>
                    LoginBloc(userRepository: widget._userRepository),
                child: LoginForm(userRepository: widget._userRepository),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

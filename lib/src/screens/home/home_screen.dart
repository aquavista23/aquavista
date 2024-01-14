import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/widgets/drawer.dart';
import 'package:aquavista/src/util/show_dialog.dart';
import 'package:aquavista/src/bloc/authentication_bloc/bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('Aquavista'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                if (await showGenDialog(
                    context: context,
                    text: '¿Esta seguro que desea Cerrar Sesión?')) {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                }
              },
            )
          ],
        ),
        body: Builder(builder: (context) {
          return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Center(
                child: Image.asset("assets/LOGO.png"),
              ));
        }));
  }
}

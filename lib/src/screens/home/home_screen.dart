import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/util/show_dialog.dart';
import 'package:aquavista/src/widgets/tiles_group.dart';
import 'package:aquavista/src/screens/home/buildtiles.dart';
import 'package:aquavista/src/bloc/authentication_bloc/bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: textWithStroke(
              text: 'Aquavista',
              textColor: mainColor,
              strokeColor: logoImageColor),
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
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: tilesGroup(buildTiles()),
              ),
              Expanded(child: Container())
            ],
          );
        }));
  }
}

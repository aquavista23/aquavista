import 'package:aquavista/src/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:aquavista/src/bloc/authentication_bloc/authentication_event.dart';
import 'package:aquavista/src/screens/shared/shared_screen.dart';
import 'package:aquavista/src/screens/statistics/plots_screens.dart';
import 'package:aquavista/src/util/show_dialog.dart';
import 'package:flutter/material.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/screens/setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text(''),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/LOGO.png"),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          ListTile(
              title: Text(
                'Estadisticas',
                style: TextStyle(color: mainColor),
              ),
              leading: Icon(
                Icons.poll_outlined,
                color: mainColor,
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlotsScreen()),
                );
              }),
          ListTile(
              title: Text(
                'Compartidos',
                style: TextStyle(color: mainColor),
              ),
              leading: Icon(
                Icons.share_outlined,
                color: mainColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SharedScreen()),
                );
              }),
          ListTile(
              title: Text(
                'Ajustes',
                style: TextStyle(color: mainColor),
              ),
              leading: Icon(
                Icons.settings,
                color: mainColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Setting()),
                );
              }),
          ListTile(
            title: const Text(
              'Cierrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              if (await showGenDialog(
                  context: context,
                  text: '¿Esta seguro que desea Cerrar Sesión?')) {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              }
            },
            leading: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

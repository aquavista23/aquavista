import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/models/user_model.dart';
import 'package:aquavista/src/screens/options/edit_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CollectionReference userColection =
      FirebaseFirestore.instance.collection('usuarios');
  final refDatabase = FirebaseDatabase.instance;
  String nombre = '';
  String apellido = '';
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información'),
        backgroundColor: mainColor,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outlined),
            onPressed: () async {
              // if (await showGenDialog(
              //     context: context,
              //     text: '¿Esta seguro que desea Cerrar Sesión?')) {
              //   BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              // }
            },
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: userColection.doc(currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data != null) {
              UserData? user = UserData.fromJson(snapshot.data!.data() as Map);

              nombre = user.nombre!;
              apellido = user.apellido!;

              return Container(
                padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          width: 80,
                        ),
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/LOGO_small.png',
                                  ))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: textContainer(user.nombre!, 'Nombre')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child:
                                    textContainer(user.apellido!, 'Apellido')),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: textContainer(user.email!, 'E-mail')),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: textContainer(
                                    formatDateSync.format(user.fechaInsersion!),
                                    'Fecha Regintro')),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Divider(
                          height: 5.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: buttonSetting(
                                  'Editar Perfil', Icons.edit_outlined,
                                  () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfilePage(
                                          name: nombre, fName: apellido)),
                                );
                              }, radium: 10.0),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buttonSetting('Restablecer Cuenta',
                            Icons.replay_circle_filled_outlined, () async {},
                            colorStroke: Colors.red.withOpacity(0.9),
                            radium: 10.0),
                        const SizedBox(
                          height: 10,
                        ),
                        buttonSetting('Eliminar Cuenta',
                            Icons.no_accounts_outlined, () async {},
                            colorButton: Colors.red.withOpacity(0.9),
                            radium: 10.0),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

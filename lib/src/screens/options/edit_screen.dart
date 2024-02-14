import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/util/snackbar.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String fName;
  const EditProfilePage({Key? key, required this.name, required this.fName})
      : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  CollectionReference userColection =
      FirebaseFirestore.instance.collection('usuarios');
  final refDatabase = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _fNameController = TextEditingController();

  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confPassController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  // String? imageUrl;
  // UserData? userModel;
  bool activeButton = false;
  bool showPassword = false;

  bool validateName = false;
  bool validateFName = false;
  bool validateOldPass = false;
  bool validateNewPass = false;
  bool validatePassConf = false;

  final List<Tab> myTabs = <Tab>[
    const Tab(
        child: Icon(
      color: Colors.white,
      Icons.person_outline_outlined,
    )),
    const Tab(
        child: Icon(
      color: Colors.white,
      Icons.password,
    )),
  ];

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.name);
    _fNameController = TextEditingController(text: widget.fName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar'),
          backgroundColor: mainColor,
          elevation: 1,
          bottom: TabBar(indicatorColor: Colors.amberAccent, tabs: myTabs),
        ),
        body: TabBarView(
          children: [
            containerWithList(
              tittle: "Editar Nombre y Apellido",
              context: context,
              childrens: [
                TextFormField(
                  controller: _nameController,
                  // initialValue: user.nombre ?? '',
                  decoration: const InputDecoration(
                    icon: Icon(Icons.contacts_rounded),
                    labelText: 'Nombre',
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return validateName ? 'Nombre Invalido' : null;
                  },
                  onChanged: (value) {
                    bool aux = false;
                    if (value.isNotEmpty) {
                      aux = false;
                    } else {
                      aux = true;
                    }

                    setState(() {
                      validateName = aux;
                    });
                  },
                ),
                TextFormField(
                  controller: _fNameController,
                  // initialValue: user.apellido ?? '',
                  decoration: const InputDecoration(
                    icon: Icon(Icons.contacts_rounded),
                    labelText: 'Apellido',
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return validateFName ? 'Apellido Invalido' : null;
                  },
                  onChanged: (value) {
                    bool aux = false;
                    if (value.isNotEmpty) {
                      aux = false;
                    } else {
                      aux = true;
                    }

                    setState(() {
                      validateFName = aux;
                    });
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                rowOfButtons(
                  context: context,
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty) {
                      if (_fNameController.text.isNotEmpty) {
                        try {
                          await userColection
                              .doc(currentUser!.uid)
                              .update({'nombre': _nameController.text});

                          await userColection
                              .doc(currentUser!.uid)
                              .update({'apellido': _fNameController.text});
                        } catch (e) {
                          debugPrint(
                              '??????????????//updateName ${e.toString()}');
                        }
                      } else {
                        snackBarAlert(
                            text: 'Apellido no Valido',
                            context: context,
                            color: Colors.red);
                      }
                    } else {
                      snackBarAlert(
                          text: 'Nombre no Valido',
                          context: context,
                          color: Colors.red);
                    }
                  },
                )
              ],
            ),
            containerWithList(
              tittle: 'Cambiar Contraseña',
              context: context,
              childrens: [
                TextFormField(
                  controller: _oldPassController,
                  // initialValue: user.nombre ?? '',
                  decoration: const InputDecoration(
                    icon: Icon(Icons.contacts_rounded),
                    labelText: 'Contraseña Actual',
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  obscureText: !showPassword,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return validateOldPass
                        ? 'La contraseña es incorrecta'
                        : null;
                  },
                  onChanged: (value) {
                    bool aux = false;
                    bool auxActiveButton = false;
                    if (value.isNotEmpty) {
                      aux = false;
                    } else {
                      aux = true;
                    }

                    setState(() {
                      validateOldPass = aux;
                      activeButton = auxActiveButton;
                    });
                  },
                ),
                TextFormField(
                  controller: _newPassController,
                  // initialValue: user.nombre ?? '',
                  decoration: const InputDecoration(
                    icon: Icon(Icons.contacts_rounded),
                    labelText: 'Nueva Contraseña',
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  obscureText: !showPassword,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return validateNewPass
                        ? 'La contraseña debe tener almenos 6 caracteres'
                        : null;
                  },
                  onChanged: (value) {
                    bool aux = false;
                    bool auxActiveButton = false;
                    if (value.isNotEmpty) {
                      aux = false;
                      auxActiveButton = (_newPassController.text.length > 5 &&
                          _confPassController.text.length > 5);
                    } else {
                      aux = true;
                      auxActiveButton = false;
                    }

                    setState(() {
                      validateNewPass = aux;
                      activeButton = auxActiveButton;
                    });
                  },
                ),
                TextFormField(
                  controller: _confPassController,
                  // initialValue: user.apellido ?? '',
                  decoration: const InputDecoration(
                    icon: Icon(Icons.contacts_rounded),
                    labelText: 'Confirmar Contraseña',
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  obscureText: !showPassword,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return validatePassConf ? 'Contraseña no coinside' : null;
                  },
                  onChanged: (value) {
                    bool aux = false;
                    bool auxActiveButton = false;
                    if (value.isNotEmpty) {
                      aux = false;
                      auxActiveButton = (_newPassController.text.length > 5 &&
                          _confPassController.text.length > 5);
                    } else {
                      aux = true;
                      auxActiveButton = false;
                    }

                    setState(() {
                      validatePassConf = aux;
                      activeButton = auxActiveButton;
                    });
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mostrar Contraseña'),
                    SizedBox(
                      child: Checkbox(
                        value: showPassword,
                        onChanged: (value) {
                          setState(() {
                            showPassword = value ?? false;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                rowOfButtons(
                  context: context,
                  colorSave: (activeButton) ? mainColor : Colors.grey,
                  onPressed: (activeButton)
                      ? () async {
                          String toast = '';
                          bool auxValidateOldPass = validateOldPass;
                          if (_newPassController.text.isNotEmpty) {
                            if (_confPassController.text.isNotEmpty &&
                                (_confPassController.text ==
                                    _newPassController.text)) {
                              if (_newPassController.text.length > 5) {
                                try {
                                  if (user != null) {
                                    final cred = EmailAuthProvider.credential(
                                        email: user!.email!,
                                        password: _oldPassController.text);
                                    user!
                                        .reauthenticateWithCredential(cred)
                                        .then((value) {
                                      user!
                                          .updatePassword(
                                              _newPassController.text)
                                          .then((_) {
                                        //Success, do something
                                        snackBarAlert(
                                            text:
                                                'Contraseña Cambiada con Exito',
                                            context: context,
                                            color: Colors.green);
                                      }).catchError((error) {
                                        //Error, show something
                                        toast = 'Error al Cambiar contraseña';
                                        auxValidateOldPass = true;
                                        debugPrint(
                                            '??????????????//updatePassword ${error.toString()}');
                                      });
                                    });
                                  } else {
                                    debugPrint("password hasnt been changed");
                                    auxValidateOldPass = true;
                                    // No user is signed in.
                                  }
                                } catch (e) {
                                  toast = 'Error al Cambiar contraseña';
                                  auxValidateOldPass = true;
                                  debugPrint(
                                      '??????????????//updatePassword ${e.toString()}');
                                }
                              } else {
                                toast =
                                    'La Contraseña debe tener almenos 6 Caracteres';
                              }
                            } else {
                              toast = 'Contraseña no Coinside';
                            }
                          } else {
                            toast = 'Contraseña no debe ser nulo';
                          }
                          if (toast.isNotEmpty) {
                            snackBarAlert(
                                text: toast,
                                context: context,
                                color: Colors.red);
                          }
                          setState(() {
                            validateOldPass = auxValidateOldPass;
                          });
                        }
                      : () {
                          snackBarAlert(
                              text: 'Debe llenar los campos antes de Guardar',
                              context: context,
                              color: Colors.red);
                        },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

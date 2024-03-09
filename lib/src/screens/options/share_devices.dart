// ignore_for_file: avoid_unnecessary_containers

import 'package:aquavista/src/util/snackbar.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/models/user_model.dart';

class ShareDevices extends StatefulWidget {
  const ShareDevices({Key? key}) : super(key: key);

  @override
  State<ShareDevices> createState() => _ShareDevicesState();
}

class _ShareDevicesState extends State<ShareDevices> {
  CollectionReference userColection =
      FirebaseFirestore.instance.collection('usuarios');
  UserData? user;
  List? values = [];
  List<Map> tokens = [];
  bool deleteSelect = false;
  List<String> listDelete = [];
  Map<String, bool> sharedWith = {};
  List<UserData> listUserShared = [];
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('Compartir'),
          actions: <Widget>[
            (deleteSelect)
                ? IconButton(
                    icon: const Icon(Icons.delete_outline_sharp),
                    onPressed: () async {
                      await userColection
                          .doc(currentUser!.uid)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) async {
                        if (documentSnapshot.exists) {
                          List<String> listID = [];
                          Map mapShared = {};
                          Map participt = {};
                          // Map<String, bool> auxSharedWith = sharedWith;
                          // List? auxValues = values;
                          try {
                            Map shared = documentSnapshot.data() as Map;

                            listID.addAll(shared['compartir'].keys);

                            for (var v = 0; v < listID.length; v++) {
                              await userColection
                                  .doc(listID[v])
                                  .get()
                                  .then((sharedSnapshot) async {
                                if (sharedSnapshot.exists) {
                                  mapShared[listID[v]] =
                                      sharedSnapshot['token'];
                                }
                              });
                            }

                            for (var i = 0; i < listDelete.length; i++) {
                              if (mapShared.containsKey(listDelete[i])) {
                                mapShared.remove(listDelete[i]);
                              }
                            }

                            for (var i = 0; i < listDelete.length; i++) {
                              participt = await userColection
                                  .doc(listDelete[i])
                                  .get()
                                  .then((value) => value['participa']);

                              participt.remove(currentUser!.uid);

                              await userColection
                                  .doc(listDelete[i])
                                  .update({'participa': participt});
                            }
                            setState(() {
                              deleteSelect = false;
                            });
                            await userColection
                                .doc(currentUser!.uid)
                                .update({'compartir': mapShared});
                          } catch (e) {
                            debugPrint(
                                '??????????????//DeleteShared ${e.toString()}');
                          }
                        }
                      });
                    },
                  )
                : Container()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          tooltip: 'Compartir Dispositivo',
          child: const Icon(Icons.group_add_outlined),
          onPressed: () async {
            await bottomSheet(context, listUserShared);
          },
        ),
        body: Builder(builder: (context) {
          return StreamBuilder<DocumentSnapshot>(
              stream: userColection.doc(currentUser!.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data != null) {
                  listUserShared = [];
                  UserData? user =
                      UserData.fromJson(snapshot.data!.data() as Map);
                  user.compartir?.remove(currentUser!.uid);
                  values = user.compartir?.keys.toList();

                  return FutureBuilder<List<UserData>>(
                      future: userShared(userColection, values!),
                      builder: (context, futSnapshot) {
                        if (!futSnapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return (futSnapshot.data!.isNotEmpty)
                            ? Column(
                                children: [
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  const Text(
                                    '_____Seleccione contacto para eliminar_____',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: futSnapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return card(
                                            email:
                                                futSnapshot.data![index].email,
                                            token:
                                                futSnapshot.data![index].token,
                                            values: values!,
                                            ind: index);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      textWhenIsNull(
                                          'No tiene usuarios viculados para compartir.',
                                          16.0),
                                      textWhenIsNull(
                                          'Pulse el boton para vincular otro usuario.',
                                          16.0),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: mainColor,
                                          fixedSize: const Size(60, 60),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: () async {
                                          await bottomSheet(
                                              context, listUserShared);
                                        },
                                        child: const Icon(
                                            Icons.group_add_outlined),
                                      )
                                    ]),
                              );
                      });
                } else {
                  return Container();
                }
              });
        }));
  }

  Future<List<UserData>> userShared(
      CollectionReference userColection, List values) async {
    List<UserData> contacts = [];
    if (sharedWith.isEmpty || values.length != sharedWith.length) {
      sharedWith.clear();
      for (var i = 0; i < values.length; i++) {
        sharedWith[values[i]] = false;
      }
    }

    for (var v = 0; v < values.length; v++) {
      await userColection
          .doc(values[v])
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          contacts.add(UserData.fromJson(documentSnapshot.data() as Map));
        }
      });
    }
    listUserShared = contacts;
    return contacts;
  }

  Widget card({
    String? email,
    String? token,
    required List values,
    required int ind,
  }) {
    Map<String, bool> auxShareWith = sharedWith;
    return (ind < values.length)
        ? cardWithPadding(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(email ?? ''),
                SizedBox(
                  child: Checkbox(
                    value: sharedWith[values[ind]],
                    onChanged: (bool? value) {
                      bool ds = false;
                      List<String> auxListDel = [];
                      auxShareWith[values[ind]] = value!;

                      for (var i = 0; i < auxShareWith.length; i++) {
                        if (auxShareWith.values.toList()[i]) {
                          ds = true;
                          auxListDel.add(auxShareWith.keys.toList()[i]);
                        }
                      }
                      setState(() {
                        sharedWith = auxShareWith;
                        deleteSelect = ds;
                        listDelete = auxListDel;
                      });
                    },
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  Widget textWhenIsNull(String text, double size) => Text(
        text,
        style: TextStyle(color: mainColor, fontSize: size),
      );

  Future<void> bottomSheet(BuildContext context, List<UserData> emails) async {
    TextEditingController resultController = TextEditingController();
    UserData? result;
    bool clearText = false;
    bool userExist = true;
    bool addContact = false;
    String userExistText = '';
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.966,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter thisState) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: mainColor,
                  title: TextField(
                    controller: resultController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: "Buscar Usuario",
                        hintStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: mainColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            thisState(() {
                              resultController.clear();
                              result = null;
                              clearText = false;
                            });
                          },
                          icon: const Icon(Icons.clear),
                        )),
                    onSubmitted: (value) async {
                      CollectionReference userColection =
                          FirebaseFirestore.instance.collection('usuarios');
                      List<UserData> allData = [];
                      bool auxUserExist = true;
                      String msg = '';
                      await userColection
                          .get()
                          .then((QuerySnapshot querySnapshot) async {
                        if (querySnapshot.docs.isNotEmpty) {
                          querySnapshot.docs
                              .map((doc) => doc.data())
                              .toList()
                              .forEach((element) {
                            allData.add(UserData.fromJson(
                                element as Map<String, dynamic>));
                          });
                          UserData? auxResult;
                          for (var v = 0; v < allData.length; v++) {
                            if (allData[v].email!.trim() ==
                                resultController.text.trim()) {
                              auxResult = allData[v];
                            }
                          }
                          if (auxResult != null) {
                            for (var element in emails) {
                              if (auxResult.email == element.email) {
                                auxUserExist = false;
                                msg = 'Ya Compartes Con Este Usuario';
                                break;
                              }
                              auxUserExist = true;
                            }
                            if (auxResult.email == currentUser!.email) {
                              msg = 'Usuario en sesion';
                              auxUserExist = false;
                            }
                          }
                          thisState(() {
                            userExist = auxUserExist;
                            userExistText = msg;
                            result = auxResult;
                            clearText = true;
                          });
                        }
                      });
                    },
                  ),
                  actions: <Widget>[
                    (addContact)
                        ? IconButton(
                            icon: const Icon(Icons.done),
                            onPressed: () async {
                              await userColection
                                  .doc(currentUser!.uid)
                                  .get()
                                  .then((DocumentSnapshot
                                      documentSnapshot) async {
                                if (documentSnapshot.exists) {
                                  List<String> listID = [];
                                  Map mapShared = {};
                                  Map participt = {};
                                  try {
                                    Map shared = documentSnapshot.data() as Map;

                                    listID.addAll(shared['compartir'].keys);

                                    for (var v = 0; v < listID.length; v++) {
                                      await userColection
                                          .doc(listID[v])
                                          .get()
                                          .then((sharedSnapshot) async {
                                        if (sharedSnapshot.exists) {
                                          mapShared[listID[v]] =
                                              sharedSnapshot['token'];
                                        }
                                      });
                                    }

                                    await userColection
                                        .doc(result!.uID)
                                        .get()
                                        .then((sharedSnapshot) async {
                                      if (sharedSnapshot.exists) {
                                        participt = sharedSnapshot['participa'];
                                      }
                                    });
                                    print(
                                        '???????????????????????/// $participt');
                                    mapShared[result!.uID] = result!.token;
                                    participt[currentUser!.uid] =
                                        currentUser!.email;

                                    await userColection
                                        .doc(currentUser!.uid)
                                        .update({'compartir': mapShared});

                                    await userColection
                                        .doc(result!.uID)
                                        .update({'participa': participt});
                                  } catch (e) {
                                    debugPrint(
                                        '??????????????//updateShare ${e.toString()}');
                                  }
                                }
                              });
                              if (mounted) Navigator.pop(context);
                            },
                          )
                        : Container()
                  ],
                ),
                body: Container(
                    child: (result != null)
                        ? cardWithPadding(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  result?.email ?? '',
                                  style: TextStyle(
                                      color: (userExist)
                                          ? Colors.black
                                          : Colors.grey),
                                ),
                                SizedBox(
                                  child: Checkbox(
                                    value: addContact,
                                    onChanged: (userExist)
                                        ? (bool? value) {
                                            thisState(() {
                                              addContact = value!;
                                            });
                                          }
                                        : ((value) {
                                            snackBarAlert(
                                              context: context,
                                              text: userExistText,
                                              color: Colors.white,
                                            );
                                          }),
                                  ),
                                )
                              ],
                            ),
                          )
                        : (clearText)
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.search_off_outlined,
                                      size: 50.0,
                                    ),
                                    Text('Sin Coinsidencia')
                                  ],
                                ),
                              )
                            : Container()),
              );
            }),
          );
        });
  }
}

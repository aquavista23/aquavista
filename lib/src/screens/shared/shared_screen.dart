import 'package:aquavista/src/models/user_model.dart';
import 'package:aquavista/src/screens/statistics/plots_screens.dart';
import 'package:aquavista/src/util/constantes.dart';
import 'package:aquavista/src/util/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SharedScreen extends StatefulWidget {
  const SharedScreen({Key? key}) : super(key: key);

  @override
  State<SharedScreen> createState() => _SharedScreenState();
}

class _SharedScreenState extends State<SharedScreen> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(DATABASE);
  CollectionReference userColection =
      FirebaseFirestore.instance.collection('usuarios');
  UserData? user;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('Compartidas'),
        ),
        body: Builder(builder: (context) {
          return StreamBuilder<DocumentSnapshot>(
              stream: userColection.doc(currentUser!.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data != null) {
                  UserData? user =
                      UserData.fromJson(snapshot.data!.data() as Map);
                  List keys = user.participa!.keys.toList();
                  return ListView.separated(
                    itemCount: keys.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return StreamBuilder<DocumentSnapshot>(
                          stream: userColection.doc(keys[index]).snapshots(),
                          builder: (context, snapshotInfo) {
                            if (!snapshotInfo.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.red),
                              );
                            }
                            UserData? userData = UserData.fromJson(
                                snapshotInfo.data!.data() as Map);
                            // List keys = user.participa!.keys.toList();
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PlotsScreen(userShared: userData)),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                margin: const EdgeInsets.all(5),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${userData.nombre ?? ''} ${userData.apellido ?? ''}'),
                                      Text(
                                        user.email ?? '',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  );
                } else {
                  return Container();
                }
              });
        }));
  }
}

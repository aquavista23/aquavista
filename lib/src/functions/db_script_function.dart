// ignore_for_file: avoid_print

import 'package:aquavista/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> updateUser(CollectionReference userColection,
    DocumentSnapshot documentSnapshot, User currentUser, String? token) async {
  try {
    UserData? oldToken = UserData.fromJson(documentSnapshot.data() as Map);
    if (oldToken.token != token) {
      await userColection.doc(currentUser.uid).update({'token': token});
      await userColection
          .doc(currentUser.uid)
          .update({'fecha_token': DateTime.now().toString()});
    }

    return true;
  } catch (e) {
    print('??????????????//update ${e.toString()}');
    return false;
  }
}

Future<bool> updateShare(DocumentSnapshot documentSnapshot,
    CollectionReference userColection, User currentUser) async {
  List<String> listID = [];
  Map mapShared = {};
  try {
    Map shared = documentSnapshot.data() as Map;

    listID.addAll(shared['compartir'].keys);

    for (var v = 0; v < listID.length; v++) {
      await userColection.doc(listID[v]).get().then((sharedSnapshot) async {
        if (sharedSnapshot.exists) {
          mapShared[listID[v]] = sharedSnapshot['token'];
        }
      });
    }
    await userColection.doc(currentUser.uid).update({'compartir': mapShared});

    return true;
  } catch (e) {
    print('??????????????//updateShare ${e.toString()}');
    return false;
  }
}

Future<bool> createUser(String id, String email, String? token) async {
  try {
    UserData? newUser = UserData.fromJson({
      'uid': id,
      'email': email,
      'token': token,
      'fecha_insercion': DateTime.now(),
      'fecha_token': DateTime.now(),
      'compartir': {id: token}
    });
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(id)
        .set(newUser.toMap());
    return true;
  } catch (e) {
    print('??????????????//create ${e.toString()}');
    return false;
  }
}

Future<Map> updateShared(CollectionReference userColection, String id) async {
  try {
    return {};
  } catch (e) {
    print('??????????????//updateShared ${e.toString()}');
    return {};
  }
}

import 'package:aquavista/src/util/dialogs.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:aquavista/src/util/snackbar.dart';

Future<void> deleteUserAccount(BuildContext context) async {
  try {
    await FirebaseAuth.instance.currentUser!.delete();
  } on FirebaseAuthException catch (e) {
    debugPrint('Error al borrar 401');

    if (e.code == "requires-recent-login") {
      await _reauthenticateAndDelete(context);
    } else {
      await transactionFailed(context, 'Error al Borrar Cuenta', e.toString());
    }
  } catch (e) {
    debugPrint('Error al borrar 402');
    snackBarAlert(
        text: 'Error 402 al borrar Cuenta',
        context: context,
        color: Colors.orange);

    // Handle general exception
  }
}

Future<void> _reauthenticateAndDelete(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance;
    final providerData = user.currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await user.currentUser!.reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await user.currentUser!.reauthenticateWithProvider(GoogleAuthProvider());
    }

    await user.currentUser?.delete();
  } catch (e) {
    debugPrint('Error al borrar 404');
    snackBarAlert(
        text: 'Error 404 al borrar Cuenta',
        context: context,
        color: Colors.orange);
  }
}

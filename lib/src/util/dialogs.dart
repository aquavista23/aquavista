// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/util/snackbar.dart';
import 'package:aquavista/src/functions/dialogs_functions.dart';
import 'package:aquavista/src/functions/user_perfil_function.dart';

Widget alertDialogCustomize(
    {double? height, double? width, required Widget child, Color? color}) {
  height = (height != null) ? height : 350;
  width = (width != null) ? width : 250;
  return Dialog(
    backgroundColor: (color == null) ? Colors.white : color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
      child: Column(
        children: [
          Container(
            height: (height * 14.5) / 100,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: (color == null) ? mainColor : color),
          ),
          Container(height: (height * 85.5) / 100, child: child),
        ],
      ),
    ),
  );
}

Future<void> transactionFailed(
        BuildContext context, String title, String error) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext mainContext) => alertDialogCustomize(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 5),
                Center(
                  child: ListTile(
                    title: const Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 50,
                    ),
                    subtitle: Text(
                      error,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  child: ElevatedButton(
                    style: buttonStyle(radium: 30.0),
                    child: const Text(
                      "Ok",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.of(mainContext).pop(false),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

Future<bool> comfirmationAlert(
        {required BuildContext context,
        required String title,
        required String text,
        required Color color,
        required Icon icon}) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext mainContext) => alertDialogCustomize(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 5),
                Center(
                  child: ListTile(
                    title: icon,
                    subtitle: Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: ElevatedButton(
                        style: buttonStyle(radium: 30.0, color: Colors.green),
                        child: const Text(
                          "Aceptar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.of(mainContext).pop(true),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        style: buttonStyle(radium: 30.0, color: Colors.red),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.of(mainContext).pop(false),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ) ??
    false;

Future<bool> confirmPass(BuildContext context, String title) async {
  final TextEditingController passController = TextEditingController();

  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext mainContext) => alertDialogCustomize(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: TextFormField(
                      controller: passController,
                      // initialValue: user.nombre ?? '',
                      decoration: const InputDecoration(
                        icon: Icon(Icons.contacts_rounded),
                        labelText: 'Inserte su Contraseña',
                      ),
                      keyboardType: TextInputType.name,
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.always,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: ElevatedButton(
                          style: buttonStyle(radium: 30.0, color: Colors.green),
                          child: const Text(
                            "Aceptar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            try {
                              User? currentUser =
                                  FirebaseAuth.instance.currentUser;

                              final cred = EmailAuthProvider.credential(
                                  email: currentUser!.email!,
                                  password: passController.text);
                              currentUser
                                  .reauthenticateWithCredential(cred)
                                  .then((value) async {
                                await deleteUserAccount(context);
                                Navigator.of(mainContext).pop(true);
                              });
                            } on Exception catch (e) {
                              snackBarAlert(
                                  text: 'Error \n ${e.toString()}',
                                  context: context,
                                  color: Colors.red);
                              // Navigator.of(mainContext).pop(false);
                            }
                          },
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          style: buttonStyle(radium: 30.0, color: Colors.red),
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => Navigator.of(mainContext).pop(false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ) ??
      false;
}

Future<bool> confirmWifi(BuildContext context, String title, String ssid,
    String bSsid, int signal, bool isConnected) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext mainContext) => ScaffoldMessenger(
          child: Builder(builder: (contextMS) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: alertDialogCustomize(
                height: 300,
                width: 280,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: ListView(
                      children: <Widget>[
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 5),
                        (isConnected)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Conectado a: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              nameWIFI(ssid),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // const SizedBox(height: 5),
                                            Text(
                                              bSsid,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const VerticalDivider(
                                          width: 7.0,
                                          thickness: 2,
                                          color: Colors.grey,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Estado WiFi: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              levelSignal(signal),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              signal.toString(),
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: const [
                                      Text(
                                        'Pulse sobre ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.settings,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'Si desea cambiar la Red WIFI',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            : Center(
                                child: RichText(
                                  text: const TextSpan(
                                      text:
                                          'No esta conectado a una Red WiFi\n\n',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              'Puede ir a Ajustes desde el botón ',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        TextSpan(
                                          text: 'azul ',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 16),
                                        ),
                                        TextSpan(
                                          text: 'que esta debajo',
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ]),
                                ),
                              ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (isConnected)
                                ? Container(
                                    child: ElevatedButton(
                                      style: buttonStyle(
                                          radium: 30.0, color: Colors.green),
                                      child: const Icon(
                                        Icons.done,
                                      ),
                                      onPressed: () {
                                        Navigator.of(mainContext).pop(true);
                                      },
                                    ),
                                  )
                                : Container(
                                    child: ElevatedButton(
                                      style: buttonStyle(
                                          radium: 30.0, color: Colors.grey),
                                      child: const Icon(
                                        Icons.done,
                                      ),
                                      onPressed: () {
                                        snackBarAlert(
                                            text:
                                                'Debe conectarse a una Red WiFi',
                                            context: contextMS,
                                            color: Colors.white);
                                      },
                                    ),
                                  ),
                            Container(
                              child: ElevatedButton(
                                style: buttonStyle(
                                    radium: 30.0, color: Colors.blue),
                                child: const Icon(
                                  Icons.settings,
                                ),
                                onPressed: () async {
                                  try {
                                    await AppSettings.openWIFISettings();
                                  } on Exception catch (e) {
                                    debugPrint(
                                        '??????????????????????? ${e.toString()}');
                                  }
                                  Navigator.of(mainContext).pop(false);
                                },
                              ),
                            ),
                            Container(
                              child: ElevatedButton(
                                style: buttonStyle(
                                    radium: 30.0, color: Colors.red),
                                child: const Icon(
                                  Icons.close,
                                ),
                                onPressed: () =>
                                    Navigator.of(mainContext).pop(false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ) ??
      false;
}

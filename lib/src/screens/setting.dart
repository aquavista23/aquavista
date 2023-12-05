import 'package:flutter/material.dart';
import 'package:aquavista/src/util/style.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: textWithStroke(
              text: 'Ajustes',
              textColor: mainColor,
              strokeColor: logoImageColor),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            buttonSetting('Editar Perfil', Icons.person),
            const SizedBox(
              height: 10.0,
            ),
            buttonSetting('Agregar Dispositivo', Icons.add),
            const SizedBox(
              height: 10.0,
            ),
            buttonSetting('Reestablecer', Icons.restart_alt)
          ],
        ));
  }
}

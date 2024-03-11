// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//colors
// Color mainColor = Colors.lightGreen;
Color mainColor = const Color(0xff012c8f);

// Color clientColor = Color(0xff37A1EE); //Colors.lightBlue[800];
Color logoImageColor = const Color(0xffb0c9ff);

Color visitColor = const Color(0xff369D34);

TextStyle getTitleInfoStyle(Color color) =>
    TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.bold);
TextStyle gettitleStyle(Color color) => TextStyle(fontSize: 14, color: color);
TextStyle getModelNameStyle() =>
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

Widget getTitleFormated(String title) => Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 0, 10),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        softWrap: true,
        textAlign: TextAlign.left,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );

//dateformat
final DateFormat formatDate = DateFormat('dd/MM/yyyy');
final DateFormat formatTime = DateFormat('HH:mm:ss a');
final DateFormat formatlongDate = DateFormat('dd/MM/yyyy').add_jms();
final DateFormat formatDateDb = DateFormat('yyyy-MM-dd');
final DateFormat formatDateSeqDb = DateFormat('yyMMdd');
final DateFormat formatDateAPI = DateFormat('dd/MM/yyyy/hh:mm:ss');
final DateFormat formatDateSync = DateFormat('dd-MM-yyyy hh:mm:ss');
final DateFormat formatDateHome = DateFormat('dd-MM-yy hh:mm:ss');

//numberformat
final NumberFormat formatNumber = NumberFormat('#,###,###,###.##');

String? getNombreCompletoDiaVisita(String diaVisita) {
  switch (diaVisita) {
    case 'LU':
      return 'Lunes';
    case 'MA':
      return 'Martes';
    case 'MI':
      return 'Miércoles';
    case 'JU':
      return 'Jueves';
    case 'VI':
      return 'Viernes';
    case 'SA':
      return 'Sábado';
    case 'DO':
      return 'Domingo';
    default:
      return null;
  }
}

String? getvisitDayAbreviado(String visitDay) {
  switch (visitDay) {
    case 'LUNES':
      return 'LU';
    case 'MARTES':
      return 'MA';
    case 'MIERCOLES':
      return 'MI';
    case 'JUEVES':
      return 'JU';
    case 'VIERNES':
      return 'VI';
    case 'SABADO':
      return 'SA';
    case 'DOMINGO':
      return 'DO';
    default:
      return null;
  }
}

ThemeData calendarTheme(BuildContext context, Color color) {
  assert(context != null);
  final ThemeData theme = Theme.of(context);
  assert(theme != null);
  return theme.copyWith(
      primaryColor: color,
      // brightness: Brightness.light,
      colorScheme: theme.colorScheme.copyWith(primary: color));
}

class CustomTheme extends Theme {
  final ThemeData theme;

  const CustomTheme({Key? key, required Widget child, required this.theme})
      : super(
          key: key,
          child: child,
          data: theme,
        );
}

ButtonStyle buttonStyle({required double radium, Color? color}) {
  return ElevatedButton.styleFrom(
    primary: color ?? mainColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radium),
    ),
  );
}

Widget textWithStroke(
        {required String text,
        required Color textColor,
        required Color strokeColor,
        double? textSize}) =>
    Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: TextStyle(
            fontSize: textSize ?? 20,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = strokeColor,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: TextStyle(
            fontSize: textSize ?? 20,
            color: textColor,
          ),
        ),
      ],
    );

Widget buttonSetting(String text, IconData icon, Function() onPress,
        {double? radium,
        Color? colorText,
        Color? colorStroke,
        Color? colorButton}) =>
    ElevatedButton(
      style: buttonStyle(radium: radium ?? 30.0, color: colorButton),
      onPressed: onPress,
      child: ListTile(
          trailing: Icon(
            icon,
            color: logoImageColor,
          ),
          title: textWithStroke(
              text: text,
              textColor: colorText ?? mainColor,
              strokeColor: colorStroke ?? logoImageColor)),
    );

Widget cardWithPadding(
    {required Widget child, double? sizePad, double? sizeMar, Color? color}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(sizeMar ?? 10),
      color: color,
      child: Padding(padding: EdgeInsets.all(sizePad ?? 15.0), child: child),
    ),
  );
}

Widget textContainer(String text, title) {
  return Container(
    height: 45.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: mainColor, blurRadius: 1, spreadRadius: 0),
        const BoxShadow(color: Colors.white, blurRadius: 10, spreadRadius: 5),
      ],
    ),
    child: Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(color: mainColor.withOpacity(0.7)),
        ),
        const Divider(
          height: 3.0,
        ),
        Center(
          child: Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(
                color: mainColor, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

Widget containerWithList(
    {required BuildContext context,
    required List<Widget> childrens,
    required String tittle}) {
  List<Widget> children = [
    Text(
      tittle,
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
    ),
    const SizedBox(
      height: 35,
    ),
  ];
  children.addAll(childrens);
  return Container(
    padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
    child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ListView(
        children: children,
      ),
    ),
  );
}

Widget rowOfButtons(
    {required BuildContext context,
    required Function() onPressed,
    Color? colorSave}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        style: buttonStyle(radium: 15, color: Colors.red),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Cancelar",
            style: TextStyle(
                fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
      ),
      ElevatedButton(
        style: buttonStyle(radium: 15, color: colorSave),
        onPressed: onPressed,
        child: const Text(
          "Guardar",
          style:
              TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.white),
        ),
      )
    ],
  );
}

Widget aspecWithPadding({required Widget child}) => AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
          padding: const EdgeInsets.only(
            right: 15,
            left: 10,
            top: 10,
            bottom: 10,
          ),
          child: child),
    );

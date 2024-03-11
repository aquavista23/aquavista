import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> mapDateOrder(List<Map<String, dynamic>>? maps) {
  maps!.sort((a, b) {
    return DateTime.parse(a["fecha"]).compareTo(DateTime.parse(b["fecha"]));
  });
  return maps;
}

Future<DateTime?> daySelectedCalendar({
  required BuildContext context,
  required DateTime daySelected,
}) async =>
    await showDatePicker(
        context: context,
        initialDate: daySelected,
        firstDate: DateTime(DateTime.now().year - 3),
        lastDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
        initialDatePickerMode: DatePickerMode.day) ??
    daySelected;

DateTime convertDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: Colors.white,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = '0';
      break;
    case 1:
      text = '10';
      break;
    case 2:
      text = '20';
      break;
    case 3:
      text = '30';
      break;
    case 4:
      text = '40';
      break;
    case 5:
      text = '50';
      break;
    case 6:
      text = '60';
      break;
    case 7:
      text = '70';
      break;
    case 8:
      text = '80';
      break;
    case 9:
      text = '90';
      break;
    case 10:
      text = '100';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.center);
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: Colors.white,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('0', style: style);
      break;
    case 1:
      text = const Text('2', style: style);
      break;
    case 2:
      text = const Text('4', style: style);
      break;
    case 3:
      text = const Text('6', style: style);
      break;
    case 4:
      text = const Text('8', style: style);
      break;
    case 5:
      text = const Text('10', style: style);
      break;
    case 6:
      text = const Text('12', style: style);
      break;
    case 7:
      text = const Text('14', style: style);
      break;
    case 8:
      text = const Text('16', style: style);
      break;
    case 9:
      text = const Text('18', style: style);
      break;
    case 10:
      text = const Text('20', style: style);
      break;
    case 11:
      text = const Text('22', style: style);
      break;
    case 12:
      text = const Text('24', style: style);
      break;
    default:
      text = const Text('');
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 10,
    child: text,
  );
}

String doubleToTime(double time) {
  double realTime = time * 2;
  int hour = realTime.floor();
  int minutes = ((realTime - hour) * 60).round();
  return '${(hour < 10) ? "0$hour" : hour}:${(minutes < 10) ? "0$minutes" : minutes}';
}

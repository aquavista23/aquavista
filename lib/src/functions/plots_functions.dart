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

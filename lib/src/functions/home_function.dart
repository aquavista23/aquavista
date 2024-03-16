import 'package:aquavista/src/functions/plots_functions.dart';
import 'package:aquavista/src/models/medition_model.dart';
import 'package:flutter/material.dart';

MeditionData? lastMedition(List<MeditionData> meditionList) {
  MeditionData? result;
  if (meditionList.isNotEmpty) {
    DateTime date = convertDate(meditionList[0].fecha!);
    result = meditionList[0];
    for (var i = 0; i < meditionList.length; i++) {
      if (meditionList[i].fecha!.isAfter(date)) {
        result = meditionList[i];
      }
    }
  }
  return result;
}

Card emptyCard(Color mainColor) => Card(
      color: mainColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      clipBehavior: Clip.antiAlias,
      // margin: const EdgeInsets.all(5),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(''),
                  Text(''),
                ],
              ),
              const Text('No hay Datos', style: TextStyle(color: Colors.white)),
              const Text('')
            ],
          )),
    );

Text cardText(String text, double size, {Color? color}) {
  return Text(
    text,
    style: TextStyle(color: color ?? Colors.white, fontSize: size),
  );
}

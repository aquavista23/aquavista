import 'package:aquavista/src/functions/plots_functions.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/util/constantes.dart';
import 'package:aquavista/src/models/medition_model.dart';

class PlotsScreen extends StatefulWidget {
  const PlotsScreen({Key? key}) : super(key: key);

  @override
  State<PlotsScreen> createState() => _PlotsScreenState();
}

class _PlotsScreenState extends State<PlotsScreen> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(DATABASE);
  List<MeditionData> meditionList = [];
  List<MeditionData> meditionShow = [];
  bool isShowingMainData = false;
  DateTime filterDay = DateTime.now();
  DateTime dayFilter = DateTime.now();

  @override
  void initState() {
    retrieveMeditionData(dayFilter);
    isShowingMainData = true;
    super.initState();
  }

  void retrieveMeditionData(DateTime dia) {
    List<MeditionData> auxMeditionShow = [];

    dbRef.orderByChild("id").equalTo("2").onValue.listen((data) {
      DataSnapshot dataSnapshot = data.snapshot;
      Map<dynamic, dynamic> values = dataSnapshot.value as Map;
      values.forEach((key, values) {
        meditionList.add(MeditionData.fromJson(values));
      });

      for (var i = 0; i < meditionList.length; i++) {
        if (convertDate(meditionList[i].fecha!).difference(dia).inDays == 0) {
          auxMeditionShow.add(meditionList[i]);
        }
      }
      auxMeditionShow.sort((a, b) {
        return a.fecha!.compareTo(b.fecha!);
      });
      setState(() {
        meditionShow = auxMeditionShow;
        filterDay = dia;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('Estadisticas'),
          actions: [
            Theme(
              data: calendarTheme(context, mainColor),
              child: Builder(builder: (contextTM) {
                return IconButton(
                    icon: const Icon(Icons.calendar_today_rounded),
                    color: (filterDay.year == DateTime.now().year &&
                            filterDay.month == DateTime.now().month &&
                            filterDay.day == DateTime.now().day)
                        ? Colors.white
                        : Colors.red[900],
                    onPressed: () async {
                      dayFilter = await daySelectedCalendar(
                              context: contextTM, daySelected: filterDay) ??
                          DateTime.now();
                      retrieveMeditionData(dayFilter);
                    });
              }),
            )
          ],
        ),
        body: Builder(builder: (context) {
          return AspectRatio(
            aspectRatio: 1.20,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: SizedBox(
                height: 450,
                child: (isShowingMainData)
                    ? LineChart(
                        sampleData2,
                        swapAnimationDuration:
                            const Duration(milliseconds: 250),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          backgroundColor: mainColor,
                        ),
                      ),
              ),
            ),
          );
        }));
  }

  LineChartData get sampleData2 => LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey,
              strokeWidth: 1,
            );
          },
        ),
        lineTouchData: LineTouchData(enabled: false),
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: [lineChartBarData2_3, lineChartBarData2_4],
        minX: 0,
        maxX: 12,
        maxY: 10,
        minY: 0,
      );

  // LineTouchData get lineTouchData2 => LineTouchData(
  //       enabled: false,
  //     );

  FlTitlesData get titlesData2 => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        // bottomTitles: AxisTitles(
        //   sideTitles: bottomTitles,
        // ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        // leftTitles: AxisTitles(
        //   sideTitles: leftTitles(),
        // ),
      );

  // List<LineChartBarData> get lineBarsData2 => [
  //       lineChartBarData2_1,
  //       lineChartBarData2_2,
  //       lineChartBarData2_3
  //     ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Tbd';
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

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Hr', style: style);
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

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  // LineChartBarData get lineChartBarData1_2 => LineChartBarData(
  //       isCurved: true,
  //       color: Colors.pink,
  //       barWidth: 8,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(show: false),
  //       belowBarData: BarAreaData(
  //         show: false,
  //         color: Colors.pink.withOpacity(0),
  //       ),
  //       spots: const [
  //         FlSpot(1, 1),
  //         FlSpot(3, 2.8),
  //         FlSpot(7, 1.2),
  //         FlSpot(10, 2.8),
  //         FlSpot(12, 2.6),
  //         FlSpot(13, 3.9),
  //       ],
  //     );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: Colors.cyan,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(9, 1.3),
          FlSpot(11.5, 2.5),
        ],
      );

  // LineChartBarData get lineChartBarData2_1 => LineChartBarData(
  //       isCurved: true,
  //       curveSmoothness: 0,
  //       color: Colors.green.withOpacity(0.5),
  //       barWidth: 4,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(show: false),
  //       belowBarData: BarAreaData(show: false),
  //       spots: const [
  //         FlSpot(1, 1),
  //         FlSpot(3, 4),
  //         FlSpot(5, 1.8),
  //         FlSpot(7, 5),
  //         FlSpot(10, 2),
  //         FlSpot(12, 2.2),
  //         FlSpot(13, 1.8),
  //       ],
  //     );

  // LineChartBarData get lineChartBarData2_2 => LineChartBarData(
  //       isCurved: true,
  //       color: Colors.pink.withOpacity(0.5),
  //       barWidth: 4,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(show: false),
  //       belowBarData: BarAreaData(
  //         show: true,
  //         color: Colors.pink.withOpacity(0.2),
  //       ),
  //       spots: const [
  //         FlSpot(1, 1),
  //         FlSpot(3, 2.8),
  //         FlSpot(7, 1.2),
  //         FlSpot(10, 2.8),
  //         FlSpot(12, 2.6),
  //         FlSpot(13, 3.9),
  //       ],
  //     );

  LineChartBarData get lineChartBarData2_4 {
    List<FlSpot>? spots = [];

    for (var i = 0; i < meditionShow.length; i++) {
      if (meditionShow[i].flow != null && meditionShow[i].fecha != null) {
        DateTime fecha = meditionShow[i].fecha!;
        double flow = meditionShow[i].flow!;

        spots.add(FlSpot(
          double.parse(
              ((fecha.hour.toDouble() + (fecha.minute.toDouble() / 60)) / 2)
                  .toString()),
          flow / 10,
        ));
      }
    }

    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: Colors.green.withOpacity(0.5),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }

  LineChartBarData get lineChartBarData2_3 {
    List<FlSpot>? spots = [];

    for (var i = 0; i < meditionShow.length; i++) {
      if (meditionShow[i].turbidity != null && meditionShow[i].fecha != null) {
        DateTime fecha = meditionShow[i].fecha!;
        double turbidity = meditionShow[i].turbidity!;

        spots.add(FlSpot(
          double.parse(
              ((fecha.hour.toDouble() + (fecha.minute.toDouble() / 60)) / 2)
                  .toString()),
          turbidity / 10,
        ));
      }
    }

    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0,
      color: Colors.cyan.withOpacity(0.5),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }
}

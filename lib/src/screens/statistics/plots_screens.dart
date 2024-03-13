import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/util/constantes.dart';
import 'package:aquavista/src/models/user_model.dart';
import 'package:aquavista/src/models/medition_model.dart';
import 'package:aquavista/src/functions/plots_functions.dart';

class PlotsScreen extends StatefulWidget {
  final UserData? userShared;
  const PlotsScreen({Key? key, this.userShared}) : super(key: key);

  @override
  State<PlotsScreen> createState() => _PlotsScreenState();
}

class _PlotsScreenState extends State<PlotsScreen> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(DATABASE);
  User? currentUser = FirebaseAuth.instance.currentUser;
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

    dbRef
        .orderByChild("id")
        .equalTo(widget.userShared?.uID ?? currentUser!.uid)
        .onValue
        .listen((data) {
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
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(widget.userShared?.nombre ?? 'Estadisticas'),
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
                      debugPrint(currentUser!.uid);
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
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                // const Text('Turbidad'),
                cardWithPadding(
                  sizePad: 3,
                  sizeMar: 3,
                  color: mainColor.withOpacity(0.8),
                  child: aspecWithPadding(
                    child: SizedBox(
                      height: 400,
                      child: (isShowingMainData)
                          ? LineChart(
                              graphicData(0, filterDay),
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
                ),
                const Divider(
                  height: 5,
                ),
                // const Text('Flujo'),
                cardWithPadding(
                  sizePad: 3,
                  sizeMar: 3,
                  color: mainColor.withOpacity(0.8),
                  child: aspecWithPadding(
                    child: SizedBox(
                      height: 500,
                      child: (isShowingMainData)
                          ? LineChart(
                              graphicData(1, filterDay),
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
                ),
              ],
            ),
          );
        }));
  }

  LineChartData graphicData(int id, DateTime filterDay) => LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white10,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.white10,
              strokeWidth: 1,
            );
          },
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (value) {
              return value
                  .map((e) => LineTooltipItem(
                      "${(e.y * 10).toStringAsFixed(2)} \n ${doubleToTime(e.x)}",
                      TextStyle(color: mainColor)))
                  .toList();
            },
            tooltipBgColor: Colors.grey.withOpacity(0.8),
          ),
          touchCallback: ((p0, p1) {
            if (p1 != null) {
              debugPrint('?????????????????? ${p1.lineBarSpots![0].x}');
            }
            // if (p0 != null) {
            //   print('>>>>>>>>>>>>>>>> ${p0.}');
            // }
          }),
        ),
        titlesData: titlesData2(
            (id == 0) ? '{%} Turbidad' : '{%} Flujo',
            (id == 0)
                ? 'Turbidad a la fecha ${formatDate.format(filterDay)}'
                : 'Flujo  a la fecha ${formatDate.format(filterDay)}'),
        borderData: borderData,
        lineBarsData: (id == 0) ? [lineChartBarData2_3] : [lineChartBarData2_4],
        // showingTooltipIndicators: ,
        minX: 0,
        maxX: 12,
        maxY: 10,
        minY: 0,
      );

  // LineTouchData get lineTouchData2 => LineTouchData(
  //       enabled: false,
  //     );

  FlTitlesData titlesData2(String titleData, String titleHeader) =>
      FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          axisNameWidget: const Text(
            'Horas',
            style: TextStyle(color: Colors.white),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Text(
            titleData,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
            interval: 1,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
            axisNameWidget: Text(
              titleHeader,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            )),
      );

  // List<LineChartBarData> get lineBarsData2 => [
  //       lineChartBarData2_1,
  //       lineChartBarData2_2,
  //       lineChartBarData2_3
  //     ];

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border.all(color: Colors.white),
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

  // LineChartBarData get lineChartBarData1_3 => LineChartBarData(
  //       isCurved: true,
  //       color: Colors.cyan,
  //       barWidth: 8,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(show: false),
  //       belowBarData: BarAreaData(show: false),
  //       spots: const [
  //         FlSpot(1, 2.8),
  //         FlSpot(3, 1.9),
  //         FlSpot(6, 3),
  //         FlSpot(9, 1.3),
  //         FlSpot(11.5, 2.5),
  //       ],
  //     );

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
      color: Colors.green.withOpacity(0.8),
      barWidth: 5,
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
      curveSmoothness: 0.1,
      color: Colors.cyan.withOpacity(0.8),
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }
}

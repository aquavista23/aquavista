import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/models/medition_model.dart';

class PlotsScreen extends StatefulWidget {
  const PlotsScreen({Key? key}) : super(key: key);

  @override
  State<PlotsScreen> createState() => _PlotsScreenState();
}

class _PlotsScreenState extends State<PlotsScreen> {
  // DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("turbi");
  // List<MeditionData> meditionList = [];
  // List<MeditionData> meditionShow = [];
  // final bool isShowingMainData;

  // @override
  // void initState() {
  //   super.initState();

  //   retrieveStudentData();
  // }

  // void retrieveStudentData() {
  //   dbRef.orderByChild("id").equalTo("2").onValue.listen((data) {
  //     DataSnapshot dataSnapshot = data.snapshot;
  //     Map<dynamic, dynamic> values = dataSnapshot.value as Map;
  //     values.forEach((key, values) {
  //       meditionList.add(MeditionData.fromJson(values));
  //     });
  //     for (var i = 0; i < meditionList.length; i++) {
  //       DateTime auxDate = DateTime(meditionList[i].fecha!.year,
  //           meditionList[i].fecha!.month, meditionList[i].fecha!.day);
  //       if (meditionList[i].fecha!.difference(DateTime.now()).inDays == 0) {
  //         meditionShow.add(meditionList[i]);
  //       }
  //     }

  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('Estadisticas'),
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.exit_to_app),
          //     onPressed: () async {
          //       Navigator.of(context).pop(false);
          //     },
          //   )
          // ],
        ),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 5.0),
            child: SizedBox(
              height: 450,
              child: LineChart(
                sampleData2,
                swapAnimationDuration: const Duration(milliseconds: 250),
              ),
            ),
          );
        }));
  }

  LineChartData get sampleData2 => LineChartData(
        gridData: FlGridData(show: false),
        lineTouchData: LineTouchData(enabled: false),
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: [lineChartBarData2_3],
        minX: 0,
        maxX: 12,
        maxY: 10,
        minY: 0,
      );

  // LineTouchData get lineTouchData2 => LineTouchData(
  //       enabled: false,
  //     );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
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
        text = const Text('12', style: style);
        break;
      case 2:
        text = const Text('2', style: style);
        break;
      case 4:
        text = const Text('4', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 8:
        text = const Text('8', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 14:
        text = const Text('14', style: style);
        break;
      case 16:
        text = const Text('16', style: style);
        break;
      case 18:
        text = const Text('18', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 22:
        text = const Text('22', style: style);
        break;
      case 24:
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
        border: Border(
          bottom: BorderSide(color: mainColor.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  // LineChartBarData get lineChartBarData1_1 => LineChartBarData(
  //       isCurved: true,
  //       color: Colors.green,
  //       barWidth: 8,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(show: false),
  //       belowBarData: BarAreaData(show: false),
  //       spots: const [
  //         FlSpot(1, 1),
  //         FlSpot(3, 1.5),
  //         FlSpot(5, 1.4),
  //         FlSpot(7, 3.4),
  //         FlSpot(10, 2),
  //         FlSpot(12, 2.2),
  //         FlSpot(13, 1.8),
  //       ],
  //     );

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

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.cyan.withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3.6),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(9, 3.3),
          FlSpot(11.4, 4.5),
        ],
      );
}

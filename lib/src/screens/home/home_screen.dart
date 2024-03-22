// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:aquavista/src/functions/plots_functions.dart';
import 'package:aquavista/src/util/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/util/dialogs.dart';
import 'package:aquavista/src/widgets/drawer.dart';
import 'package:aquavista/src/util/constantes.dart';
import 'package:aquavista/src/util/show_dialog.dart';
import 'package:aquavista/src/models/medition_model.dart';
import 'package:aquavista/src/functions/home_function.dart';
import 'package:aquavista/src/functions/setting_functions.dart';
import 'package:aquavista/src/screens/options/wifi_setting.dart';
import 'package:aquavista/src/screens/statistics/plots_screens.dart';
import 'package:aquavista/src/bloc/authentication_bloc/bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseDatabase ref = FirebaseDatabase.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  MeditionData? meditionShow;
  void retrieveMeditionData(DateTime dia) {
    List<MeditionData> auxMeditionShow = [];

    try {
      ref
          .ref()
          .child(DATABASE)
          .orderByChild("id")
          .equalTo(currentUser!.uid)
          .onValue
          .listen((data) {
        List<MeditionData> meditionList = [];
        DataSnapshot dataSnapshot = data.snapshot;
        if (dataSnapshot.exists) {
          Map<dynamic, dynamic> values = dataSnapshot.value as Map;
          values.forEach((key, values) {
            meditionList.add(MeditionData.fromJson(values));
          });

          for (var i = 0; i < meditionList.length; i++) {
            if (convertDate(meditionList[i].fecha!).difference(dia).inDays ==
                0) {
              auxMeditionShow.add(meditionList[i]);
            }
          }
          auxMeditionShow.sort((a, b) {
            return a.fecha!.compareTo(b.fecha!);
          });
        }
        setState(() {
          meditionShow = lastMedition(auxMeditionShow);
        });
      });
    } on Exception catch (e) {
      snackBarAlert(text: e.toString(), context: context, color: Colors.amber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Aquavista'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              if (await showGenDialog(
                  context: context,
                  text: '¿Esta seguro que desea Cerrar Sesión?')) {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: Builder(builder: (context) {
            if (meditionShow == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (meditionShow != null) {
              return Column(
                children: [
                  Builder(builder: (context) {
                    List<MeditionData> meditionList = [];

                    if (meditionShow?.turbidity != null) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Container(
                                width: 60,
                                height: 50,
                                decoration: const BoxDecoration(
                                    // border: Border.all(
                                    //     width: 4,
                                    //     color: Theme.of(context)
                                    //         .scaffoldBackgroundColor),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //       spreadRadius: 2,
                                    //       blurRadius: 10,
                                    //       color:
                                    //           Colors.black.withOpacity(0.1),
                                    //       offset: const Offset(0, 10))
                                    // ],
                                    // shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'assets/LOGO.png',
                                        ))),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PlotsScreen()),
                              );
                            },
                            child: CircularPercentIndicator(
                              radius: 100.0,
                              lineWidth: 10.0,
                              percent:
                                  ((meditionShow!.turbidity ?? 0.0) / 2000),
                              linearGradient: const LinearGradient(colors: [
                                Color(0xFFACC3F2),
                                Color(0xFF044BD9)
                              ], begin: Alignment.centerLeft),
                              rotateLinearGradient: true,
                              animateFromLastPercent: true,
                              backgroundColor:
                                  const Color.fromARGB(255, 59, 58, 58),
                              center: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(meditionShow!.turbidity ?? 0.0 / 2000).toString()}%',
                                      style: TextStyle(
                                          color: mainColor, fontSize: 35),
                                    ),
                                    Text(
                                      'Turbidez',
                                      style: TextStyle(
                                          color: mainColor, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              // progressColor: const Color(0xffACC3F2),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      );
                    } else {
                      return Container();
                      // emptyCard(mainColor);
                    }
                  }),
                  Builder(builder: (context) {
                    if (meditionShow?.turbidity != null) {
                      return Card(
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
                                  children: [
                                    cardText(
                                        (meditionShow?.fecha != null)
                                            ? 'Ult. Registro Turbidad'
                                            : '',
                                        12),
                                    cardText(
                                        (meditionShow?.fecha != null)
                                            ? formatDateHome
                                                .format(meditionShow!.fecha!)
                                            : '',
                                        12,
                                        color: Colors.white.withOpacity(0.7))
                                  ],
                                ),
                                cardText(
                                    (meditionShow?.turbidity ?? 0.0 / 2000)
                                        .toString(),
                                    18,
                                    color: ((meditionShow?.turbidity ??
                                                0.0 / 2000) <
                                            55)
                                        ? Colors.green
                                        : Colors.red)
                              ],
                            )),
                      );
                    } else {
                      return Container();
                      // return emptyCard(mainColor);
                    }
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  Builder(builder: (context) {
                    if (meditionShow?.flow != null) {
                      return Card(
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
                                  children: [
                                    cardText(
                                        (meditionShow?.fecha != null)
                                            ? 'Ult. Registro Flujo'
                                            : '',
                                        12),
                                    cardText(
                                        (meditionShow?.fecha != null)
                                            ? formatDateHome
                                                .format(meditionShow!.fecha!)
                                            : '',
                                        12,
                                        color: Colors.white.withOpacity(0.7))
                                  ],
                                ),
                                cardText(
                                    (meditionShow?.flow ?? 0.0 / 4000)
                                        .toString(),
                                    18.0,
                                    color:
                                        ((meditionShow?.flow ?? 0.0 / 4000) <=
                                                40)
                                            ? Colors.red
                                            : Colors.green)
                              ],
                            )),
                      );
                    } else {
                      return Container();
                      // return emptyCard(mainColor);
                    }
                  }),
                ],
              );
            } else {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Center(
                    child: Image.asset("assets/LOGO.png"),
                  ));
            }
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final connect = Connectivity();
          late ConnectivityResult result;
          String ssid = '';
          String bssid = '';
          int signal = -100;
          // Platform messages may fail, so we use a try/catch PlatformException.
          try {
            result = await connect.checkConnectivity();
            // snackBarAlert(
            //     context: context, text: result.name, color: mainColor);
          } on PlatformException catch (e) {
            debugPrint('Couldn\'t check connectivity status ${e.toString()}');
            return;
          }
          if (await isConnected()) {
            ssid = await getWifiName() ?? '';
            bssid = await getWifiBSSID() ?? '';
            signal = await getWifiSignalLevel() ?? -100;

            if (await confirmWifi(
                context, 'Confirmar', ssid, bssid, signal, true)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WifiPage(ssid: ssid, bssid: bssid)),
              );
            }
          } else {
            await confirmWifi(context, 'Advertencia', '', '', 0, false);
          }
        },
        backgroundColor: mainColor,
        child: const Icon(
          Icons.add_circle_outline_sharp,
        ),
      ),
    );
  }
}

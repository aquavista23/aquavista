import 'package:aquavista/src/screens/statistics/plots_screens.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/widgets/drawer.dart';
import 'package:aquavista/src/util/constantes.dart';
import 'package:aquavista/src/util/show_dialog.dart';
import 'package:aquavista/src/models/medition_model.dart';
import 'package:aquavista/src/functions/home_function.dart';
import 'package:aquavista/src/bloc/authentication_bloc/bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseDatabase ref = FirebaseDatabase.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
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
          child: StreamBuilder<DatabaseEvent>(
              stream: ref.ref(DATABASE).orderByChild("id").equalTo("2").onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    Builder(builder: (context) {
                      List<MeditionData> meditionList = [];

                      if (snapshot.data?.snapshot.value != null) {
                        Map<dynamic, dynamic> values =
                            snapshot.data!.snapshot.value as Map;
                        values.forEach((key, values) {
                          meditionList.add(MeditionData.fromJson(values));
                        });

                        MeditionData? lastRegister = lastMedition(meditionList);
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
                                      builder: (context) =>
                                          const PlotsScreen()),
                                );
                              },
                              child: CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 10.0,
                                percent:
                                    ((lastRegister!.turbidity ?? 0.0) / 100),
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
                                        '${lastRegister.turbidity!}%',
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
                        return emptyCard(mainColor);
                      }
                    }),
                    Builder(builder: (context) {
                      List<MeditionData> meditionList = [];

                      if (snapshot.data?.snapshot.value != null) {
                        Map<dynamic, dynamic> values =
                            snapshot.data!.snapshot.value as Map;
                        values.forEach((key, values) {
                          meditionList.add(MeditionData.fromJson(values));
                        });

                        MeditionData? lastRegister = lastMedition(meditionList);
                        return Card(
                          color: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          // margin: const EdgeInsets.all(5),
                          child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      cardText(
                                          (lastRegister?.fecha != null)
                                              ? 'Ult. Registro Turbidad'
                                              : '',
                                          12),
                                      cardText(
                                          (lastRegister?.fecha != null)
                                              ? formatDateHome
                                                  .format(lastRegister!.fecha!)
                                              : '',
                                          12,
                                          color: Colors.white.withOpacity(0.7))
                                    ],
                                  ),
                                  cardText(
                                      lastRegister?.turbidity.toString() ??
                                          'no Data',
                                      18,
                                      color: (lastRegister!.flow! >= 45)
                                          ? Colors.green
                                          : Colors.red)
                                ],
                              )),
                        );
                      } else {
                        return emptyCard(mainColor);
                      }
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Builder(builder: (context) {
                      List<MeditionData> meditionList = [];
                      if (snapshot.data?.snapshot.value != null) {
                        Map<dynamic, dynamic> values =
                            snapshot.data!.snapshot.value as Map;
                        values.forEach((key, values) {
                          meditionList.add(MeditionData.fromJson(values));
                        });

                        MeditionData? lastRegister = lastMedition(meditionList);
                        return Card(
                          color: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          // margin: const EdgeInsets.all(5),
                          child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      cardText(
                                          (lastRegister?.fecha != null)
                                              ? 'Ult. Registro Flujo'
                                              : '',
                                          12),
                                      cardText(
                                          (lastRegister?.fecha != null)
                                              ? formatDateHome
                                                  .format(lastRegister!.fecha!)
                                              : '',
                                          12,
                                          color: Colors.white.withOpacity(0.7))
                                    ],
                                  ),
                                  cardText(
                                      lastRegister?.flow.toString() ??
                                          'no Data',
                                      18.0,
                                      color: (lastRegister!.flow! >= 45)
                                          ? Colors.green
                                          : Colors.red)
                                ],
                              )),
                        );
                      } else {
                        return emptyCard(mainColor);
                      }
                    }),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:aquavista/src/screens/home/home_screen.dart';
// import 'package:aquavista/src/bloc/simple_bloc_delegate.dart';
// import 'package:aquavista/src/repository/user_repository.dart';
// import 'package:aquavista/src/screens/login/login_screen.dart';
// import 'package:aquavista/src/bloc/authentication_bloc/bloc.dart';

// // final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
// //     BehaviorSubject<ReceivedNotification>();

// // final BehaviorSubject<String> selectNotificationSubject =
// //     BehaviorSubject<String>();

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//   // final NotificationManagerState _notificationManagerState =
//   //     NotificationManagerState();

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: Center(
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: Image.asset(
//                     'assets/LOGO_small.png',
//                     height: 200,
//                     width: 200,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 FutureBuilder(
//                     future: getMainscreen(context),
//                     builder:
//                         (BuildContext context, AsyncSnapshot<void> snapshot) {
//                       return const CircularProgressIndicator();
//                     })
//               ]),
//         ),
//       );

//   /////////////////////////////////////////////////////////////////////////
//   ///NOMBRE ORIGINAL: initNotification
//   ///TIPO: Function
//   ///MODO: Async
//   ///DETALLE: Preparacion de las Notificaciones
//   /////////////////////////////////////////////////////////////////////////
//   // Future<void> initNotification() async {
//   //   WidgetsFlutterBinding.ensureInitialized();

//   //   await configureLocalTimeZone();

//   //   // final NotificationAppLaunchDetails notificationAppLaunchDetails =
//   //   //   await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

//   //   const AndroidInitializationSettings initializationSettingsAndroid =
//   //       AndroidInitializationSettings('@mipmap/ic_launcher');

//   //   final List<DarwinNotificationCategory> darwinNotificationCategories =
//   //       <DarwinNotificationCategory>[
//   //     DarwinNotificationCategory(
//   //       darwinNotificationCategoryText,
//   //       actions: <DarwinNotificationAction>[
//   //         DarwinNotificationAction.text(
//   //           'text_1',
//   //           'Action 1',
//   //           buttonTitle: 'Send',
//   //           placeholder: 'Placeholder',
//   //         ),
//   //       ],
//   //     ),
//   //     DarwinNotificationCategory(
//   //       darwinNotificationCategoryPlain,
//   //       actions: <DarwinNotificationAction>[
//   //         DarwinNotificationAction.plain('id_1', 'Action 1'),
//   //         DarwinNotificationAction.plain(
//   //           'id_2',
//   //           'Action 2 (destructive)',
//   //           options: <DarwinNotificationActionOption>{
//   //             DarwinNotificationActionOption.destructive,
//   //           },
//   //         ),
//   //         DarwinNotificationAction.plain(
//   //           navigationActionId,
//   //           'Action 3 (foreground)',
//   //           options: <DarwinNotificationActionOption>{
//   //             DarwinNotificationActionOption.foreground,
//   //           },
//   //         ),
//   //         DarwinNotificationAction.plain(
//   //           'id_4',
//   //           'Action 4 (auth required)',
//   //           options: <DarwinNotificationActionOption>{
//   //             DarwinNotificationActionOption.authenticationRequired,
//   //           },
//   //         ),
//   //       ],
//   //       options: <DarwinNotificationCategoryOption>{
//   //         DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
//   //       },
//   //     )
//   //   ];

//   //   final DarwinInitializationSettings initializationSettingsDarwin =
//   //       DarwinInitializationSettings(
//   //     requestAlertPermission: false,
//   //     requestBadgePermission: false,
//   //     requestSoundPermission: false,
//   //     onDidReceiveLocalNotification:
//   //         (int id, String title, String body, String payload) async {
//   //       didReceiveLocalNotificationStream.add(
//   //         ReceivedNotification(
//   //           id: id,
//   //           title: title,
//   //           body: body,
//   //           payload: payload,
//   //         ),
//   //       );
//   //     },
//   //     notificationCategories: darwinNotificationCategories,
//   //   );
//   //   final InitializationSettings initializationSettings =
//   //       InitializationSettings(
//   //     android: initializationSettingsAndroid,
//   //     iOS: initializationSettingsDarwin,
//   //     macOS: initializationSettingsDarwin,
//   //   );

//   //   await flutterLocalNotificationsPlugin.initialize(
//   //     initializationSettings,
//   //     onDidReceiveNotificationResponse:
//   //         (NotificationResponse notificationResponse) {
//   //       switch (notificationResponse.notificationResponseType) {
//   //         case NotificationResponseType.selectedNotification:
//   //           selectNotificationStream.add(notificationResponse.payload);
//   //           break;
//   //         case NotificationResponseType.selectedNotificationAction:
//   //           if (notificationResponse.actionId == navigationActionId) {
//   //             selectNotificationStream.add(notificationResponse.payload);
//   //           }
//   //           break;
//   //       }
//   //     },
//   //     onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//   //   );
//   // }
//   /*===============================|initNotification|=====================================*/

//   /////////////////////////////////////////////////////////////////////////
//   ///NOMBRE ORIGINAL: configNotification
//   ///TIPO: Function
//   ///MODO: Sync
//   ///DETALLE: Configuracion de las notificaciones
//   /////////////////////////////////////////////////////////////////////////
//   // void configNotification(BuildContext context) {
//   //   _notificationManagerState.requestPermissions();
//   //   _notificationManagerState.configureDidReceiveLocalNotificationSubject(
//   //       context, didReceiveLocalNotificationSubject);
//   //   _notificationManagerState
//   //       .configureSelectNotificationSubject(selectNotificationSubject);
//   // }
//   /*===============================|configNotification|=====================================*/

//   // Widget getscreen(BuildContext mainContext) {
//   //   return FutureBuilder(
//   //       future: dbInstance.init(),
//   //       builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//   //         if (!snapshot.hasData) {
//   //           return CircularProgressIndicator();
//   //         }
//   //         return FutureBuilder(
//   //             future: getMainscreen(mainContext),
//   //             builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//   //               return CircularProgressIndicator();
//   //             });
//   //       });
//   // }

//   // void initMyLibrary() {
//   //   // LicenseRegistry.reset();
//   //   LicenseRegistry.addLicense(() async* {
//   //     yield LicenseEntryWithLineBreaks(<String>['T-POS'], '''
//   //     La descripción General va aquí''');
//   //   });
//   // }

//   Future<void> getMainscreen(BuildContext mainContext) async {
//     // initMyLibrary();
//     // await initNotification();
//     // configNotification(mainContext);
//     // await _notificationManagerState.showIndeterminateProgressNotification(
//     //     'Iniciando la aplicación', "");
//     print('>>>>>>>>>>>>>>>>>> 1');
//     await Firebase.initializeApp();
//     print('>>>>>>>>>>>>>>>>>> 2');
//     Bloc.observer = SimpleBlocDelegate();
//     print('>>>>>>>>>>>>>>>>>> 3');
//     final UserRepository vUserRepository = UserRepository();
//     print('>>>>>>>>>>>>>>>>>> 4');

//     BlocProvider(
//         create: (context) =>
//             AuthenticationBloc(userRepository: vUserRepository)
//               ..add(AppStarted()),
//         child: MaterialApp(
//           theme: ThemeData(primaryColor: Colors.white),
//           home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//             builder: (context, state) {
//               print('>>>>>>>>>>>>>>>>>> $state');
//               if (state is Uninitialized) {
//                 return Center(
//                   child: Image.asset(
//                     'assets/LOGO_small.png',
//                     height: 200,
//                     width: 200,
//                   ),
//                 );
//               }
//               if (state is Authenticated) {
//                 // await _notificationManagerState.showOngoingNotification(
//                 //     'Bienvenido ${user.userName}', 'La sesión se inicio correctamente');
//                 Navigator.pushReplacement(mainContext,
//                     MaterialPageRoute(builder: (context) {
//                   return const HomeScreen();
//                 }));
//               }
//               if (state is Unauthenticated) {
//                 // await _notificationManagerState.showOngoingNotification(
//                 //     'Debe iniciar Sesión', '¿Tiene Problemas? Comuniquese con Soporte.');
//                 Navigator.pushReplacement(mainContext,
//                     MaterialPageRoute(builder: (context) {
//                   return LoginScreen(userRepository: vUserRepository);
//                 }));
//               }
//               return Container();
//             },
//           ),
//         ));
//     print('>>>>>>>>>>>>>>>>>> 6');
//   }
// }

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/LOGO_small.png',
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}

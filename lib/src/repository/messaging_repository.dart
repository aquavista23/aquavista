// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingRepository {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'high important',
    description: 'important notification',
    importance: Importance.defaultImportance,
  );

  final _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    // navigatorKey.currentState?.pushNamed(
    //   '/screens/home/home_screen.dart',
    //   arguments: message,
    // );
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    debugPrint('TOKEN: $token');
    initPushNotifications();
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    Future initLocalNotifications() async {
      const android = AndroidInitializationSettings('@drawable/ic_launcher');
      const setting = InitializationSettings(android: android);

      await _localNotification.initialize(setting,
          onDidReceiveNotificationResponse: (payload) {
        final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
        handleMessage(message);
      });

      final platform = _localNotification.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await platform?.createNotificationChannel((_androidChannel));
    }

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification == null) return;

      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
      await Firebase.initializeApp();

      User? currentUser = FirebaseAuth.instance.currentUser;
      CollectionReference userColection =
          FirebaseFirestore.instance.collection('usuarios');

      await Firebase.initializeApp();

      await userColection
          .doc(currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          List<String> listID = [];
          List<String> listToken = [];
          // Map<String, bool> auxSharedWith = sharedWith;
          // List? auxValues = values;
          try {
            Map shared = documentSnapshot.data() as Map;
            Map<String, dynamic> sharedUsers =
                shared['compartir'] as Map<String, dynamic>;
            sharedUsers.forEach((key, value) {
              listID.add(key.toString());
              listToken.add(value.toString());
            });

            // await requestPermission();
            for (var i = 0; i < listID.length; i++) {
              if (listID[i] != currentUser.uid) {
                await sendPushMessage(
                  title: message.notification?.title ?? 'NaN',
                  body: message.notification?.body ?? 'NaN',
                  token: listToken[i],
                );
              }
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      });
      initLocalNotifications();
    });
  }
}

Future<void> handleBackgroundMessaging(RemoteMessage message) async {
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference userColection =
      FirebaseFirestore.instance.collection('usuarios');

  await Firebase.initializeApp();

  await userColection
      .doc(currentUser!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      List<String> listID = [];
      List<String> listToken = [];
      // Map<String, bool> auxSharedWith = sharedWith;
      // List? auxValues = values;
      try {
        Map shared = documentSnapshot.data() as Map;
        Map<String, dynamic> sharedUsers =
            shared['compartir'] as Map<String, dynamic>;
        sharedUsers.forEach((key, value) {
          listID.add(key.toString());
          listToken.add(value.toString());
        });

        // await requestPermission();
        for (var i = 0; i < listID.length; i++) {
          if (listID[i] != currentUser.uid) {
            await sendPushMessage(
              title: message.notification?.title ?? 'NaN',
              body: message.notification?.body ?? 'NaN',
              token: listToken[i],
            );
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  });
  if (kDebugMode) {
    debugPrint('TITULO: ${message.notification?.title}');
    debugPrint('CUERPO: ${message.notification?.body}');
    debugPrint('PLAYLOAD: ${message.data}');
  }
}

Future<void> requestPermission() async {
  FirebaseMessaging messa = FirebaseMessaging.instance;

  NotificationSettings settings = await messa.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('user granted permission 1');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('user granted permission 2');
  } else {
    print('user granted permission 3');
  }
}

Future<void> sendPushMessage(
    {String? token, String? body, String? title}) async {
  try {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAw-1Vpac:APA91bG-ECTVuP3AZmiW7HM7X7lpbrtWi-AAjpQuCi_HHSYfPJC0ukda2g3kHBjDkhUHzRoQJR7vcNexmASW_Rsi-cA5B4Xx4C1TkPgJlHEX9sM-41qnyQlDdMDP7m3T0WeTNPwvvvEF'
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'android_channel_id': 'dbfood'
          },
          'to': token
        }));
  } catch (e) {
    print('++++++++++++++++++++++++++++++');
    print(e.toString());
  }
}

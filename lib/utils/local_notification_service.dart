import 'dart:developer';

import 'package:autoclinch_customer/screens/home/home_main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void initlocalNot(BuildContext context, RemoteMessage message) async {
    var andriodInitilisattionSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var inilializeseeting =
        InitializationSettings(android: andriodInitilisattionSettings);
    await _flutterLocalNotificationsPlugin.initialize(
      inilializeseeting,
      onDidReceiveBackgroundNotificationResponse: (payload) => {},
    );
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void firebaseinit() {
    FirebaseMessaging.onMessage.listen((event) {
      print(event.notification!.title.toString());
      display(event);
    });
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        criticalAlert: true,
        badge: true,
        carPlay: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Grated');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Provisional');
    } else {
      print('denied');
    }
  }

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings(
        "@mipmap/ic_launcher",
      ),
    );
    _notificationsPlugin.initialize(
        initializationSettings /*, onSelectNotification: (String? route) async {
      if (route != null) {
        ////("ROUTEID");
        ////(route);
        // Navigator.of(context).pushReplacementNamed("/home", arguments: route);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeMainScreen(id: route)),
          (Route<dynamic> route) => false,
        );
        // Navigator.of(context).pushNamed(route);
      }
    }*/
        );
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final sound = 'notification_sound.wav';
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "autoclinchcustomer new",
        "autoclinchcustomer channel",
        importance: Importance.high,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        channelShowBadge: true,
        visibility: NotificationVisibility.public,
      ));

      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.title, notificationDetails,
          payload: message.data["id"]);
    } on Exception {
      log('Failed to show notification');
    }
  }
}

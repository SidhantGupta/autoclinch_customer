import 'dart:developer';
/*
import 'package:autoclinch_customer/screens/home/home_main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
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
*/
import 'dart:io';

import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/notifiers/home_notifiers.dart';
import 'package:autoclinch_customer/notifiers/loader_notifier.dart';
import 'package:autoclinch_customer/routes.dart';
import 'package:autoclinch_customer/utils/local_notification_service.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/notifiers/otp_notifers.dart' show OtpLoadingNotifier;
import 'screens/splash.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'autoclinchcustomer', // id
//     'High Importance Notifications', // title
//     'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  ////('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // LocalNotificationService.initialize();

  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => HomeLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => HomeVendorsNotifier()),
      ChangeNotifierProvider(create: (context) => HomeLocationNotifier()),
      ChangeNotifierProvider(create: (context) => ProfileLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => EditProfileLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => AddVehicleLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => AddReviewNotifier()),
      ChangeNotifierProvider(create: (context) => PaymentLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => OtpLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => BookingLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => RegisterLoadingNotifier()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    ApiService().context = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AutoClinch',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 243, 64, 64),
        primarySwatch: Colors.blue,

        // Grey color Review subtitle  argb(255,190,195,199)
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 244, 132, 32),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyAppHome(title: "samle"),
      onGenerateRoute: (settings) {
        return Routes.onGenerateRoute(settings);
      },
    );
  }
}

class MyAppHome extends StatefulWidget {
  MyAppHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyAppHomeState createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  @override
  void initState() {
    super.initState();

    // LocalNotificationService.initialize(context);

    // Get the token each time the application loads
    FirebaseMessaging.instance.getToken().then((value) async {
      String? token = value;
      ////("TOken is ==================>");
      ////(token);
      await SharedPreferenceUtil().storeToken(token);
      // sendToken(token);
      // ////("NewTokenIs");
    });

    //gives you the message on which user taps
//and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        final routeId = message.data["id"];
        ////("ROUTE MESSAGE IS : " + routeFromMessage);

        // Navigator.of(context).pushNamed('/' + routeFromMessage);

        if (routeFromMessage == "home") {
          Navigator.of(context)
              .pushReplacementNamed("/home", arguments: routeId);
          // Navigator.of(context).pushReplacementNamed(routeName)
        }
      }
    });

//foreground work
    FirebaseMessaging.onMessage.listen((message) {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;

      if (message.notification != null) {
        ////(message.notification!.body);
        ////(message.notification!.title);
      }

      // LocalNotificationService.display(message);

      // LocalNotificationService.display(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      ////('A new onMessageOpenedApp event was published!');
      final routeFromMessage = message.data["route"];
      final routeId = message.data["id"];
      ////("ROUTE MESSAGE IS : " + routeFromMessage);
      if (routeFromMessage == "home") {
        Navigator.of(context).pushReplacementNamed("/home", arguments: routeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ApiService().context = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AutoClinch',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 243, 64, 64),
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 244, 132, 32),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        return Routes.onGenerateRoute(settings);
      },
    );
  }

  sendToken(String? tokenId) async {
    CommonResponse2? response = await ApiService().execute<CommonResponse2>(
      "customerapp/device-token-register",
      params: {
        'deviceToken': tokenId,
      },
      isAddCustomerToUrl: false,
    );
    //debugPrint("response: $response");
    if (response != null && response.success) {
      // if (response.data?.firstLogin == true) {
      //   await SharedPreferenceUtil().storeUserDetails(response.data);
      //   Navigator.of(context).pushReplacementNamed("/profiledetails");
      // } else {

      // if (response.data?.isApprove == true) {
      ////("Token Send successfully");
      // } else {
      //   ApiService().showToast(response.data?.message.toString());
      // }
      // }
    }
  }
}

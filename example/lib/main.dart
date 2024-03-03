import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:amicane_caller/amicane_caller.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const notificationChannelId = 'my_foreground';
const notificationId = 888;
final _bgService = FlutterBackgroundService();

final _amicaneCallerPlugin = AmicaneCaller();

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> onStart(ServiceInstance service) async {
  Future.delayed(const Duration(seconds: 30), () async {
    try {
      var random = await _amicaneCallerPlugin.placeCall("123456");
      print("---- BG:::::: platform version is $random");
    } catch(e) {
      print("Unable to place call from BG");
    }
    try {
      await _amicaneCallerPlugin.sendSMS("123456", "HI");
    } catch(e) {
      print("Unable to send an SMS from BG: $e");
    }

  });
}

Future<void> initializeService() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await _bgService.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: notificationChannelId,
        // this must match with notification channel you created above.
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration());

  _bgService.on('update').listen((event) {
    print('----------------------------------------------------');
    print(event);
    print('----------------------------------------------------');
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeService();


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = "Test";
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    // try {
    //   platformVersion = await _amicaneCallerPlugin.placeCall("") ??
    //       'Unknown platform version';
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}

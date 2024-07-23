import 'package:device_apps/device_apps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'functions/functions.dart';
import 'functions/notifications.dart';
import 'pages/loadingPage/loadingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bubble_head/bubble.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['push_type'].toString() == 'meta-request') {
    DeviceApps.openApp('package name');
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Firebase.initializeApp();
      var val = await Geolocator.getCurrentPosition();
      // ignore: prefer_typing_uninitialized_variables
      var id;
      if (inputData != null) {
        id = inputData['id'];
      }
      FirebaseDatabase.instance.ref().child('drivers/driver_$id').update({
        'lat-lng': val.latitude.toString(),
        'l': {'0': val.latitude, '1': val.longitude},
        'updated_at': ServerValue.timestamp
      });
      // ignore: empty_catches
    } catch (e) {}

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();
  initMessaging();
  checkInternetConnection();

  currentPositionUpdate();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final platforms = const MethodChannel('flutter.app/awake');
  // This widget is the root of your application.

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Workmanager().cancelAll();
    super.initState();
  }

  final Bubble _bubble =
      Bubble(showCloseButton: false, allowDragToClose: false);
  Future<void> startBubbleHead() async {
    try {
      await _bubble.startBubbleHead(sendAppToBackground: false);
    } on PlatformException {
      debugPrint('Failed to call startBubbleHead');
    }
  }

  Future<void> stopBubbleHead() async {
    try {
      await _bubble.stopBubbleHead();
    } on PlatformException {
      debugPrint('Failed to call stopBubbleHead');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      if (Platform.isAndroid &&
          userDetails.isNotEmpty &&
          userDetails['role'] == 'driver' &&
          userDetails['active'] == true) {
        updateLocation(10);
        startBubbleHead();
      } else {}
    }
    if (Platform.isAndroid && state == AppLifecycleState.resumed) {
      stopBubbleHead();
      Workmanager().cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;

    return GestureDetector(
        onTap: () {
          //remove keyboard on touching anywhere on the screen.
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Product Name',
          theme: ThemeData(),
          home: const LoadingPage(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
        ));
  }
}

void updateLocation(duration) {
  for (var i = 0; i < 15; i++) {
    Workmanager().registerPeriodicTask('locs_$i', 'update_locs_$i',
        initialDelay: Duration(minutes: i),
        frequency: const Duration(minutes: 15),
        constraints: Constraints(
            networkType: NetworkType.connected,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresDeviceIdle: false,
            requiresStorageNotLow: false),
        inputData: {'id': userDetails['id'].toString()});
  }
}

import 'dart:convert';

import 'package:fechallenge/features/home/domain/airport_model.dart';
import 'package:fechallenge/features/home/presentation/home_page.dart';
import 'package:fechallenge/services/firebase_messaging_service.dart';
import 'package:fechallenge/services/local_notification_service.dart';
import 'package:fechallenge/utils/location_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  switch (headlessEvent.name) {
    case bg.Event.LOCATION:
      bg.Location location = headlessEvent.event;
      print('[HeadlessTask] - Location received: $location');

      // Retrieve airport data from shared preferences
      String? airportDataString = prefs.getString('airportData');
      if (airportDataString != null) {
        List<dynamic> jsonData = json.decode(airportDataString);
        List<Airport> airportData = jsonData.map((e) => Airport.fromJson(e)).toList();

        // Send notification if near any airport
        LocationUtils.sendNotificationIfNearAirports(
          airportData,
          location.coords.latitude,
          location.coords.longitude,
        );
      }
      break;

  // Handle other events if necessary
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //notification initialization
  await NotificationServices.init();
  await FirebaseMessagingService.init();


  await initFirebaseCrashlytics();

  runApp(const ProviderScope(child: MyApp()));
  bg.BackgroundGeolocation.registerHeadlessTask(
      backgroundGeolocationHeadlessTask);

}

Future<void> initFirebaseCrashlytics() async {
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      //record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      //record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

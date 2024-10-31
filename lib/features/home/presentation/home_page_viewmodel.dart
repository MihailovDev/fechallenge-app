/// A state notifier for managing the state of the HomePage.
///
/// This file contains the [HomePageViewModel] class, which acts as the state
/// management layer for the HomePage in the application. The view model is responsible
/// for handling business logic, managing geolocation, and interacting with repositories
/// and services to fetch airport data and send notifications.
///
/// The [HomePageViewModel] class extends [StateNotifier] to manage the state of
/// [HomePageState]. It handles the following functionalities:
///
/// - Fetching airport data from a repository and updating the state accordingly.
/// - Configuring and managing geolocation to determine proximity to airports.
/// - Sending local notifications to users when they are within a specific distance
///   (e.g., 50 meters) of an airport.
///
/// Key Features:
/// - Uses Firebase Analytics to log specific events, such as notifications sent based on proximity.
/// - Uses Firebase Crashlytics to record any errors during data fetching.
/// - Sends local notifications to the user when near an airport, with the help of [NotificationServices].
///
/// Example usage:
/// ```dart
///   final homePageVM = ref.watch(homePageViewModelProvider.notifier);
///   final homePageState = ref.watch(homePageViewModelProvider);
/// ```
///
/// Dependencies:
/// - `flutter_riverpod` for state management.
/// - `firebase_analytics` for event logging.
/// - `firebase_crashlytics` for error logging.
/// - `flutter_background_geolocation` for background geolocation tracking.
/// - `local_notification_service.dart` for sending notifications.

import 'dart:convert';
import 'dart:math';
import 'package:fechallenge/features/home/domain/home_page_state.dart';
import 'package:fechallenge/utils/app_logger.dart';
import 'package:fechallenge/utils/location_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fechallenge/features/home/application/providers.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:fechallenge/services/local_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageViewModel extends StateNotifier<HomePageState> {
  HomePageViewModel(this.ref) : super(HomePageState()) {
    _fetchAirportData();
  }

  final Ref ref;
  bool _isGeolocationConfigured = false;

  /// Fetches airport data from the [AirportRepository] and updates the state.
  ///
  /// This method interacts with the [AirportRepository] to retrieve airport data.
  /// It updates the state with the fetched data and initiates the geolocation configuration.
  /// If an error occurs during fetching, it logs the error to Firebase Crashlytics and updates the state with the error message.
  void _fetchAirportData() async {
    final airportRepo = ref.read(airportRepositoryProvider);
    try {
      final data = await airportRepo.fetchData();
      state = state.copyWith(airportData: data);

      // Store airport data in SharedPreferences for use in headless task
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String airportDataString = json.encode(data.map((e) => e.toJson()).toList());
      await prefs.setString('airportData', airportDataString);

      _configureBackgroundGeolocation();
    } catch (e, stackTrace) {
      AppLogger.logger.e('Error fetching airport data: $e');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      state = state.copyWith(errorMessage: e.toString());
    }
  }
  /// Configures background geolocation and handles location updates.
  ///
  /// This method configures the geolocation settings to track the user's location.
  /// If the user is within 50 meters of any airport in the fetched data, a local notification is sent.
  /// Firebase Analytics is used to log proximity-based notification events.
  void _configureBackgroundGeolocation() async {
    if (_isGeolocationConfigured) return;
    _isGeolocationConfigured = true;

    bg.BackgroundGeolocation.ready(bg.Config(
      enableHeadless: true,
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 30.0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    )).then((bg.State bgState) {
      if (!bgState.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      final airportData = state.airportData;
      if (airportData == null) {
        return;
      }

      LocationUtils.sendNotificationIfNearAirports(
        airportData,
        location.coords.latitude,
        location.coords.longitude,
      );
    });
  }

  /// Calculates the distance between two coordinates using the Haversine formula.
  ///
  /// [lat1], [lon1] are the latitude and longitude of the first point.
  /// [lat2], [lon2] are the latitude and longitude of the second point.
  ///
  /// Returns the distance between the two points in meters.
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Haversine formula to calculate distance between two coordinates
    const double earthRadius = 6371000; // Earth radius in meters
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in meters
  }

  /// Converts degrees to radians.
  ///
  /// [degrees] is the angle in degrees.
  ///
  /// Returns the angle in radians.
  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

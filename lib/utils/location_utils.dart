import 'dart:math';
import 'package:fechallenge/services/local_notification_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fechallenge/utils/app_logger.dart';
import 'package:fechallenge/features/home/domain/airport_model.dart';

class LocationUtils {
  // Method to calculate distance between two coordinates using Haversine formula
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
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

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Method to send notification if within proximity of an airport
  static void sendNotificationIfNearAirports(
      List<Airport> airportData, double currentLat, double currentLon) {
    for (var airport in airportData) {
      double distance = calculateDistance(
        currentLat,
        currentLon,
        double.parse(airport.lat ?? "0"),
        double.parse(airport.lon ?? "0"),
      );

      if (distance <= 50) {
        NotificationServices.sendInstantNotification(
          title: "You are near ${airport.name}",
          body: "You are within ${distance.toStringAsFixed(2)} meters of ${airport.name}",
          payload: "payload",
        );
        FirebaseAnalytics.instance.logEvent(
          name: 'notification_sent_proximity',
          parameters: {
            'airport_name': airport.name ?? 'no name',
            'distance_meters': distance,
          },
        );
        AppLogger.logger.i(
          'User is within ${distance.toStringAsFixed(2)} meters of ${airport.name}, notification sent.',
        );
        break; // Exit loop after the first match
      }
    }
  }
}

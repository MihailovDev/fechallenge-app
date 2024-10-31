/// A service class for managing local notifications in the application.
///
/// This file contains the [NotificationServices] class, which provides the functionality
/// for initializing, requesting permissions, sending, and handling local notifications.
/// The service utilizes Flutter's local notification package to interact with both
/// Android and iOS devices and manages permission requests and settings access.
///
/// Key Features:
/// - Requests notification permissions for Android and iOS devices.
/// - Initializes the notification settings and sets up handlers for notifications.
/// - Sends local notifications with customizable content.
/// - Logs notification events and errors using [AppLogger] and Firebase services.
///
/// Example usage:
/// ```dart
/// await NotificationServices.init(); // Initialize notifications
/// NotificationServices.sendInstantNotification(
///   title: 'Hello!',
///   body: 'This is a test notification.',
///   payload: 'payload_data',
/// );
/// ```
///
/// Dependencies:
/// - `flutter_local_notifications` for managing local notifications.
/// - `permission_handler` for requesting notification permissions.
/// - `app_logger.dart` for logging information and errors.
/// - `firebase_analytics` for logging notification-related events.
/// - `firebase_crashlytics` for recording errors related to notifications.

import 'package:app_settings/app_settings.dart';
import 'package:fechallenge/utils/app_logger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// A service class to manage local notifications in the app.
class NotificationServices {
  /// The local notifications plugin instance.
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// A [GlobalKey] for navigation, used to handle navigation upon receiving notifications.
  static GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

  /// Default notification details used for sending notifications.
  static NotificationDetails notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      "channelId",
      "channelName",
      priority: Priority.high,
      importance: Importance.high,
      icon: "@mipmap/ic_launcher",
    ),
  );

  /// Initializes the local notification services.
  ///
  /// This method initializes the local notification settings, sets up
  /// handlers for when a notification is received (in both foreground and background),
  /// and logs the initialization event.
  ///
  /// Example usage:
  /// ```dart
  /// await NotificationServices.init();
  /// ```
  static Future<void> init() async {
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    AppLogger.logger.i('Notifications have been initialized.');
    FirebaseAnalytics.instance.logEvent(
      name: 'notifications_enabled',
    );
  }

  /// Requests notification permissions for the user.
  ///
  /// This method uses the [permission_handler] package to request notification permissions.
  /// If the user does not grant permissions, it prompts the user to open the app settings.
  ///
  /// Example usage:
  /// ```dart
  /// NotificationServices.askForNotificationPermission();
  /// ```
  static void askForNotificationPermission() {
    Permission.notification.request().then((permissionStatus) {
      if (permissionStatus != PermissionStatus.granted) {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
        AppLogger.logger.i('Notification permission granted');
      }
    });
  }

  /// Sends an instant local notification.
  ///
  /// [title]: The title of the notification.
  /// [body]: The body content of the notification.
  /// [payload]: The payload data that can be used for navigation or other purposes.
  ///
  /// Example usage:
  /// ```dart
  /// NotificationServices.sendInstantNotification(
  ///   title: 'Test Title',
  ///   body: 'This is a test notification',
  ///   payload: 'some_payload',
  /// );
  /// ```
  ///
  /// If an error occurs while sending the notification, it logs the error using
  /// Firebase Crashlytics.
  static void sendInstantNotification({required String title, required String body, required String payload}) {
    try {
      flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      AppLogger.logger.i('Notification sent: Title: $title, Body: $body, Payload: $payload');
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  /// Handles notification responses when a notification is received while the app is in the foreground.
  ///
  /// This method is called whenever the user interacts with a notification while the app is open.
  ///
  /// [response] contains the details of the notification response.
  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    AppLogger.logger.i('Received notification response');
  }

  /// Handles background notification responses.
  ///
  /// This method is called when a notification is received while the app is in the background.
  ///
  /// [response] contains the details of the background notification response.
  static void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
    AppLogger.logger.i('Received background notification');
  }
}

/// A provider for accessing [NotificationServices] via Riverpod.
///
/// This provider ensures that notification services are initialized
/// when the provider is first read. It is useful for injecting
/// and accessing notification services throughout the app using Riverpod.
///
/// Example usage:
/// ```dart
/// final notificationService = ref.read(notificationServicesProvider);
/// ```
final notificationServicesProvider = Provider<NotificationServices>((ref) {
  // Initialize the notification services when the provider is first read
  NotificationServices.init();
  return NotificationServices();
});

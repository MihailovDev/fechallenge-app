/// A service class for managing Firebase Cloud Messaging (FCM) in the application.
///
/// This file contains the [FirebaseMessagingService] class, which encapsulates
/// the functionality needed to set up and manage Firebase Messaging for receiving
/// push notifications. It provides methods to initialize the service, handle
/// incoming messages in various states, and retrieve the device token for FCM.
///
/// Key Features:
/// - Requests permissions for notifications on iOS/Android devices.
/// - Sets up handlers for handling foreground, background, and terminated state notifications.
/// - Logs notification events using [AppLogger] for better monitoring and debugging.
///
/// Example usage:
/// ```dart
/// await FirebaseMessagingService.init();
/// ```
///
/// Dependencies:
/// - `firebase_messaging` for handling FCM notifications.
/// - `app_logger.dart` for logging information about incoming notifications.

import 'package:fechallenge/utils/app_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// A service class that manages Firebase Messaging initialization and message handling.
class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initializes the Firebase Messaging service and sets up handlers for different notification states.
  ///
  /// This method should be called during app initialization to request notification permissions
  /// and set up handlers to respond to notifications in various states, including:
  /// - Foreground messages
  /// - Background messages
  /// - Messages that open the app
  ///
  /// Example usage:
  /// ```dart
  /// await FirebaseMessagingService.init();
  /// ```
  static Future<void> init() async {
    // Request permission for iOS/Android notifications
    await _firebaseMessaging.requestPermission();

    // Set up handlers for foreground, background, and terminated states
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Handler for receiving notifications when the app is in the foreground.
  ///
  /// Logs information about the received notification, including its details if available.
  ///
  /// [message] is the incoming notification's data and content.
  static void _onMessageHandler(RemoteMessage message) {
    AppLogger.logger.i('[Firebase] Received firebase notification response');
    if (message.notification != null) {
      AppLogger.logger.i('[Firebase] Message also contained a notification ${message.notification}');
    }
  }

  /// Handler for notifications that are opened from the background.
  ///
  /// This method is called when the user interacts with a notification while the app is in the background
  /// and brings the app to the foreground.
  ///
  /// [message] contains the data of the notification that was interacted with.
  static void _onMessageOpenedAppHandler(RemoteMessage message) {
    AppLogger.logger.i('[Firebase] Firebase message opened from background');
  }

  /// Handler for receiving notifications while the app is in the background or terminated.
  ///
  /// This method is annotated with `@pragma('vm:entry-point')` to ensure it can be called
  /// even when the app is fully terminated.
  ///
  /// [message] is the notification's data received while the app is not active.
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    AppLogger.logger.i('[Firebase] Received firebase notification response while app in background');
  }

  /// Retrieves the Firebase Cloud Messaging device token.
  ///
  /// The device token is used to uniquely identify a device for sending push notifications.
  ///
  /// Returns a [String] containing the FCM token or `null` if the token cannot be retrieved.
  ///
  /// Example usage:
  /// ```dart
  /// String? token = await FirebaseMessagingService.getToken();
  /// ```
  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}

/// This files contains the simple riverpod providers.
/// Currently we have a simple provider for the FirebaseMessagingService and the NotificationServices.

import 'package:fechallenge/services/firebase_messaging_service.dart';
import 'package:fechallenge/services/local_notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((ref) {
  FirebaseMessagingService.init();
  return FirebaseMessagingService();
});

final notificationServicesProvider = Provider<NotificationServices>((ref) {
  // Initialize notification services when the provider is first accessed
  NotificationServices.init();
  return NotificationServices();
});


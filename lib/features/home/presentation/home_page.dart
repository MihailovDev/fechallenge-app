import 'package:fechallenge/features/home/application/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fechallenge/services/local_notification_service.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homePageState = ref.watch(homePageViewModelProvider);

    if (homePageState.errorMessage != null) {
      // Error occurred
      return Scaffold(
        body: Center(child: Text('Error: ${homePageState.errorMessage}')),
      );
    }

    if (homePageState.airportData == null) {
      // Data is still loading
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Data is loaded
    final data = homePageState.airportData!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Data: ${data[1].toJson().toString()}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                NotificationServices.sendInstantNotification(
                  title: "Test Notification",
                  body: "This is a test notification",
                  payload: "payload",
                );
              },
              child: const Text("Send Notification"),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

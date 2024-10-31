# fechallenge app


fechallenge app is a Flutter application that tracks the user's location and sends a local notification when the user is within 50 meters of any airport in the provided dataset. The app uses background geolocation to monitor the user's location even when the app is not in the foreground. It integrates with Firebase services for analytics and error logging.


## Features

- Fetch Airport Data: Retrieves a list of airports from a remote API and stores it locally.
- Background Geolocation: Continuously tracks the user's location, even when the app is closed or in the background.
- Proximity Notifications: Sends a local notification when the user is within 50 meters of an airport.
- Firebase Integration:
    - Analytics: Logs events such as proximity notifications for analysis.
    - Crashlytics: Captures and reports errors and exceptions for debugging.

## Project Structure

```bash
lib
├── features
│   └── home
│       ├── application
│       │   └── providers.dart
│       ├── data
│       │   ├── airport_exception.dart
│       │   └── airport_repository.dart
│       ├── domain
│       │   ├── airport_model.dart
│       │   └── home_page_state.dart
│       └── presentation
│           ├── home_page.dart
│           └── home_page_viewmodel.dart
├── services
│   ├── application
│   │   └── providers.dart
│   ├── firebase_messaging_service.dart
│   └── local_notification_service.dart
├── utils
│   ├── app_logger.dart
│   └── location_utils.dart
├── firebase_options.dart
└── main.dart
```
- features/home: Contains the core functionality related to the home screen.
    - application: Riverpod providers for state management.
    - data: Repositories and exceptions for data handling.
      domain: Models and state classes.
    - presentation: UI components and view models.
- services: Contains services for notifications and messaging.
    -  application: Providers for service classes.
    - firebase_messaging_service.dart: Manages Firebase Cloud Messaging.
    - local_notification_service.dart: Manages local notifications.
- utils: Utility classes for logging and location calculations.
- firebase_options.dart: Firebase configuration (auto-generated).
- main.dart: Entry point of the application.

## Setup Instructions
### Prerequisites
Ensure you have the following installed:

- Flutter SDK: [Install Flutter](https://flutter.dev/)
- Dart SDK: Comes with Flutter.
- IDE/Text Editor: [Android Studio](https://developer.android.com/), VS Code, etc.
- Firebase Account: [Create a Firebase account](https://firebase.google.com/)

### Firebase setup
The app uses Firebase services:

- Firebase Analytics
- Firebase Crashlytics
- Firebase Cloud Messaging (FCM)

#### Steps to Set Up Firebase

- **Create a firebase project**
    - Go to [Firebase Console](https://console.firebase.google.com/) and create a new project.

- **Add an Android App**
    - In your Firebase project, click **Add app** and select **Android**.
    - Enter your Android package name (e.g., com.example.fechallenge).
    - Register the app
- **Download google-services.json**
    - After registering, download the google-services.json file.
    - Place it in your Flutter project's android/app/ directory.
- **Add Firebase SDK**
    - Add Firebase dependencies to pubspec.yaml
    - Run flutter pub get to install.
```python
dependencies:
  firebase_core: ^2.15.1
  firebase_analytics: ^10.4.1
  firebase_crashlytics: ^3.3.6
  firebase_messaging: ^14.6.4
```

## Running the App
- **Connect a Device or Emulator**
    - For accurate location tracking, use a physical device.
    - If using an emulator, ensure it supports Google Play services.
- **Run the app**
```bash
flutter run
```
- **Grant Permissions**
    - The app will request location, motion and notification permissions.

## Testing the App

**Emulator**

I was not able to use the emulators Location controls to test it. Maybe if i spend more time on it I will fix it during the weekend.

**Physical Device**

Try using a spoofing app to simulate location, or just go near an airport that is in [this](https://raw.githubusercontent.com/jbrooksuk/JSON-Airports/master/airports.json) list. :)

I tested the notification sending with my own device as i was walking around the apartment. It works even if the app is terminated, but this is not an approach i would recommend for a production app.

**Analytics and Crashlytics**

This data is available in the Firebase Console. 



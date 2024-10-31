/// A state management model for the HomePage.
///
/// This file contains the [HomePageState] class, which represents the state of the
/// home page in the application. The state includes information about the airport data
/// as well as any error messages that may have occurred during data fetching.
///
/// The [HomePageState] class provides:
/// - `airportData`: A list of [Airport] objects representing the fetched airport data.
/// - `errorMessage`: A message indicating any error that occurred during data retrieval.
/// - The [copyWith] method, which allows creating a modified copy of an existing
///   [HomePageState] instance while preserving unchanged fields.
///
///
/// Example usage:
/// ```dart
/// final state = HomePageState(airportData: fetchedAirports);
/// final updatedState = state.copyWith(errorMessage: 'Some error occurred');
/// ```
///
/// Dependencies:
/// - `Airport` model from `airport_model.dart` to represent the list of airports.

import 'package:fechallenge/features/home/domain/airport_model.dart';

class HomePageState {
  final List<Airport>? airportData;
  final String? errorMessage;

  HomePageState({this.airportData, this.errorMessage});

  HomePageState copyWith({
    List<Airport>? airportData,
    String? errorMessage,
  }) {
    return HomePageState(
      airportData: airportData ?? this.airportData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

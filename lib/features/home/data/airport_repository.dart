/// A repository for fetching airport data from a remote API.
///
/// This file contains the [AirportRepository] class, which provides methods to retrieve
/// airport data by making HTTP requests. The repository abstracts the data fetching logic,
/// making it easier to manage and test network interactions.
///
/// The [AirportRepository] uses the following components:
/// - The `http` package for handling network requests.
/// - The `Airport` model to represent each airport fetched from the remote data source.
/// - Custom exceptions, such as [UnknownException] and [NoInternetConnectionException],
///   for error handling related to network issues or unexpected server responses.
///
/// The repository fetches data from the provided base URL, which returns a list of airports in JSON format.
///
/// Example usage:
/// ```dart
/// final airportRepository = AirportRepository(client: http.Client());
/// final airports = await airportRepository.fetchData();
/// ```
///
/// Dependencies:
/// - `dart:convert` for JSON decoding.
/// - `dart:io` for socket exceptions.
/// - `http` for making HTTP requests.
///
/// Environment variables:
/// - [baseUrl]: The base URL for fetching airport data. This URL can be moved to an environment file for easier configuration.

import 'dart:convert';
import 'dart:io';
import 'package:fechallenge/features/home/domain/airport_model.dart';
import 'package:http/http.dart' as http;
import 'airport_exception.dart';



const String baseUrl = "https://raw.githubusercontent.com/jbrooksuk/JSON-Airports/master/airports.json"; // can be in env file

class AirportRepository {
  final http.Client client;

  AirportRepository({
    required this.client,
  });

  Future<List<Airport>> fetchData() async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await client.get(url);
      switch (response.statusCode) {
        case 200:
          final List<dynamic> jsonData = json.decode(response.body);
          final List<Airport> airports = jsonData
              .map((airportJson) => Airport.fromJson(airportJson))
              .toList();
          return airports;
        default:
          throw UnknownException();
      }
    } on SocketException catch (_) {
      throw NoInternetConnectionException();
    }
  }
}

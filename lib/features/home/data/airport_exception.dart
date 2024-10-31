/// A base class representing exceptions related to airport operations.
///
/// [AirportException] is used to handle different types of errors that can occur
/// during airport data retrieval or processing. It is a sealed class, meaning it
/// cannot be extended outside its own library, ensuring a controlled set of
/// exception types.
///
/// Subclasses:
/// - [UnknownException]: Represents an unspecified error, with a generic message.
/// - [NoInternetConnectionException]: Represents an error due to no internet connection.

sealed class AirportException implements Exception {
  AirportException(this.message);

  final String message;
}

class UnknownException extends AirportException {
  UnknownException() : super('Some error occurred');
}
class NoInternetConnectionException extends AirportException {
  NoInternetConnectionException() : super('No Internet connection');
}
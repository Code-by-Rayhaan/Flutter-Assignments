/// Base class for all API-related exceptions.
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => '[$runtimeType]${statusCode != null ? " (Code: $statusCode)" : ""}: $message';
}

/// Thrown when a requested resource is not found (404).
class NotFoundException extends ApiException {
  final String resource;

  const NotFoundException(this.resource)
      : super('Resource "$resource" could not be found.', 404);
}

/// Thrown when the server responds with a 5xx error.
class ServerException extends ApiException {
  const ServerException([String message = 'Internal Server Error. Please try again later.'])
      : super(message, 500);
}

/// Thrown when there is no internet connection or a socket error occurs.
class NetworkException extends ApiException {
  const NetworkException([String message = 'Network connection failed. Please check your internet.'])
      : super(message, 503);
}

/// Thrown when response data cannot be parsed (e.g., missing required fields or type mismatch).
class DataParsingException extends ApiException {
  final String? fieldName;

  const DataParsingException(String message, [this.fieldName])
      : super(
          fieldName != null
              ? 'Parsing Error on field "$fieldName": $message'
              : 'Parsing Error: $message',
          422,
        );
}

/// Thrown when an asynchronous request exceeds its allocated time limit.
class ApiTimeoutException extends ApiException {
  final Duration duration;

  ApiTimeoutException(this.duration)
      : super('Request timed out after ${duration.inSeconds}s.', 408);
}

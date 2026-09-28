import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';

/// Custom exception thrown when API operations fail.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status code: $statusCode)' : ''}';
}

/// Service responsible for fetching data from the JSONPlaceholder REST API.
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration timeoutDuration = Duration(seconds: 10);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the list of posts from the REST API endpoint `/posts`.
  /// Throws [ApiException], [TimeoutException], or [SocketException] on network failure.
  Future<List<Post>> fetchPosts() async {
    final Uri url = Uri.parse('$baseUrl/posts');

    try {
      final http.Response response = await _client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> decodedJson =
            jsonDecode(response.body) as List<dynamic>;
        return Post.fromJsonList(decodedJson);
      } else {
        throw ApiException(
          'Failed to load posts from server.',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(
        'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      throw ApiException(
        'Connection timed out. The server took too long to respond.',
      );
    } on FormatException {
      throw ApiException(
        'Bad response format received from server.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected network error: $e');
    }
  }
}
